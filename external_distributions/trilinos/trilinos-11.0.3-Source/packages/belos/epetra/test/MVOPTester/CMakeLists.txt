
INCLUDE(TribitsAddExecutableAndTest)
INCLUDE(TribitsCopyFilesToBinaryDir)

TRIBITS_ADD_EXECUTABLE_AND_TEST(
  MVOPTester
  SOURCES cxx_main.cpp 
  ARGS "-v"
  COMM serial mpi
  STANDARD_PASS_OUTPUT
  )
