cmake_minimum_required(VERSION 3.1)
project (SpectrometerExample)

# Link qtmain as standard
cmake_policy(SET CMP0020 NEW)

# Enable C++11 on linux
set (CMAKE_CXX_STANDARD 11)

# Something about COMPILE_DEFINITIONS - ignore them
if (CMAKE_VERSION VERSION_GREATER 2.8.12.2)
	cmake_policy(SET CMP0043 NEW)
endif()

# We need either Qt4 or Qt5
# Qt5 is prefered to build

find_package(Qt5Widgets QUIET)
if (Qt5Widgets_FOUND)
	MESSAGE("Using Qt5 for SpectrometerExample")
else()
	MESSAGE("Qt5 not found. Using Qt4 for SpectrometerExample")
	find_package(Qt4 REQUIRED)
endif(Qt5Widgets_FOUND)


# Files required to build
set (SOURCE_FILES main.cpp mainwindow.cpp qcustomgraph.cpp)
set (HEADER_FILES mainwindow.h QTableWidgetDeviceItem.h qcustomgraph.h)
set (UI_FILES mainwindow.ui)

# Generate files for GUI forms
if (Qt5Widgets_FOUND)
# Qt5
QT5_WRAP_UI (FORM_SRC ${UI_FILES})
QT5_WRAP_CPP(HEADER_FILES_MOC ${HEADER_FILES})
else()
# Qt4
QT4_WRAP_UI (FORM_SRC ${UI_FILES})
QT4_WRAP_CPP(HEADER_FILES_MOC ${HEADER_FILES})
INCLUDE(${QT_USE_FILE})
ADD_DEFINITIONS(${QT_DEFINITIONS})
endif(Qt5Widgets_FOUND)


# Enable pthread library
if (UNIX)
	set(CMAKE_CXX_FLAGS "-pthread -Wno-enum-compare")
endif()

include_directories(../KromekDriver/include ../SpectrometerDriver)
add_executable(SpectrometerExample ${SOURCE_FILES} ${FORM_SRC} ${FORMS_HEADERS} ${HEADER_FILES_MOC})

if (Qt5Widgets_FOUND)
qt5_use_modules(SpectrometerExample Widgets)
target_link_libraries(SpectrometerExample SpectrometerDriver)
else()
target_link_libraries(SpectrometerExample SpectrometerDriver ${QT_LIBRARIES})
endif (Qt5Widgets_FOUND)
