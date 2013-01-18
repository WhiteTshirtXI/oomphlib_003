#!/bin/bash
run_tests()
{


#PRECLIST="0 1 2" # Doing either full exact or Exact Navier Stokes
# 0 - W SuperLU, NS SuperLU
# 1 - W SuperLU, NS LSC: P SuperLU, F SuperLU
# 2 - W SuperLU, NS LSC: P AMG, F AMG

PRECLIST="0 1 4"
# The precs are set according to the PRECLIST above.
WPRECLIST="0" # 0 - Exact
NSPRECLIST="0" # 0 - Exact, 1 - LSC
PPRECLIST="0" # Only for LSC, 0 - Exact, 1 - AMG
FPRECLIST="0" # Only for LSC, 0 - Exact, 1 - AMG

VISLIST="0 1"
ANGLIST="30"
RELIST="100"
NOELLIST="4 8 16 32 64 128"
#NOELLIST="4"
  

for PREC  in $PRECLIST
do
  case "$PREC" in
    0)
    WPRECLIST="0"
    NSPRECLIST="0"
    ;;
    1)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="0"
    FPRECLIST="0"
    ;;
    2)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="1"
    FPRECLIST="0"
    ;;
    3)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="0"
    FPRECLIST="1"
    ;;
    4)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="1"
    FPRECLIST="1"
    ;;
    esac
for WPREC in $WPRECLIST 
do
  for NSPREC in $NSPRECLIST
  do
    if [ $NSPREC == 1 ]; then
      for PPREC in $PPRECLIST 
      do
        for FPREC in $FPRECLIST 
        do
          for VIS in $VISLIST
          do
            for ANG in $ANGLIST
            do
              for RE in $RELIST
              do
                for NOEL in $NOELLIST
                do
./square0 --w_solver $WPREC --ns_solver $NSPREC --p_solver $PPREC --f_solver $FPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL --diagw
                done
              done
            done
          done
        done
      done
    else
      for VIS in $VISLIST 
      do
        for ANG in $ANGLIST
        do
          for RE in $RELIST
          do
            for NOEL in $NOELLIST
            do
./square0 --w_solver $WPREC --ns_solver $NSPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL --diagw
            done
          done
        done
      done
    fi
  done
done
done

} # run_tests function




OUTFILE="squ0_nofsubblock.dat"

OOMPHPATH="/home/mly/oomphlib_current"
cd $OOMPHPATH/src/ && make && make install && \
cd $OOMPHPATH/user_drivers/lagrange_square/ && \
make square0 && run_tests



