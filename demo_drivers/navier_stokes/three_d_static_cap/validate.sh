#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=8

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for 2D two layer static cap
#---------------------------------------
cd Validation

echo "Running 3D static cap validation "
mkdir RESLT_TH_internal RESLT_TH_external RESLT_CR_internal RESLT_CR_external
mkdir RESLT_TH_internal_elastic RESLT_TH_external_elastic RESLT_CR_internal_elastic RESLT_CR_external_elastic
../3d_static_cap > OUTPUT_3d_static_cap
../3d_static_cap_elastic > OUTPUT_3d_static_cap_elastic
echo "done"
echo " " >> validation.log
echo "3D static cap validation" >> validation.log
echo "-------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat  RESLT_TH_internal/soln0.dat RESLT_TH_internal/soln1.dat > TH_int.dat 
cat  RESLT_TH_external/soln0.dat RESLT_TH_external/soln1.dat > TH_ext.dat 
cat  RESLT_CR_internal/soln0.dat RESLT_CR_internal/soln1.dat > CR_int.dat 
cat  RESLT_CR_external/soln0.dat RESLT_CR_external/soln1.dat > CR_ext.dat 
cat  RESLT_TH_internal_elastic/soln0.dat RESLT_TH_internal_elastic/soln1.dat \
    > TH_int_elastic.dat 
cat  RESLT_TH_external_elastic/soln0.dat RESLT_TH_external_elastic/soln1.dat \
    > TH_ext_elastic.dat 
cat  RESLT_CR_internal_elastic/soln0.dat RESLT_CR_internal_elastic/soln1.dat \
    > CR_int_elastic.dat 
cat  RESLT_CR_external_elastic/soln0.dat RESLT_CR_external_elastic/soln1.dat \
    > CR_ext_elastic.dat 


if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
echo "Spine Tests" >> validation.log
echo >> validation.log
echo "Taylor Hood (hijacked internal pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/TH_int.dat.gz  \
   TH_int.dat 0.1 1.0e-5 >> validation.log
echo "Taylor Hood (hijacked external pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/TH_ext.dat.gz  \
   TH_ext.dat 0.1 1.1e-5 >> validation.log
echo "Crouzeix Raviart (hijacked internal pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/CR_int.dat.gz  \
   CR_int.dat 0.1 1.0e-5 >> validation.log
echo "Crouzeix Raviart (hijacked external pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/CR_ext.dat.gz  \
   CR_ext.dat 0.1 1.0e-5 >> validation.log

echo >> validation.log
echo "PseudoSolidMeshUpdate Tests" >> validation.log
echo >> validation.log
echo "Taylor Hood (hijacked internal pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/TH_int_elastic.dat.gz  \
   TH_int_elastic.dat 0.1 5.0e-7 >> validation.log
echo "Taylor Hood (hijacked external pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/TH_ext_elastic.dat.gz  \
   TH_ext_elastic.dat 0.1 5.0e-7 >> validation.log
echo "Crouzeix Raviart (hijacked internal pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/CR_int_elastic.dat.gz  \
   CR_int_elastic.dat 0.1 5.0e-7 >> validation.log
echo "Crouzeix Raviart (hijacked external pressure)">> validation.log
../../../../bin/fpdiff.py  ../validata/CR_ext_elastic.dat.gz  \
   CR_ext_elastic.dat 0.1 5.0e-7 >> validation.log

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
