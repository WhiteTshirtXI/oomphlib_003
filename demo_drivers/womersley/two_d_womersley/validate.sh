#! /bin/sh


#Set the number of tests to be checked
NUM_TESTS=4

# Setup validation directory
#---------------------------
touch Validation
rm -r -f Validation
mkdir Validation

# Validation for Womersley problems
#----------------------------------
cd Validation

echo "Running 2D Womersley validation "
mkdir RESLT_prescribed_pressure_gradient
mkdir RESLT_prescribed_volume_flux
mkdir RESLT_impedance_tube
mkdir RESLT_navier_stokes
../two_d_womersley > OUTPUT
echo "done"
echo " " >> validation.log
echo "2D Womersley validation" >> validation.log
echo "-----------------------" >> validation.log
echo " " >> validation.log
echo "Validation directory: " >> validation.log
echo " " >> validation.log
echo "  " `pwd` >> validation.log
echo " " >> validation.log



echo "Prescribed pressure gradient test: " >> validation.log
cat  RESLT_prescribed_pressure_gradient/womersley_soln0.dat RESLT_prescribed_pressure_gradient/womersley_soln1.dat RESLT_prescribed_pressure_gradient/womersley_soln2.dat RESLT_prescribed_pressure_gradient/womersley_soln10.dat RESLT_prescribed_pressure_gradient/trace.dat \
     > presc_pres_grad.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py \
../validata/presc_pres_grad.dat.gz  \
presc_pres_grad.dat >> validation.log
fi



echo "Prescribed volume flux test: " >> validation.log
cat  RESLT_prescribed_volume_flux/womersley_soln0.dat RESLT_prescribed_volume_flux/womersley_soln1.dat RESLT_prescribed_volume_flux/womersley_soln2.dat RESLT_prescribed_volume_flux/womersley_soln10.dat   RESLT_prescribed_volume_flux/trace.dat \
 > prescribed_volume_flux_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py \
../validata/prescribed_volume_flux_results.dat.gz  \
prescribed_volume_flux_results.dat 0.1 2.0e-13 >> validation.log
fi



echo "Impedance tube test: " >> validation.log
cat  RESLT_impedance_tube/womersley_soln0.dat RESLT_impedance_tube/womersley_soln1.dat RESLT_impedance_tube/womersley_soln2.dat  RESLT_impedance_tube/womersley_soln10.dat RESLT_impedance_tube/trace.dat \
 > impedance_tube_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py \
../validata/impedance_tube_results.dat.gz  \
impedance_tube_results.dat 0.1 2.0e-13 >> validation.log
fi


echo "Navier Stokes outflow test: " >> validation.log
cat  RESLT_navier_stokes/womersley_soln0.dat RESLT_navier_stokes/womersley_soln1.dat RESLT_navier_stokes/womersley_soln2.dat  RESLT_navier_stokes/womersley_soln10.dat RESLT_navier_stokes/trace.dat \
 > navier_stokes_results.dat

if test "$1" = "no_fpdiff"; then
  echo "dummy [OK] -- Can't run fpdiff.py because we don't have python or validata" >> validation.log
else
../../../../bin/fpdiff.py \
../validata/navier_stokes_results.dat.gz  \
navier_stokes_results.dat 0.1 1.0e-13 >> validation.log
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
