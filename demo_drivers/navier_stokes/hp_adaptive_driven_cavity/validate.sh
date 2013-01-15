#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=3


# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

cd Validation

# Validation for hp-adaptive rectangular driven cavity
#-----------------------------------------------------

echo "Running hp-adaptive rectangular driven cavity validation "
mkdir RESLT
../hp_adaptive_driven_cavity validate > OUTPUT
echo "done"
echo " " >> validation.log
echo "hp-adaptive rectangular driven cavity validation" >> validation.log
echo "---------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT/soln0.dat > results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results.dat.gz  \
         results.dat >> validation.log
fi

# Validation for hp-adaptive circular driven cavity
#--------------------------------------------------

echo "Running hp-adaptive circular driven cavity validation "
mkdir RESLT_circ_bdry0 RESLT_circ_bdry1
../circular_driven_cavity_hp_adapt > OUTPUT_circ
echo "done"
echo " " >> validation.log
echo "hp-adaptive circular driven cavity validation" >> validation.log
echo "---------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log

cat  RESLT_circ_bdry0/soln0.dat RESLT_circ_bdry0/soln1.dat > results_circ_bdry0.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_circ_bdry0.dat.gz  \
         results_circ_bdry0.dat >> validation.log
fi

cat  RESLT_circ_bdry1/soln0.dat RESLT_circ_bdry1/soln1.dat > results_circ_bdry1.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/results_circ_bdry1.dat.gz  \
         results_circ_bdry1.dat >> validation.log
fi

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

