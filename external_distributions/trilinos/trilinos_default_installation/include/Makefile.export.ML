##############################################################################
#
# Make variables for use by Trilinos/ML clients. 
#
# Do not edit: This file was generated automatically by CMake.
#
##############################################################################


## ---------------------------------------------------------------------------
## Compilers used by Trilinos/ML build
## ---------------------------------------------------------------------------

ML_CXX_COMPILER=/usr/bin/g++

ML_C_COMPILER=/usr/bin/gcc

ML_FORTRAN_COMPILER=/usr/bin/gfortran


## ---------------------------------------------------------------------------
## Compiler flags used by Trilinos/ML build
## ---------------------------------------------------------------------------

## Set compiler flags, including those determined by build type
ML_CXX_FLAGS=  -O6 -Wall 

ML_C_FLAGS= 

ML_FORTRAN_FLAGS= 

## Extra link flags (e.g., specification of fortran libraries)
ML_EXTRA_LD_FLAGS=

## This is the command-line entry used for setting rpaths. In a build
## with static libraries it will be empty. 
ML_SHARED_LIB_RPATH_COMMAND=
ML_BUILD_SHARED_LIBS=OFF

ML_LINKER=/usr/bin/ld
ML_AR=/usr/bin/ar

## ---------------------------------------------------------------------------
## Set library specifications and paths 
## ---------------------------------------------------------------------------

## List of package include dirs
ML_INCLUDE_DIRS= -I/home/ray/learning/phd/wulfling/oomph2_hut11/external_distributions/trilinos/trilinos_default_installation/include

## List of package library paths
ML_LIBRARY_DIRS= -L/home/ray/learning/phd/wulfling/oomph2_hut11/external_distributions/trilinos/trilinos_default_installation/lib

## List of package libraries
ML_LIBRARIES= -lml -lifpack -lamesos -laztecoo -lepetraext -ltriutils -lepetra -lteuchos

## Specification of directories for TPL headers
ML_TPL_INCLUDE_DIRS=

## Specification of directories for TPL libraries
ML_TPL_LIBRARY_DIRS=

## List of required TPLs
ML_TPL_LIBRARIES= /home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_flapack/.libs/liboomph_flapack.a /home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_blas/.libs/liboomph_blas.a

## ---------------------------------------------------------------------------
## MPI specific variables
##   These variables are provided to make it easier to get the mpi libraries
##   and includes on systems that do not use the mpi wrappers for compiling
## ---------------------------------------------------------------------------

ML_MPI_LIBRARIES=
ML_MPI_LIBRARY_DIRS=
ML_MPI_INCLUDE_DIRS=
ML_MPI_EXEC=
ML_MPI_EXEC_MAX_NUMPROCS=
ML_MPI_EXEC_NUMPROCS_FLAG=

## ---------------------------------------------------------------------------
## Set useful general variables 
## ---------------------------------------------------------------------------

## The packages enabled for this project
ML_PACKAGE_LIST= ML Ifpack Amesos Galeri AztecOO Isorropia Xpetra EpetraExt Tpetra Triutils Zoltan Epetra KokkosClassic ThreadPool Teuchos

## The TPLs enabled for this project
ML_TPL_LIST= LAPACK BLAS

## ---------------------------------------------------------------------------
## Deprecated variables
##   These variables from the autotools version of Makefile.export.<package>
##   have been deprecated. To help avoid confusion with projects that haven't
##   migrated to the new version of the variable names when the don't compile.
##   This will put an obvious statement in the link line that these Trilinos
##   Makefile variables are no longer used. Without this there would be a link
##   error with no obvious reason as to why other than the lack of Trilinos libs
##   which would be confusing since the link line in the Makefile would have 
##   stated to put them on the line.
## ---------------------------------------------------------------------------

ML_LIBS="The Trilinos variable ML_LIBS has been deprecated. Please see the documentation on the Makefile.export capability for instructions on how to transition to the new system."
ML_INCLUDES="The Trilinos variable ML_INCLUDES has been deprecated. Please see the documentation on the Makefile.export capability for instructions on how to transition to the new system."


