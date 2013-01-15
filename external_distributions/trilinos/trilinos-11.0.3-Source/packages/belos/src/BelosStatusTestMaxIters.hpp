//@HEADER
// ************************************************************************
//
//                 Belos: Block Linear Solvers Package
//                  Copyright 2004 Sandia Corporation
//
// Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
// the U.S. Government retains certain rights in this software.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the Corporation nor the names of the
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Questions? Contact Michael A. Heroux (maherou@sandia.gov)
//
// ************************************************************************
//@HEADER
//
   
#ifndef BELOS_STATUS_TEST_MAXITERS_HPP
#define BELOS_STATUS_TEST_MAXITERS_HPP

/*!
  \file BelosStatusTestMaxIters.hpp
  \brief Belos::StatusTest class for specifying a maximum number of iterations.
*/

#include "BelosStatusTest.hpp"

/*! \class Belos::StatusTestMaxIters: 
    \brief A Belos::StatusTest class for specifying a maximum number of iterations.

    This implementation of the Belos::StatusTest base class tests the number of iterations performed
    against a maximum number allowed.
*/

namespace Belos {

template <class ScalarType, class MV, class OP>
class StatusTestMaxIters: public StatusTest<ScalarType,MV,OP> {

 public:

   //! @name Constructor/Destructor.
  //@{ 

  //! Constructor
  StatusTestMaxIters(int maxIters);

  //! Destructor
  virtual ~StatusTestMaxIters() {};
  //@}

  //! @name Status methods
  //@{ 

  //! Check convergence status of the iterative solver: Unconverged, Converged, Failed.
  /*! This method checks to see if the convergence criteria are met using the current information from the 
    iterative solver.
  */
  StatusType checkStatus(Iteration<ScalarType,MV,OP> *iSolver );

  //! Return the result of the most recent CheckStatus call.
  StatusType getStatus() const {return(status_);}

  //@}

  //! @name Reset methods
  //@{ 

  //! Resets the status test to the initial internal state.
  void reset();

  //! Sets the maximum number of iterations allowed.
  void setMaxIters(int maxIters) { maxIters_ = maxIters; }

  //@}

  //! @name Accessor methods
  //@{ 

  //! Returns the maximum number of iterations set in the constructor.
  int getMaxIters() const { return(maxIters_); }

  //! Returns the current number of iterations from the most recent StatusTest call.
  int getNumIters() const { return(nIters_); }

  //@}

  //! @name Print methods
  //@{ 

  //! Output formatted description of stopping test to output stream.
  void print(std::ostream& os, int indent = 0) const;

  //! Print message for each status specific to this stopping test.
  void printStatus(std::ostream& os, StatusType type) const;

  //@}
 
  /** \name Overridden from Teuchos::Describable */
  //@{

  /** \brief Method to return description of the maximum iteration status test  */
  std::string description() const 
  {  
    std::ostringstream oss; 
    oss << "Belos::StatusTestMaxIters<>: [ " << getNumIters() << " / " << getMaxIters() << " ]"; 
    return oss.str();
  }
  //@} 

private:

  //! @name Private data members.
  //@{ 
  //! Maximum number of iterations allowed
  int maxIters_;

  //! Current number of iterations
  int nIters_;

  //! Status
  StatusType status_;
  //@}

};

  template <class ScalarType, class MV, class OP> 
  StatusTestMaxIters<ScalarType,MV,OP>::StatusTestMaxIters(int maxIters)
  {
    if (maxIters < 1)
      maxIters_ = 1;
    else
      maxIters_ = maxIters;
    
    nIters_ = 0;
    status_ = Undefined;
  }
  
  template <class ScalarType, class MV, class OP>
  StatusType StatusTestMaxIters<ScalarType,MV,OP>::checkStatus(Iteration<ScalarType,MV,OP> *iSolver )
  {
    status_ = Failed;
    nIters_ = iSolver->getNumIters();
    if (nIters_ >= maxIters_)
      status_ = Passed;
    return status_;
  }
  
  template <class ScalarType, class MV, class OP>
  void StatusTestMaxIters<ScalarType,MV,OP>::reset()
  {
    nIters_ = 0;
    status_ = Undefined;
  }    
    
  template <class ScalarType, class MV, class OP>
  void StatusTestMaxIters<ScalarType,MV,OP>::print(std::ostream& os, int indent) const
  {
    for (int j = 0; j < indent; j ++)
      os << ' ';
    printStatus(os, status_);
    os << "Number of Iterations = ";
    os << nIters_;
    os << ((nIters_ < maxIters_) ? " < " : ((nIters_ == maxIters_) ? " == " : " > "));
    os << maxIters_;
    os << std::endl;
  }
 
  template <class ScalarType, class MV, class OP>
  void StatusTestMaxIters<ScalarType,MV,OP>::printStatus(std::ostream& os, StatusType type) const 
  {
    os << std::left << std::setw(13) << std::setfill('.');
    switch (type) {
    case  Passed:
      os << "Failed";
      break;
    case  Failed:
      os << "OK";
      break;
    case  Undefined:
    default:
      os << "**";
      break;
    }
    os << std::left << std::setfill(' ');
    return;
  } 

} // end Belos namespace

#endif /* BELOS_STATUS_TEST_MAXITERS_HPP */
