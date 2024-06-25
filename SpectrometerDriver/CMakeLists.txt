cmake_minimum_required(VERSION 3.5)

SET(VERSION_PRODUCT 16)
SET(VERSION_MAJOR 3)
SET(VERSION_MINOR 8)
SET(VERSION_BUILD 23)

#########################################################################################
# Define the TargetName which will be the name of the lib/exe that is created by this file.
# This is also the name of the cmake 'Target'
#########################################################################################
SET (TargetName SpectrometerDriver)

#########################################################################################
# Define a project name if none is given so a generated solution has an appropriate name
# A project name may have already been defined at a higher level in the build hierarchy
# A project name not necessarily need to be given for every library thats built
#########################################################################################
if (NOT PROJECT_NAME)
	project(${TargetName})
endif()

#########################################################################################
# Files
#########################################################################################

set (HEADER_FILES 	Detector.h
					devices.h
					DriverMgr.h
					SpectrometerData.h
					SpectrometerDriver.h
					stdafx.h
					targetver.h)

set (SOURCE_FILES 	Detector.cpp 
					DriverMgr.cpp 
					SpectrometerDriver.cpp
					stdafx.cpp)
if(WIN32)
	set (WIN_SOURCE_FILES		dllmain.cpp)
endif()

if (WIN32)
# Include other dlls that need copying into the directory here
    set (OTHER_RUNTIME_FILES )
else()
    set (OTHER_RUNTIME_FILES )
endif()
					
#######################################################################################
# Includes and libs
#######################################################################################

include_directories(. ../KromekDriver/include)

if (UNIX)
	find_path (LIBUDEV_H_PATH "libudev.h")
	find_library (LIBUDEV_LIB_PATH udev)
	include_directories(${LIBUDEV_H_PATH})
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-enum-compare")
endif()

add_definitions (-DUSBSPECTROMETERDLL_EXPORTS -D_UNICODE)

# Create both a static and shared lib
add_library (${TargetName}Static STATIC ${SOURCE_FILES} ${WIN_SOURCE_FILES})
add_library (${TargetName} SHARED ${SOURCE_FILES} ${WIN_SOURCE_FILES})

if (UNIX)
	target_link_libraries(${TargetName}Static KromekDriver ${LIBUDEV_LIB_PATH})
	target_link_libraries(${TargetName} KromekDriver ${LIBUDEV_LIB_PATH})
elseif(WIN32)
	target_link_libraries(${TargetName} KromekDriver Hid.lib setupapi.lib )
	target_link_libraries(${TargetName}Static KromekDriver Hid.lib setupapi.lib )
endif()

# Add version as definitions to the compiler
target_compile_definitions(${TargetName}    PRIVATE VERSION_PRODUCT=${VERSION_PRODUCT}
                                            VERSION_MAJOR=${VERSION_MAJOR}
                                            VERSION_MINOR=${VERSION_MINOR}
                                            VERSION_BUILD=${VERSION_BUILD})

target_compile_definitions(${TargetName}Static    PRIVATE VERSION_PRODUCT=${VERSION_PRODUCT}
                                            VERSION_MAJOR=${VERSION_MAJOR}
                                            VERSION_MINOR=${VERSION_MINOR}
                                            VERSION_BUILD=${VERSION_BUILD})

											# -fPIC
set_property(TARGET ${TargetName} PROPERTY POSITION_INDEPENDENT_CODE ON)
set_property(TARGET ${TargetName}Static PROPERTY POSITION_INDEPENDENT_CODE ON)

# Structure the vs output folders. You can omit the <subdirectory> to have the project appear at the root level
set_target_folder(${TargetName})
set_target_folder(${TargetName}Static)
set_target_properties(${TargetName} PROPERTIES SOVERSION ${VERSION_MAJOR}.${VERSION_MINOR})

#########################################################################################
# Install location
# If you are going to use CPack then create an install Target and define where the files 
# will be installed relative to the location the user selects
# Make sure you also include any additional dll and runtime files
#########################################################################################

STRING (TOUPPER ${TargetName} TargetNameUpper)
SET (InstallTargetComponentName ${TargetNameUpper}_COMPONENT)
		
if (WIN32)
		# Install dll next to exe
		INSTALL (TARGETS ${TargetName} RUNTIME DESTINATION .
			COMPONENT ${InstallTargetComponentName})

        # Include additional files
        INSTALL (FILES ${OTHER_RUNTIME_FILES} DESTINATION . COMPONENT ${InstallTargetComponentName} )
else()
      
	  # Install .so in a sub lib folder
		INSTALL (TARGETS ${TargetName} LIBRARY DESTINATION lib
			COMPONENT ${InstallTargetComponentName})
	  
        # Additional files to copy as is into the app directory
        INSTALL (FILES ${OTHER_RUNTIME_FILES} DESTINATION lib COMPONENT ${InstallTargetComponentName} )
endif()