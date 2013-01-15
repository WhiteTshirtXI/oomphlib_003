#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=2


# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for demo linear_wave
#-------------------------
cd Validation

echo "Running 2D demo linear_wave validation "
mkdir RESLT_smooth
mkdir RESLT_impulsive

../two_d_linear_wave blabla > OUTPUT
echo "done"
echo " " >> validation.log
echo "2D demo linear_wave validation" >> validation.log
echo "-----------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT_smooth/soln0.dat RESLT_smooth/soln1.dat RESLT_smooth/soln2.dat \
RESLT_impulsive/soln0.dat RESLT_impulsive/soln1.dat RESLT_impulsive/soln2.dat \
 > results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results.dat.gz   \
    results.dat  >> validation.log
fi

mv RESLT_smooth RESLT_smooth_two_d_linear_wave
mv RESLT_impulsive RESLT_impulsive_two_d_linear_wave

# Do flux validation
echo "Running 2D demo linear_wave flux validation "
mkdir RESLT
../two_d_linear_wave_flux la la la > OUTPUT
echo "done"
echo " " >> validation.log
echo "2D demo linear_wave flux validation" >> validation.log
echo "----------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/soln0.dat RESLT/soln1.dat RESLT/soln2.dat > results_flux.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_flux.dat.gz   \
    results_flux.dat  >> validation.log
fi

mv RESLT RESLT_two_d_linear_wave_flux

# Append output to global validation log file
#--------------------------------------------
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




