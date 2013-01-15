#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=4


# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for counter-rotating disks
#--------------------------------------
cd Validation

echo "Running non-refineable counter-rotating disks validation "
mkdir RESLT_TH
mkdir RESLT_CR

../counter_rotating_disks lala > OUTPUT
echo "done"
echo " " >> validation.log
echo "Counter-rotating disks validation (non-refineable)" >> validation.log
echo "--------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT_TH/base_soln0.dat RESLT_TH/perturbed_soln0.dat \
     RESLT_TH/trace.dat \
 > results_TH.dat
cat  RESLT_CR/base_soln0.dat RESLT_CR/perturbed_soln0.dat \
     RESLT_CR/trace.dat \
 > results_CR.dat

mv RESLT_TH RESLT_TH_nonref
mv RESLT_CR RESLT_CR_nonref

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_TH_nonref.dat.gz  \
         results_TH.dat 0.1 1.0e-8 >> validation.log
../../../../bin/fpdiff.py ../validata/results_CR_nonref.dat.gz  \
         results_CR.dat 0.1 1.0e-8 >> validation.log
fi

rm results_TH.dat
rm results_CR.dat

echo "Running refineable counter-rotating disks validation "
mkdir RESLT_TH
mkdir RESLT_CR

../counter_rotating_disks_ref lala > OUTPUT_ref
echo "done"
echo " " >> validation.log
echo "Counter-rotating disks validation (refineable)" >> validation.log
echo "----------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT_TH/base_soln0.dat RESLT_TH/perturbed_soln0.dat \
     RESLT_TH/trace.dat \
 > results_TH.dat
cat  RESLT_CR/base_soln0.dat RESLT_CR/perturbed_soln0.dat \
     RESLT_CR/trace.dat \
 > results_CR.dat

mv RESLT_TH RESLT_TH_ref
mv RESLT_CR RESLT_CR_ref

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_TH_ref.dat.gz  \
         results_TH.dat >> validation.log
../../../../bin/fpdiff.py ../validata/results_CR_ref.dat.gz  \
         results_CR.dat >> validation.log
fi

rm results_TH.dat
rm results_CR.dat



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

