########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(cpprestsdk_FIND_QUIETLY)
    set(cpprestsdk_MESSAGE_MODE VERBOSE)
else()
    set(cpprestsdk_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cpprestsdkTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${cpprestsdk_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(cpprestsdk_VERSION_STRING "2.10.19")
set(cpprestsdk_INCLUDE_DIRS ${cpprestsdk_INCLUDE_DIRS_DEBUG} )
set(cpprestsdk_INCLUDE_DIR ${cpprestsdk_INCLUDE_DIRS_DEBUG} )
set(cpprestsdk_LIBRARIES ${cpprestsdk_LIBRARIES_DEBUG} )
set(cpprestsdk_DEFINITIONS ${cpprestsdk_DEFINITIONS_DEBUG} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${cpprestsdk_BUILD_MODULES_PATHS_DEBUG} )
    message(${cpprestsdk_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


