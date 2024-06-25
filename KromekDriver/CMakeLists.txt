cmake_minimum_required (VERSION 3.5)


#########################################################################################
# Define the TargetName which will be the name of the lib/exe that is created by this file.
# This is also the name of the cmake 'Target'
#########################################################################################
SET (TargetName KromekDriver)

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
set (SOURCE_FILES src/CriticalSection.cpp 
					src/D3DataProcessor.cpp 
					src/DeviceBase.cpp 
					src/DeviceMgr.cpp 
					src/Event.cpp 
					src/GR1.cpp 
					src/IntervalCountProcessor.cpp 
					src/K102.cpp 
					src/Lock.cpp 
					src/RadAngel.cpp 
					src/RollingQueue.cpp 
					src/SIGMA_25.cpp 
					src/SIGMA_50.cpp 
					src/stdafx.cpp 
					src/Thread.cpp 
					src/TN15.cpp 
					src/GR05.cpp 
					src/UNIBASE.cpp 
					src/DoseDevice.cpp
					src/PacketStreamers.cpp)
					
set (HEATSHRINK_SRC heatshrink/Heatshrink.cpp
					heatshrink/Heatshrink.hpp
					heatshrink/heatshrink_decoder.c)

if (UNIX)
	set (SOURCE_FILES ${SOURCE_FILES} 
					src/DeviceEnumeratorLinux.cpp 
					src/USBKromekDataInterfaceLinux.cpp)
else()
	set (SOURCE_FILES ${SOURCE_FILES} 
					src/DeviceEnumeratorWindows.cpp 
					src/HIDDataInterfaceWindows.cpp 
					src/USBSerialDataInterfaceWindows.cpp)
endif()

set (HEADER_FILES 
					include/CriticalSection.h 
					include/D3DataProcessor.h 
					include/D3Structs.h 
					include/DeviceBase.h 
					include/DeviceMgr.h 
					include/Event.h 
					include/GR1.h 
					include/IDataInterface.h 
					include/IDataProcessor.h 
					include/IDevice.h 
					include/IntervalCountProcessor.h 
					include/K102.h 
					include/kromek.h 
					include/Lock.h 
					include/RadAngel.h  
					include/RollingQueue.h 
					include/SIGMA_25.h 
					include/SIGMA_50.h 
					include/stdafx.h 
					include/targetver.h 
					include/Thread.h 
					include/TN15.h 
					include/GR05.h 
					include/types.h 
					include/kromek_endian.h 
					include/UNIBASE.h
					include/DoseDevice.h
					include/PacketStreamers.h
					include/crc.h
					)
					
set (HEATSHRINK_HED	heatshrink/includes/heatshrink_common.h
					heatshrink/includes/heatshrink_config.h
					heatshrink/includes/heatshrink_decoder.h)

if (WIN32)
# Include other dlls that need copying into the directory here
    #set (OTHER_RUNTIME_FILES <filePaths>)
else()
    #set (OTHER_RUNTIME_FILES <filePaths>)
endif()

#######################################################################################
# Includes and libs
#######################################################################################
					
include_directories(include heatshrink/includes)

if (UNIX)
	find_path (LIBUDEV_H_PATH "libudev.h")
	find_library (UDEV_LIB_PATH udev)
	find_library (RT_LIB_PATH rt)
	include_directories(${LIBUDEV_H_PATH})
	# Required for use in shared lib
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pthread")
endif()

add_definitions (-DKROMEKDRIVER_EXPORTS -D_UNICODE -DUNICODE)

# Define the output here
add_library (${TargetName} STATIC ${SOURCE_FILES} ${HEADER_FILES} ${HEATSHRINK_SRC} ${HEATSHRINK_HED})

# Add any additional libraries for the linker here
if (UNIX)
        target_link_libraries(${TargetName} ${UDEV_LIB_PATH} ${RT_LIB_PATH} pthread)
elseif(WIN32)
	target_link_libraries(${TargetName} SetupApi.lib hid.lib Advapi32.lib)
endif()

# -fPIC
set_property(TARGET ${TargetName} PROPERTY POSITION_INDEPENDENT_CODE ON)

# Structure the vs output folders. You can omit the <subdirectory> to have the project appear at the root level
set_target_folder(${TargetName})


#########################################################################################
# Install location
# If you are going to use CPack then create an install Target and define where the files 
# will be installed relative to the location the user selects
# Make sure you also include any additional dll and runtime files
#########################################################################################

STRING (TOUPPER ${TargetName} TargetNameUpper)
SET (InstallTargetComponentName ${TargetNameUpper}_COMPONENT)
		
if (WIN32)
        # Include additional files
        INSTALL (FILES ${OTHER_RUNTIME_FILES} DESTINATION . COMPONENT ${InstallTargetComponentName} )
else()
		
        # Additional files to copy as is into the app directory
        INSTALL (FILES ${OTHER_RUNTIME_FILES} DESTINATION lib COMPONENT ${InstallTargetComponentName} )
endif()
