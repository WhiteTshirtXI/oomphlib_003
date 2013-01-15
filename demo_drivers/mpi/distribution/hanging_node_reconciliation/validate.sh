#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=3


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

#----------------------------------------------------------------------

# Validation for adaptive driven cavity (TH & CR)
#------------------------------------------------

echo "Running adaptive rectangular driven cavity (TH & CR) validation (for checking sync of hanging node)"
mkdir RESLT_CR_MESH  RESLT RESLT_TH_MESH


# Wait for a bit to allow parallel file systems to realise
# the existence of the new directory
sleep 5

$MPI_RUN_COMMAND ../adaptive_driven_cavity validate > OUTPUT_adaptive_driven_cavity
echo "done"
echo " " >> validation.log
echo "Adaptive rectangular driven cavity (TH & CR) validation (for checking sync of hanging node)" >> validation.log
echo "--------------------------------------------------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/nodes0_on_proc0.dat RESLT/nodes0_on_proc1.dat \
    > adaptive_cavity_TH_results.dat
cat RESLT/nodes1_on_proc0.dat RESLT/nodes1_on_proc1.dat \
    > adaptive_cavity_CR_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../../bin/fpdiff.py ../validata/adaptive_cavity_TH_results.dat.gz  \
         adaptive_cavity_TH_results.dat >> validation.log
../../../../../bin/fpdiff.py ../validata/adaptive_cavity_CR_results.dat.gz  \
         adaptive_cavity_CR_results.dat >> validation.log
fi

# Validation for hp-adaptive driven cavity (CR)
#----------------------------------------------

echo "Running hp-adaptive rectangular driven cavity (CR) validation (for checking sync of hanging node)"
mkdir RESLT_hp RESLT_hp_MESH

#Get partitioning file
cp ../hp_adaptive_cavity_partition.dat .

# Wait for a bit to allow parallel file systems to realise
# the existence of the new directory
sleep 5

$MPI_RUN_COMMAND ../hp_adaptive_driven_cavity validate > OUTPUT_hp_adaptive_driven_cavity
echo "done"
echo " " >> validation.log
echo "hp-daptive rectangular driven cavity (CR) validation (for checking sync of hanging node)" >> validation.log
echo "--------------------------------------------------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT_hp/nodes0_on_proc0.dat RESLT_hp/nodes0_on_proc1.dat \
    > adaptive_cavity_hp_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../../bin/fpdiff.py ../validata/adaptive_cavity_hp_results.dat.gz  \
         adaptive_cavity_hp_results.dat >> validation.log
fi

mv RESLT RESLT_adaptive_driven_cavity
mv RESLT_hp RESLT_hp_adaptive_driven_cavity
mv RESLT_TH_MESH  RESLT_TH_MESH_adaptive_driven_cavity
mv RESLT_CR_MESH  RESLT_CR_MESH_adaptive_driven_cavity
mv RESLT_hp_MESH  RESLT_hp_MESH_adaptive_driven_cavity

# Append log to main validation log
cat validation.log >> ../../../../../validation.log

#-----------------------------------------------------------------------


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
