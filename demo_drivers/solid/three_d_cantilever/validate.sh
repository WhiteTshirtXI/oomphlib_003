#! /bin/sh

#Set the number of tests to be checked
NUM_TESTS=2

# Setup validation directory
#---------------------------
rm -rf Validation
mkdir Validation

cd Validation

# Validation for 3D cantilever with different constitutive equations 
#-------------------------------------------------------------------
# and analytical/FD Jacobian without adaptation
#----------------------------------------------

mkdir RESLT
mkdir RESLT_norefine0
mkdir RESLT_norefine1
mkdir RESLT_norefine2
mkdir RESLT_norefine3
mkdir RESLT_norefine4
mkdir RESLT_norefine5
mkdir RESLT_norefine6
mkdir RESLT_norefine7
mkdir RESLT_norefine8
mkdir RESLT_norefine9



echo "Running 3d cantilever validation (1): const. eqns & analyt/FD Jacobian & no adapt "
../three_d_cantilever la > OUTPUT_constitutive_eqns_norefine


echo "done"
echo " " >> validation.log
echo "3D cantilever validation (1): const. eqns & analyt/FD Jacobian & no adapt" >> validation.log
echo "-------------------------------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat \
RESLT_norefine0/soln1.dat \
RESLT_norefine1/soln1.dat \
RESLT_norefine2/soln1.dat \
RESLT_norefine3/soln1.dat \
RESLT_norefine4/soln1.dat \
RESLT_norefine5/soln1.dat \
RESLT_norefine6/soln1.dat \
RESLT_norefine7/soln1.dat \
RESLT_norefine8/soln1.dat \
RESLT_norefine9/soln1.dat \
    > result_norefine.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/result_norefine.dat.gz \
    result_norefine.dat  >> validation.log
fi



# Validation for 3d cantilever with different constitutive equations 
#-------------------------------------------------------------------
# and analytical/FD Jacobian with adaptation
#----------------------------------------------

mkdir RESLT_refine0
mkdir RESLT_refine1
mkdir RESLT_refine2
mkdir RESLT_refine3
mkdir RESLT_refine4
mkdir RESLT_refine5
mkdir RESLT_refine6
mkdir RESLT_refine7
mkdir RESLT_refine8
mkdir RESLT_refine9


echo "Running 3d cantilever validation (2): const. eqns & analyt/FD Jacobian & adapt "
../three_d_cantilever_adapt la > OUTPUT_constitutive_eqns_refine


echo "done"
echo " " >> validation.log
echo "3D cantilever validation (2): const. eqns & analyt/FD Jacobian & adapt" >> validation.log
echo "----------------------------------------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat \
RESLT_refine0/soln1.dat \
RESLT_refine1/soln1.dat \
RESLT_refine2/soln1.dat \
RESLT_refine3/soln1.dat \
RESLT_refine4/soln1.dat \
RESLT_refine5/soln1.dat \
RESLT_refine6/soln1.dat \
RESLT_refine7/soln1.dat \
RESLT_refine8/soln1.dat \
RESLT_refine9/soln1.dat \
    > result_refine.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py ../validata/result_refine.dat.gz \
    result_refine.dat  >> validation.log
fi




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

