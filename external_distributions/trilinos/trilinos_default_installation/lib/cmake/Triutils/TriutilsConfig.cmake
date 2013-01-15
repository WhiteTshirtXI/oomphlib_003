##############################################################################
#
# CMake variable for use by Trilinos/Triutils clients. 
#
# Do not edit: This file was generated automatically by CMake.
#
##############################################################################

#
# Make sure CMAKE_CURRENT_LIST_DIR is usable
#

IF (NOT DEFINED CMAKE_CURRENT_LIST_DIR)
  GET_FILENAME_COMPONENT(_THIS_SCRIPT_PATH ${CMAKE_CURRENT_LIST_FILE} PATH)
  SET(CMAKE_CURRENT_LIST_DIR ${_THIS_SCRIPT_PATH})
ENDIF()


## ---------------------------------------------------------------------------
## Compilers used by Trilinos/Triutils build
## ---------------------------------------------------------------------------

SET(Triutils_CXX_COMPILER "/usr/bin/g++")

SET(Triutils_C_COMPILER "/usr/bin/gcc")

SET(Triutils_FORTRAN_COMPILER "/usr/bin/gfortran")


## ---------------------------------------------------------------------------
## Compiler flags used by Trilinos/Triutils build
## ---------------------------------------------------------------------------

## Set compiler flags, including those determined by build type
SET(Triutils_CXX_FLAGS "  -O6 -Wall ")

SET(Triutils_C_FLAGS " ")

SET(Triutils_FORTRAN_FLAGS " ")

## Extra link flags (e.g., specification of fortran libraries)
SET(Triutils_EXTRA_LD_FLAGS "")

## This is the command-line entry used for setting rpaths. In a build
## with static libraries it will be empty. 
SET(Triutils_SHARED_LIB_RPATH_COMMAND "")
SET(Triutils_BUILD_SHARED_LIBS "OFF")

SET(Triutils_LINKER /usr/bin/ld)
SET(Triutils_AR /usr/bin/ar)

## ---------------------------------------------------------------------------
## Set library specifications and paths 
## ---------------------------------------------------------------------------

## List of package include dirs
SET(Triutils_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../../include")

## List of package library paths
SET(Triutils_LIBRARY_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../../lib")

## List of package libraries
SET(Triutils_LIBRARIES "triutils;epetra")

## Specification of directories for TPL headers
SET(Triutils_TPL_INCLUDE_DIRS "")

## Specification of directories for TPL libraries
SET(Triutils_TPL_LIBRARY_DIRS "")

## List of required TPLs
SET(Triutils_TPL_LIBRARIES "/home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_flapack/.libs/liboomph_flapack.a;/home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_blas/.libs/liboomph_blas.a")

## ---------------------------------------------------------------------------
## MPI specific variables
##   These variables are provided to make it easier to get the mpi libraries
##   and includes on systems that do not use the mpi wrappers for compiling
## ---------------------------------------------------------------------------

SET(Triutils_MPI_LIBRARIES "")
SET(Triutils_MPI_LIBRARY_DIRS "")
SET(Triutils_MPI_INCLUDE_DIRS "")
SET(Triutils_MPI_EXEC "")
SET(Triutils_MPI_EXEC_MAX_NUMPROCS "")
SET(Triutils_MPI_EXEC_NUMPROCS_FLAG "")

## ---------------------------------------------------------------------------
## Set useful general variables 
## ---------------------------------------------------------------------------

## The packages enabled for this project
SET(Triutils_PACKAGE_LIST "Triutils;Epetra")

## The TPLs enabled for this project
SET(Triutils_TPL_LIST "LAPACK;BLAS")


# Import Trilinos targets
IF(NOT Trilinos_TARGETS_IMPORTED)
  SET(Trilinos_TARGETS_IMPORTED 1)
  INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../Trilinos/TrilinosTargets.cmake")
ENDIF()
