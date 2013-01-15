#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=2

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

cd Validation



# Validation for oscillating ring Navier Stokes with algebraic mesh update
#-------------------------------------------------------------------------

echo "Running algebraic oscillating ring Navier-Stokes validation "
mkdir RESLT
mkdir RESLT_restarted
# Run with two command line arguments so we only do three steps
../osc_ring_alg lala lala > OUTPUT_osc_ring_alg
echo "done"
echo " " >> validation.log
echo "Algebraic oscillating ring Navier Stokes validation" >> validation.log
echo "---------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log

cat RESLT/soln0.dat \
    RESLT/soln3.dat \
    > osc_ring_alg_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/osc_ring_alg_results.dat.gz  \
         osc_ring_alg_results.dat >> validation.log
fi

mv RESLT RESLT_osc_ring_alg
mv RESLT_restarted RESLT_osc_ring_alg_restarted



# Validation for osc ring Navier Stokes with macro-element-based mesh update
#---------------------------------------------------------------------------

echo "Running oscillating ring Navier-Stokes validation with macro-element-based mesh update "
mkdir RESLT
mkdir RESLT_restarted
# Run with two command line arguments so we only do three steps
../osc_ring_macro lala lala > OUTPUT_osc_ring_macro
echo "done"
echo " " >> validation.log
echo "Macro-element oscillating ring Navier Stokes validation" >> validation.log
echo "---------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log

cat RESLT/soln0.dat \
    RESLT/soln3.dat \
    RESLT_restarted/soln2.dat \
    > osc_ring_macro_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/osc_ring_alg_results.dat.gz  \
         osc_ring_alg_results.dat >> validation.log
fi

mv RESLT RESLT_osc_ring_macro
mv RESLT_restarted RESLT_osc_ring_macro_restarted






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
