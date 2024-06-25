cmake_minimum_required(VERSION 3.5)

if (WIN32)
	add_definitions(-DWIN32)
endif()

# Enable C++11 on linux
set (CMAKE_CXX_STANDARD 11)

# Automatically include current directory for headers
set (CMAKE_INCLUDE_CURRENT_DIR ON)

# Default to release build type
if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE RELEASE)
endif()

###############################################################
# Set output directories
###############################################################
if (WIN32)
	set (PLATFORMFOLDER "win")

else()
	set (PLATFORMFOLDER "linux")
        if (NOT CMAKE_BUILD_TYPE)
            SET(CMAKE_BUILD_TYPE "release")
        endif()
endif()

if (CMAKE_SIZEOF_VOID_P EQUAL 4)
	message("A 32-bit BUILD detected")
	set (PLATFORMFOLDER ${PLATFORMFOLDER}32)
	set (64_BIT_OS FALSE)
else()
	message("A 64-bit BUILD detected")
	set (PLATFORMFOLDER ${PLATFORMFOLDER}64)	
	set (64_BIT_OS TRUE)
endif()

set (LIB_SUBPATH "libs/${PLATFORMFOLDER}")
set (APP_SUBPATH "output/${PLATFORMFOLDER}")

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}")
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}/release")
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}/debug")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}/release")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/${APP_SUBPATH}/debug")
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/${LIB_SUBPATH}")
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/${LIB_SUBPATH}/release")
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/${LIB_SUBPATH}/debug")

################################################################
# Apply settings to fix warnings
################################################################

# Link paths relative to source dir
cmake_policy(SET CMP0015 NEW)

# Something about COMPILE_DEFINITIONS - ignore them
cmake_policy(SET CMP0043 NEW)

####################################################################################
# QT
####################################################################################

# Search path for qt 5
if (NOT CMAKE_PREFIX_PATH)
       if (WIN32)
             if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                    set (CMAKE_PREFIX_PATH "C:/Qt/5.5/msvc2013")
             else()
                    if (MSVC_TOOLSET_VERSION GREATER_EQUAL 141)
                          set (CMAKE_PREFIX_PATH "C:/Qt/5.9.8/msvc2017_64")
                    else()
                          set (CMAKE_PREFIX_PATH "C:/Qt/5.9.2/msvc2013_64")
                    endif()
             endif()
       else()
             set (CMAKE_PREFIX_PATH "/usr/lib/x86_64-linux-gnu")
       endif()

endif()

FUNCTION (enable_qt)

# Link qtmain as standard
	cmake_policy(SET CMP0020 NEW)

	if(POLICY CMP0071)
		cmake_policy(SET CMP0071 NEW)
	endif()
	
	set(CMAKE_AUTOMOC ON PARENT_SCOPE)
	set(CMAKE_AUTORCC ON PARENT_SCOPE)
	set(CMAKE_AUTOUIC ON PARENT_SCOPE)
ENDFUNCTION(enable_qt)

set_property(GLOBAL PROPERTY AUTOGEN_TARGETS_FOLDER "moc")
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

######################################################################################
# Project file structure (Visual Studio)
######################################################################################

# Enable folders. 
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# To place a vs project in a sub folder of the solution: set_target_folder(targetName folder1/folder2)
# folder1/folder is optional
FUNCTION (set_target_folder target)
	set (project_folder_name .${PROJECT_NAME})

	# Cannot use ARGN directly with list() command,
    # so copy it to a variable first.
    set (extra_macro_args ${ARGN})

    # Did we get any optional args?
    list(LENGTH extra_macro_args num_extra_args)
    if (${num_extra_args} GREATER 0)
		list(GET extra_macro_args 0 optional_arg)
		set_target_properties (${target} PROPERTIES FOLDER ${project_folder_name}/${optional_arg} )
	else()
		set_target_properties (${target} PROPERTIES FOLDER ${project_folder_name} )
	endif()
ENDFUNCTION(set_target_folder target folders)