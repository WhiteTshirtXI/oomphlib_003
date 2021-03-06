/*
 * xfer_threads.cpp
 *
 *  Created on: Aug 20, 2012
 *      Author: raoldfi
 */

#include "Trios_nssi_server.h"
#include "Trios_logger.h"

#include <queue>
#include <pthread.h>

#include "xfer_debug.h"
#include "xfer_threads.h"



std::queue <nssi_svc_rpc_request *> pending_reqs;
pthread_cond_t pending_cond;
pthread_mutex_t pending_mutex;

static volatile bool time_to_exit=false;

static int max_num_reqs;
static std::queue<pthread_t> consumer_threads;

/** This is the consumer thread code.
 *  It pops requests off the pending queue and calls the
 *  process_rpc_request function.
 */
void *process_pending_reqs(void *arg)
{
    int rc;
    nssi_svc_rpc_request *req = NULL;
    log_level debug_level = LOG_ALL;

    intptr_t id = (intptr_t)arg;

    log_info(debug_level, "%d: starting thread", id);

    // do this outside the loop to prevent tons of calls
    pthread_mutex_lock(&pending_mutex);

    while (!time_to_exit) {

        if (!pending_reqs.empty()) {
            // pull the next request off the queue
            req = pending_reqs.front();
            pending_reqs.pop();

            // signal threads that the state of the queue has changed
            pthread_cond_signal(&pending_cond);

            // unlock the mutex while we process the request
            pthread_mutex_unlock(&pending_mutex);

            log_debug(debug_level, "%d: processing request %d", id, req->id);

            rc = nssi_process_rpc_request(req);
            if (rc) {
                log_error(xfer_debug_level, "%d: Error processing request", id);
                return NULL;
            }
            pthread_mutex_lock(&pending_mutex);
        }
        else {
            // this will block this thread until someone sends us a signal
            pthread_cond_wait(&pending_cond, &pending_mutex);
        }
    }

    pthread_mutex_unlock(&pending_mutex);

    log_info(debug_level, "%d: exiting process_pending_reqs thread", id);
    return NULL;
}



int xfer_start_server_threads(const int num_threads, const int max_reqs)
{
    pthread_t t;

    // initialize the condition and mutex variables for the pending queue
    pthread_cond_init(&pending_cond, NULL);  // default attributes
    pthread_mutex_init(&pending_mutex, NULL); // default attributes

    max_num_reqs = max_reqs;

    // start the consumer threads
    for (int i=0; i<num_threads; i++) {
        pthread_t tid;
        pthread_create(&tid, NULL, process_pending_reqs, (void *)i);
        consumer_threads.push(tid);
    }

}


/** All this function does is take the request and add it to the
 * pending request queue.  This is a replacement for process_rpc_request
 *  in the call to function nssi_server_start().
 */
int xfer_enqueue_rpc_request(nssi_svc_rpc_request *req)
{
    int rc = 0;

    // We wait if the numbe of pending requests is too large
    pthread_mutex_lock(&pending_mutex);
    while (pending_reqs.size() >= max_num_reqs) {
        pthread_cond_wait(&pending_cond, &pending_mutex);
    }

    log_debug(LOG_ALL, "Adding request %d to the pending queue", req->id);

    // ok to add the request
    pending_reqs.push(req);

    // tell the processing threads the queue has changed
    pthread_cond_signal(&pending_cond);

    pthread_mutex_unlock(&pending_mutex);
}

int xfer_cancel_server_threads()
{
    log_debug(LOG_ALL, "Canceling server threads");

    pthread_mutex_lock(&pending_mutex);
    time_to_exit = true;
    pthread_cond_broadcast(&pending_cond);
    pthread_mutex_unlock(&pending_mutex);

    while (!consumer_threads.empty()) {
        pthread_t tid = consumer_threads.front();
        consumer_threads.pop();
        pthread_join(tid, NULL);
    }

}

