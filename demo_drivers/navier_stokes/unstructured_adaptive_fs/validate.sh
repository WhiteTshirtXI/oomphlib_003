#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=2

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for unstructured drop
#---------------------------------
cd Validation

echo "Running 2D unstructured adaptive drop in channel validation" 
mkdir RESLT

../adaptive_drop_in_channel --validation > OUTPUT_drop
echo "done"
echo " " >> validation.log
echo "2D unstructured adaptive drop in channel validation" >> validation.log
echo "---------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/norm.dat > results_int.dat

if test "$1" = "no_fpdiff"; then
    echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
    ../../../../bin/fpdiff.py ../validata/results_int.dat.gz  \
        results_int.dat 0.1 6.0e-8 >> validation.log
fi

mv RESLT RESLT_int


echo "Running 2D unstructured adaptive bubble in channel validation" 
mkdir RESLT
../adaptive_bubble_in_channel --validation > OUTPUT_bubble
echo "done"
echo " " >> validation.log
echo "2D unstructured adaptive bubble in channel validation" >> validation.log
echo "-----------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/norm.dat > results_fs.dat

if test "$1" = "no_fpdiff"; then
    echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
    ../../../../bin/fpdiff.py ../validata/results_fs.dat.gz  \
        results_fs.dat 0.2 5.0e-8 >> validation.log
fi

mv RESLT RESLT_fs



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
