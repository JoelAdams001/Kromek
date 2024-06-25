cmake_minimum_required(VERSION 3.5)

PROJECT(SpectrometerDriver)

include ("StandardSetup.cmake" NO_POLICY_SCOPE)

####################################################################################
# Build each of the projects in the sub folders
####################################################################################

add_subdirectory (KromekDriver)
add_subdirectory (SpectrometerDriver)
add_subdirectory (ConsoleExample)

# QT is required for the example. Add an option to disable it
option (BUILD_EXAMPLE "Build example app - requires QT" ON)

if (BUILD_EXAMPLE)
	add_subdirectory (SpectrometerExample)
endif (BUILD_EXAMPLE)
