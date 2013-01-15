#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=10


# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for non-adaptive meniscus
#-------------------------------------
cd Validation

# Number of steps
nsteps=2

echo "Running nonadaptive meniscus validation "

mkdir RESLT_all_pinned
mkdir RESLT_barrel_shape
mkdir RESLT_T_junction

../young_laplace 0 $nsteps > OUTPUT_0
../young_laplace 1 $nsteps > OUTPUT_1
../young_laplace 2 $nsteps > OUTPUT_2

echo "done"

echo " " >> validation.log
echo "Non-adaptive meniscus validation" >> validation.log
echo "--------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT_all_pinned/soln2.dat RESLT_all_pinned/trace.dat > result1.dat
cat RESLT_barrel_shape/soln2.dat RESLT_barrel_shape/trace.dat > result2.dat
cat RESLT_T_junction/soln2.dat RESLT_T_junction/trace.dat > result3.dat


if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../bin/fpdiff.py ../validata/result1.dat.gz  \
         result1.dat >> validation.log
../../../bin/fpdiff.py ../validata/result2.dat.gz  \
         result2.dat >> validation.log
../../../bin/fpdiff.py ../validata/result3.dat.gz  \
         result3.dat >> validation.log
fi


# Validation for adaptive meniscus
#---------------------------------
echo "Running adaptive meniscus validation "

mkdir RESLT_adapt_all_pinned
mkdir RESLT_adapt_barrel_shape
mkdir RESLT_adapt_barrel_shape_without_spines
mkdir RESLT_adapt_T_junction

../refineable_young_laplace 0 $nsteps > OUTPUT_adapt_0
../refineable_young_laplace 1 $nsteps > OUTPUT_adapt_1
../refineable_young_laplace 2 $nsteps > OUTPUT_adapt_2
../refineable_young_laplace 3 $nsteps > OUTPUT_adapt_3

echo "done"
echo " " >> validation.log
echo "Adaptive meniscus validation" >> validation.log
echo "----------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT_adapt_all_pinned/soln2.dat RESLT_adapt_all_pinned/trace.dat > adapt_result1.dat
cat RESLT_adapt_barrel_shape/soln2.dat RESLT_adapt_barrel_shape/trace.dat > adapt_result2.dat
cat RESLT_adapt_barrel_shape_without_spines/soln2.dat RESLT_adapt_barrel_shape_without_spines/trace.dat > adapt_result3.dat
cat RESLT_adapt_T_junction/soln2.dat RESLT_adapt_T_junction/trace.dat > adapt_result4.dat



if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../bin/fpdiff.py ../validata/adapt_result1.dat.gz  \
         adapt_result1.dat >> validation.log
../../../bin/fpdiff.py ../validata/adapt_result2.dat.gz  \
         adapt_result2.dat >> validation.log
../../../bin/fpdiff.py ../validata/adapt_result3.dat.gz  \
         adapt_result3.dat >> validation.log
../../../bin/fpdiff.py ../validata/adapt_result4.dat.gz  \
         adapt_result4.dat >> validation.log
fi




# Validation for spherical cap in cylinder
#-----------------------------------------
echo "Running spherical cap in cylinder validation "
mkdir RESLT_adapt_pinned_spherical_cap_in_cylinder

../spherical_cap_in_cylinder > OUTPUT_cyl
echo "done"
echo " " >> validation.log
echo "Spherical cap in cylinder validation" >> validation.log
echo "------------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT_adapt_pinned_spherical_cap_in_cylinder/soln2.dat RESLT_adapt_pinned_spherical_cap_in_cylinder/trace.dat > cyl_result.dat


if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../bin/fpdiff.py ../validata/cyl_result.dat.gz  \
         cyl_result.dat >> validation.log
fi



# Validation for barrel-shaped menisus
#-----------------------------------------
echo "Running barrel-shaped meniscus validation "
mkdir RESLT

../barrel > OUTPUT_barrel
echo "done"
echo " " >> validation.log
echo "Barrel-shaped meniscusvalidation" >> validation.log
echo "--------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/soln2.dat RESLT/trace.dat > barrel_result.dat


if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../bin/fpdiff.py ../validata/barrel_result.dat.gz  \
         barrel_result.dat >> validation.log
fi

mv RESLT RESLT_barrel




# Validation for adaptive T-junction menisus
#-------------------------------------------
echo "Running adaptive T-junction meniscus validation "
mkdir RESLT

../refineable_t_junction > OUTPUT_t_junction
echo "done"
echo " " >> validation.log
echo "Meniscus in T-junction validation" >> validation.log
echo "---------------------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log
cat RESLT/soln2.dat RESLT/trace.dat > t_junction_result.dat


if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../bin/fpdiff.py ../validata/t_junction_result.dat.gz  \
        t_junction_result.dat >> validation.log
fi

mv RESLT RESLT_t_junction



# Append log to main validation log
cat validation.log >> ../../../validation.log

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

