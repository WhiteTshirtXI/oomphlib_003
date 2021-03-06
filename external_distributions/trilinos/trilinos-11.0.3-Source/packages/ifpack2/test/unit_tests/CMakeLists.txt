
INCLUDE(TribitsAddExecutableAndTest)

INCLUDE_DIRECTORIES(REQUIRED_DURING_INSTALLATION_TESTING ${CMAKE_CURRENT_SOURCE_DIR}/)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../../teuchos/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/../../../teuchos/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../../kokkos/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../../kokkos/NodeAPI)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../../kokkos/LinAlg)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/../../../kokkos/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/../../../tpetra/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/../../../tpetra/src)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/)

TRIBITS_CONFIGURE_FILE(${PACKAGE_NAME}_config.h)

SET(SOURCES "")

APPEND_SET(SOURCES
Ifpack2_UnitTestMain.cpp
Ifpack2_UnitTestTemplate.cpp
Ifpack2_UnitTestChebyshev.cpp
Ifpack2_UnitTestCreateOverlapGraph.cpp
Ifpack2_UnitTestDiagonal.cpp
Ifpack2_UnitTestRILUK.cpp
Ifpack2_UnitTestHeap.cpp
Ifpack2_UnitTestOverlapGraph.cpp
Ifpack2_UnitTestParameters.cpp
Ifpack2_UnitTestIlukGraph.cpp
Ifpack2_UnitTestILUT.cpp
Ifpack2_UnitTestFactory.cpp
Ifpack2_UnitTestRelaxation.cpp
Ifpack2_UnitTestFiltering.cpp
Ifpack2_UnitTestPartitioning.cpp
Ifpack2_UnitTestContainer.cpp
Ifpack2_UnitTestBlockRelaxation.cpp

  )

TRIBITS_ADD_EXECUTABLE_AND_TEST(
    unit_tests
    SOURCES ${SOURCES}
    ARGS ""
    COMM serial mpi
    NUM_MPI_PROCS 1
    DEPLIBS tpetra kokkos teuchos
  )

