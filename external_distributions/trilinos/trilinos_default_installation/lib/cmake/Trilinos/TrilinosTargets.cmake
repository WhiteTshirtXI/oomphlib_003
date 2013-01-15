# Generated by CMake 2.8.9

IF("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" LESS 2.5)
   MESSAGE(FATAL_ERROR "CMake >= 2.6.0 required")
ENDIF("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" LESS 2.5)
CMAKE_POLICY(PUSH)
CMAKE_POLICY(VERSION 2.6)
#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
SET(CMAKE_IMPORT_FILE_VERSION 1)

# Create imported target teuchos
ADD_LIBRARY(teuchos STATIC IMPORTED)

# Create imported target epetra
ADD_LIBRARY(epetra STATIC IMPORTED)

# Create imported target triutils
ADD_LIBRARY(triutils STATIC IMPORTED)

# Create imported target epetraext
ADD_LIBRARY(epetraext STATIC IMPORTED)

# Create imported target aztecoo
ADD_LIBRARY(aztecoo STATIC IMPORTED)

# Create imported target amesos
ADD_LIBRARY(amesos STATIC IMPORTED)

# Create imported target ifpack
ADD_LIBRARY(ifpack STATIC IMPORTED)

# Create imported target ml
ADD_LIBRARY(ml STATIC IMPORTED)

# Create imported target anasazi
ADD_LIBRARY(anasazi STATIC IMPORTED)

# Create imported target anasaziepetra
ADD_LIBRARY(anasaziepetra STATIC IMPORTED)

# Create imported target ModeLaplace
ADD_LIBRARY(ModeLaplace STATIC IMPORTED)

# Load information for each installed configuration.
GET_FILENAME_COMPONENT(_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
FILE(GLOB CONFIG_FILES "${_DIR}/TrilinosTargets-*.cmake")
FOREACH(f ${CONFIG_FILES})
  INCLUDE(${f})
ENDFOREACH(f)

# Commands beyond this point should not need to know the version.
SET(CMAKE_IMPORT_FILE_VERSION)
CMAKE_POLICY(POP)