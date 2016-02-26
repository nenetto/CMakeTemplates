set(MATLAB_VERSIONS_SUPPORTED
  8.6 R2015b
  8.5 R2015a
  8.4 R2014b
  8.3 R2014a
  8.2 R2013b
  8.1 R2013a)


if(WIN32)
  foreach(VERSION ${MATLAB_VERSIONS_SUPPORTED})
    if((NOT DEFINED MATLAB_DIR) OR ("${MATLAB_DIR}" STREQUAL "") OR ("${MATLAB_DIR}" STREQUAL "/registry"))
      get_filename_component(MATLAB_DIR
        "[HKEY_LOCAL_MACHINE\\SOFTWARE\\MathWorks\\MATLAB\\${VERSION};MATLABROOT]"
        ABSOLUTE)
    endif()
  endforeach()

  if(CMAKE_SIZEOF_VOID_P MATCHES "8")
    set(WINDIR "win64")
  elseif(CMAKE_SIZEOF_VOID_P MATCHES "4")
    set(WINDIR "win32")
  else()
    message(FATAL_ERROR "CMAKE_SIZEOF_VOID_P (${CMAKE_SIZEOF_VOID_P}) was not recognized")
  endif()

  if(${CMAKE_GENERATOR} MATCHES "Visual Studio*")
    set(MATLAB_LIBRARIES_DIR "${MATLAB_DIR}/extern/lib/${WINDIR}/microsoft/")
  else()
    message(FATAL_ERROR "Generator (${CMAKE_GENERATOR}) is not supported")
  endif()

  find_library(MATLAB_ENG_LIBRARY libeng
    HINTS ${MATLAB_LIBRARIES_DIR})
  find_library(MATLAB_MAT_LIBRARY libmat
    HINTS ${MATLAB_LIBRARIES_DIR})
  find_library(MATLAB_MEX_LIBRARY libmex
    HINTS ${MATLAB_LIBRARIES_DIR})
  find_library(MATLAB_MX_LIBRARY libmx
    HINTS ${MATLAB_LIBRARIES_DIR})
  find_library(MATLAB_GPU_LIBRARY gpu
    HINTS ${MATLAB_LIBRARIES_DIR})

elseif(UNIX)
  if((NOT DEFINED MATLAB_DIR) OR ("${MATLAB_DIR}" STREQUAL ""))
    execute_process(
      COMMAND bash -c "which matlab"
      COMMAND bash -c "xargs readlink"
      COMMAND bash -c "xargs dirname"
      COMMAND bash -c "xargs dirname"
      COMMAND bash -c "xargs echo -n"
      OUTPUT_VARIABLE MATLAB_DIR)
  endif()

  if(APPLE)
    set(EXT .dylib)

    # if attempts to find MATLAB_DIR have so far failed, look in the Applications folder
    if((NOT DEFINED MATLAB_DIR) OR ("${MATLAB_DIR}" STREQUAL ""))
      foreach(VERSION ${MATLAB_VERSIONS_SUPPORTED})
        if((NOT DEFINED MATLAB_DIR) OR ("${MATLAB_DIR}" STREQUAL ""))
          if(EXISTS "/Applications/MATLAB_${VERSION}.app")
            set(MATLAB_DIR "/Applications/MATLAB_${VERSION}.app")
          endif()
        endif()
      endforeach()
    endif()

  else()
    set(EXT .so)
  endif()

  execute_process(
    COMMAND bash -c "find \"${MATLAB_DIR}/bin\" -name libeng${EXT}"
    COMMAND bash -c "xargs echo -n"
    OUTPUT_VARIABLE ENG_LIBRARY)
  set(MATLAB_ENG_LIBRARY "${ENG_LIBRARY}" CACHE FILEPATH "")
  execute_process(
    COMMAND bash -c "find \"${MATLAB_DIR}/bin\" -name libmat${EXT}"
    COMMAND bash -c "xargs echo -n"
    OUTPUT_VARIABLE MAT_LIBRARY)
  set(MATLAB_MAT_LIBRARY "${MAT_LIBRARY}" CACHE FILEPATH "")
  execute_process(
    COMMAND bash -c "find \"${MATLAB_DIR}/bin\" -name libmex${EXT}"
    COMMAND bash -c "xargs echo -n"
    OUTPUT_VARIABLE MEX_LIBRARY)
  set(MATLAB_MEX_LIBRARY "${MEX_LIBRARY}" CACHE FILEPATH "")
  execute_process(
    COMMAND bash -c "find \"${MATLAB_DIR}/bin\" -name libmx${EXT}"
    COMMAND bash -c "xargs echo -n"
    OUTPUT_VARIABLE MX_LIBRARY)
  set(MATLAB_MX_LIBRARY "${MX_LIBRARY}" CACHE FILEPATH "")
  execute_process(
    COMMAND bash -c "find \"${MATLAB_DIR}/bin\" -name libmwgpu${EXT}"
    COMMAND bash -c "xargs echo -n"
    OUTPUT_VARIABLE GPU_LIBRARY)
  set(MATLAB_GPU_LIBRARY "${GPU_LIBRARY}" CACHE FILEPATH "")

else()
  message(FATAL_ERROR "Platform is not supported.")
endif()

set(MATLAB_LIBRARIES
  ${MATLAB_ENG_LIBRARY}
  ${MATLAB_MAT_LIBRARY}
  ${MATLAB_MEX_LIBRARY}
  ${MATLAB_MX_LIBRARY}
  ${MATLAB_GPU_LIBRARY})

find_path(MATLAB_INCLUDE_DIR mex.h
  HINTS "${MATLAB_DIR}/extern/include")
find_path(MATLAB_GPU_INCLUDE_DIR gpu/mxGPUArray.h
  HINTS "${MATLAB_DIR}/toolbox/distcomp/gpu/extern/include/")

set(MATLAB_INCLUDE_DIRS
  ${MATLAB_INCLUDE_DIR}
  ${MATLAB_GPU_INCLUDE_DIR})

mark_as_advanced(
  MATLAB_ENG_LIBRARY
  MATLAB_MAT_LIBRARY
  MATLAB_MEX_LIBRARY
  MATLAB_MX_LIBRARY
  MATLAB_GPU_LIBRARY
  MATLAB_INCLUDE_DIR
  MATLAB_GPU_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MATLAB DEFAULT_MSG MATLAB_LIBRARIES MATLAB_INCLUDE_DIRS)
