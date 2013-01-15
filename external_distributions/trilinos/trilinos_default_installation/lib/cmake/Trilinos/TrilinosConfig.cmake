##############################################################################
#
# CMake variable for use by Trilinos clients. 
#
# Do not edit: This file was generated automatically by CMake.
#
##############################################################################

#
# Ensure CMAKE_CURRENT_LIST_DIR is usable.
#

IF (NOT DEFINED CMAKE_CURRENT_LIST_DIR)
  GET_FILENAME_COMPONENT(_THIS_SCRIPT_PATH ${CMAKE_CURRENT_LIST_FILE} PATH)
  SET(CMAKE_CURRENT_LIST_DIR ${_THIS_SCRIPT_PATH})
ENDIF()


## ---------------------------------------------------------------------------
## Compilers used by Trilinos build
## ---------------------------------------------------------------------------

SET(Trilinos_CXX_COMPILER "/usr/bin/g++")

SET(Trilinos_C_COMPILER "/usr/bin/gcc")

SET(Trilinos_Fortran_COMPILER "/usr/bin/gfortran")

## ---------------------------------------------------------------------------
## Compiler flags used by Trilinos build
## ---------------------------------------------------------------------------

SET(Trilinos_CXX_COMPILER_FLAGS "  -O6 -Wall ")

SET(Trilinos_C_COMPILER_FLAGS " ")

SET(Trilinos_Fortran_COMPILER_FLAGS " -O6 -Wall ")

## Extra link flags (e.g., specification of fortran libraries)
SET(Trilinos_EXTRA_LD_FLAGS "")

## This is the command-line entry used for setting rpaths. In a build
## with static libraries it will be empty. 
SET(Trilinos_SHARED_LIB_RPATH_COMMAND "")
SET(Trilinos_BUILD_SHARED_LIBS "OFF")

SET(Trilinos_LINKER /usr/bin/ld)
SET(Trilinos_AR /usr/bin/ar)


## ---------------------------------------------------------------------------
## Set library specifications and paths 
## ---------------------------------------------------------------------------

## The project version number
SET(Trilinos_VERSION "11.0.3")

## The project include file directories.
SET(Trilinos_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../../include")

## The project library directories.
SET(Trilinos_LIBRARY_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../../lib")

## The project libraries.
SET(Trilinos_LIBRARIES "ModeLaplace;anasaziepetra;anasazi;ml;ifpack;amesos;aztecoo;epetraext;triutils;epetra;teuchos")

## The project tpl include paths
SET(Trilinos_TPL_INCLUDE_DIRS "/usr/include")

## The project tpl library paths
SET(Trilinos_TPL_LIBRARY_DIRS "")

## The project tpl libraries
SET(Trilinos_TPL_LIBRARIES "/home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_flapack/.libs/liboomph_flapack.a;/home/ray/learning/phd/wulfling/oomph2_hut11/external_src/oomph_blas/.libs/liboomph_blas.a;/usr/lib/i386-linux-gnu/libpthread.so")

## ---------------------------------------------------------------------------
## MPI specific variables
##   These variables are provided to make it easier to get the mpi libraries
##   and includes on systems that do not use the mpi wrappers for compiling
## ---------------------------------------------------------------------------

SET(Trilinos_MPI_LIBRARIES "")
SET(Trilinos_MPI_LIBRARY_DIRS "")
SET(Trilinos_MPI_INCLUDE_DIRS "")
SET(Trilinos_MPI_EXEC "")
SET(Trilinos_MPI_EXEC_MAX_NUMPROCS "")
SET(Trilinos_MPI_EXEC_NUMPROCS_FLAG "")

## ---------------------------------------------------------------------------
## Set useful general variables 
## ---------------------------------------------------------------------------

## The packages enabled for this project
SET(Trilinos_PACKAGE_LIST "Anasazi;ML;Ifpack;Amesos;AztecOO;EpetraExt;Triutils;Epetra;Teuchos")

## The TPLs enabled for this project
SET(Trilinos_TPL_LIST "LAPACK;BLAS;Pthread")


# Import Trilinos targets
IF(NOT Trilinos_TARGETS_IMPORTED)
  SET(Trilinos_TARGETS_IMPORTED 1)
  INCLUDE("${CMAKE_CURRENT_LIST_DIR}/TrilinosTargets.cmake")
ENDIF()

# Load configurations from enabled packages
include("${CMAKE_CURRENT_LIST_DIR}/../Anasazi/AnasaziConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../ML/MLConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../Ifpack/IfpackConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../Amesos/AmesosConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../AztecOO/AztecOOConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../EpetraExt/EpetraExtConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../Triutils/TriutilsConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../Epetra/EpetraConfig.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../Teuchos/TeuchosConfig.cmake")

