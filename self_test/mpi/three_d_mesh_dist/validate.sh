#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=2

# Doc what we're using to run tests on two processors
echo " " 
echo "Running mpi tests with mpi run command: " $MPI_RUN_COMMAND
echo " " 

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

cd Validation
cp ../*partition.dat .

# Validation for 3D mesh distribution test
#-----------------------------------------

echo "Running 3D mesh distribution problem "
mkdir RESLT
$MPI_RUN_COMMAND ../three_d_mesh_dist > OUTPUT_three_d_mesh_dist
echo "done"
echo " " >> validation.log
echo "3D mesh distribution validation" >> validation.log
echo "------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/mesh0_0.dat RESLT/mesh1_0.dat RESLT/haloed_nodes_on_proc0_0.dat \
    RESLT/haloed_nodes_on_proc1_0.dat RESLT/halo_elements_on_proc0_0.dat \
    RESLT/halo_elements_on_proc1_0.dat > three_d_mesh_dist_results.dat
cat RESLT/soln0_on_proc0.dat RESLT/soln0_on_proc1.dat RESLT/soln1_on_proc0.dat \
    RESLT/soln1_on_proc1.dat \
    > three_d_soln_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/three_d_mesh_dist_results.dat.gz  \
         three_d_mesh_dist_results.dat >> validation.log
../../../../bin/fpdiff.py ../validata/three_d_soln_results.dat.gz  \
         three_d_soln_results.dat >> validation.log
fi

mv RESLT RESLT_three_d_mesh_dist

#----------------------------------------------------------------------

# Append log to main validation log
cat validation.log >> ../../../../validation.log

cd ..



#######################################################################


#Check that we get the correct number of OKs
OK_COUNT=`grep -c 'OK' Validation/validation.log`
if  [ $OK_COUNT -eq $NUM_TESTS ]; then
 echo " "
 echo "======================================================================"
 echo " " 
 echo "All tests in" 
 echo " " 
 echo "    `pwd`    "
 echo " "
 echo "passed successfully."
 echo " "
 echo "======================================================================"
 echo " " 
else
  if [ $OK_COUNT -lt $NUM_TESTS ]; then
   echo " "
   echo "======================================================================"
   echo " " 
   echo "Only $OK_COUNT of $NUM_TESTS test(s) passed; see"
   echo " " 
   echo "    `pwd`/Validation/validation.log"
   echo " " 
   echo "for details" 
   echo " " 
   echo "======================================================================"
   echo " "
  else 
   echo " "
   echo "======================================================================"
   echo " " 
   echo "More OKs than tests! Need to update NUM_TESTS in"
   echo " " 
   echo "    `pwd`/validate.sh"
   echo " "
   echo "======================================================================"
   echo " "
  fi
fi
