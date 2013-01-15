#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=2

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for spine two layer interface Navier Stokes problem
#---------------------------------------------------------------
cd Validation

echo "Running spine two layer interface Navier Stokes validation "
mkdir RESLT
../spine_two_layer_interface dummy_input > OUTPUT_spine_two_layer_interface
echo "done"
echo " " >> validation.log
echo "Spine two layer interface Navier--Stokes validation" >> validation.log
echo "---------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT/soln0.dat  RESLT/soln1.dat RESLT/soln2.dat > results_spine_two_layer_interface.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_spine_two_layer_interface.dat.gz results_spine_two_layer_interface.dat 0.1 2.0e-11 >> validation.log
fi

mv RESLT RESLT_spine_two_layer_interface



# Validation for elastic two layer interface Navier Stokes problem
#---------------------------------------------------------------

echo "Running elastic two layer interface Navier Stokes validation "
mkdir RESLT
../elastic_two_layer_interface dummy_input > OUTPUT_elastic_two_layer_interface
echo "done"
echo " " >> validation.log
echo "Elastic two layer interface Navier--Stokes validation" >> validation.log
echo "-----------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT/soln0.dat  RESLT/soln1.dat RESLT/soln2.dat > results_elastic_two_layer_interface.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_elastic_two_layer_interface.dat.gz results_elastic_two_layer_interface.dat 0.1 3.0e-9 >> validation.log
fi

mv RESLT RESLT_elastic_two_layer_interface



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
