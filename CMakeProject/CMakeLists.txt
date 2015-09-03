# Author: Eugenio Marinetto [nenetto@gmail.com]

# This is an example file for a Project Configuration
# using CMake.

# The purpose is to create an executable file with no
# dependencies

#### Code SRC and inc
# Change your src files into src folder
# Change your header files into inc folder

#### Installed files
# The project will create an install folder after compilation
# All files into install folder will be copied there too.


######################################
# Minimum version of CMake required ##
######################################

# Author: Eugenio Marinetto [nenetto@gmail.com]

#### Code SRC and inc
# Change your src files into src folder
# Change your header files into inc folder

#### Installed files
# The project will create an install folder after compilation
# All files into install folder will be copied there too.

# Minimum version of CMake required
cmake_minimum_required (VERSION 3.0.2)

#############################
# Creation of the project  ##
#############################
set(MYPROJECT_NAME "TemplateCreator")
project(${MYPROJECT_NAME})

###############################
# Options for Configuration  ##
###############################
# Install Dir by default
set(INSTALL_DIR_DEFAULT "install" CACHE PATH "InstaLL DIR")
# Default Value for the Documentation flag
option(BUILD_DOCUMENTATION_DEFAULT "Create and install the HTML based API documentation (requires Doxygen)" OFF)
# Default Value for the Cmake Debug flag
option(CMAKE_DEBUG_FLAG_DEFAULT "Create and install the HTML based API documentation (requires Doxygen)" ON)
# Type of project
set(PROJECT_TYPE "Executable" CACHE STRING
  "Type of project you want to create")
set(PROJECT_VALUES
    Executable
    Library)
set_property(CACHE PROJECT_TYPE PROPERTY STRINGS ${PROJECT_VALUES})
# Name of the project default
set(PROJECT_NAME_DEFAULT "MyProject" CACHE PATH "Name of the Project")
# Folder to save the template
set(SOURCE_DIR_DEFAULT "${${PROJECT_NAME}_BINARY_DIR}/${PROJECT_NAME_DEFAULT}" CACHE PATH "Directory where save the project")


###############################
# Show options selected      ##
###############################
message(STATUS "#########################################################################")
message(STATUS "Project ='${PROJECT_NAME_DEFAULT}'")
message(STATUS "Project folder ='${SOURCE_DIR_DEFAULT}'")
message(STATUS "Project Type='${PROJECT_TYPE}'")
message(STATUS "Install folder='${INSTALL_DIR_DEFAULT}'")
message(STATUS "Build Documentation='${BUILD_DOCUMENTATION_DEFAULT}'")
message(STATUS "CMake Debug flag='${CMAKE_DEBUG_FLAG_DEFAULT}'")
message(STATUS "#########################################################################")

########################
# Create Source Folder #
########################

# Delete previous folder
file(REMOVE_RECURSE ${SOURCE_DIR_DEFAULT})

# Create folder
file(MAKE_DIRECTORY ${SOURCE_DIR_DEFAULT})

########################
# CMake  Folder        #
########################
set(CMAKE_FOLDER ${SOURCE_DIR_DEFAULT}/CMake)

# Delete previous folder
file(REMOVE_RECURSE ${CMAKE_FOLDER})

# Create folder
file(MAKE_DIRECTORY ${CMAKE_FOLDER})


# Copy common files
file(COPY
        ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/Config.cmake.in
        ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/ConfigInstall.cmake.in
        ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/FilesToBeCopiedDuringInstall.cmake.in
        ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/CopyDll.cmake
    DESTINATION
        ${CMAKE_FOLDER})

configure_file("${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/Project.external.cmake.in" "${CMAKE_FOLDER}/${PROJECT_NAME}-external.cmake" @ONLY)
configure_file("${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/Project.internal.cmake.in" "${CMAKE_FOLDER}/${PROJECT_NAME}-internal.cmake" @ONLY)

if(PROJECT_TYPE MATCHES "Executable")
    file(COPY
            ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/Config.h.exe.in
        DESTINATION
            ${CMAKE_FOLDER})

    file(RENAME
            ${CMAKE_FOLDER}/Config.h.exe.in
            ${CMAKE_FOLDER}/Config.h.in)

elseif(${PROJECT_TYPE} MATCHES "Library")

    file(COPY
            ${${PROJECT_NAME}_SOURCE_DIR}/CMake_Templates/Config.h.lib.in
        DESTINATION
            ${CMAKE_FOLDER})

    file(RENAME
            ${CMAKE_FOLDER}/Config.h.lib.in
            ${CMAKE_FOLDER}/Config.h.in)
endif()

########################
# Doc Folder           #
########################
set(DOC_FOLDER ${SOURCE_DIR_DEFAULT}/doc)

# Delete previous folder
file(REMOVE_RECURSE ${DOC_FOLDER})

# Create folder
file(MAKE_DIRECTORY ${DOC_FOLDER})

# Copy common files
file(COPY
        ${${PROJECT_NAME}_SOURCE_DIR}/doc_Templates/ConfigureDocumentation.cmake
        ${${PROJECT_NAME}_SOURCE_DIR}/doc_Templates/Doxyfile.in
    DESTINATION
        ${DOC_FOLDER})

########################
# Inc    Folder        #
########################
set(INC_FOLDER ${SOURCE_DIR_DEFAULT}/inc)

# Delete previous folder
file(REMOVE_RECURSE ${INC_FOLDER})

# Create folder
file(MAKE_DIRECTORY ${INC_FOLDER})


if(${PROJECT_TYPE} MATCHES "Executable")

    set(HEADER_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/inc_Templates/Header.h.exe.in")
    set(HEADER_FILE "${INC_FOLDER}/${PROJECT_NAME_DEFAULT}.h")

elseif(${PROJECT_TYPE} MATCHES "Library")

    set(HEADER_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/inc_Templates/PublicHeader.h.lib.in")
    set(HEADER_FILE "${INC_FOLDER}/${PROJECT_NAME_DEFAULT}PublicHeader.h")

endif()

configure_file(${HEADER_FILE_TEMPLATE} ${HEADER_FILE} @ONLY)


########################
# Src    Folder        #
########################
set(SRC_FOLDER ${SOURCE_DIR_DEFAULT}/src)

# Delete previous folder
file(REMOVE_RECURSE ${SRC_FOLDER})

# Create folder
file(MAKE_DIRECTORY ${SRC_FOLDER})

if(PROJECT_TYPE MATCHES "Executable")

    set(SRC_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/src_Templates/source.cpp.exe.in")

elseif(${PROJECT_TYPE} MATCHES "Library")

    set(SRC_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/src_Templates/source.cpp.lib.in")

endif()

set(SRC_FILE "${SRC_FOLDER}/${PROJECT_NAME_DEFAULT}.cpp")

configure_file(${SRC_FILE_TEMPLATE} ${SRC_FILE} @ONLY)


######################
# install Folder     #
######################
set(INSTALL_FOLDER ${SOURCE_DIR_DEFAULT}/install)

# Delete previous folder
file(REMOVE_RECURSE ${INSTALL_FOLDER})

# Create folder
file(MAKE_DIRECTORY ${INSTALL_FOLDER})

# Configure file

configure_file("${${PROJECT_NAME}_SOURCE_DIR}/install_Templates/ProjectINFO.md.in" "${INSTALL_FOLDER}/${PROJECT_NAME_DEFAULT}_info.md" @ONLY)


######################
# CMakeLists.txt     #
######################
set(CMAKELISTS_FILE "${SOURCE_DIR_DEFAULT}/CMakeLists.txt")

if(EXISTS CMAKELISTS_FILE)
  file(REMOVE CMAKELISTS_FILE)
endif()

if(PROJECT_TYPE MATCHES "Executable")

    set(CMAKELISTS_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/CMakeLists_Templates/CMakeLists.txt.exe.in")

elseif(${PROJECT_TYPE} MATCHES "Library")

    set(CMAKELISTS_FILE_TEMPLATE "${${PROJECT_NAME}_SOURCE_DIR}/CMakeLists_Templates/CMakeLists.txt.lib.in")

endif()


configure_file(${CMAKELISTS_FILE_TEMPLATE} ${CMAKELISTS_FILE} @ONLY)
