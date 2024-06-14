########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(websocketpp_FIND_QUIETLY)
    set(websocketpp_MESSAGE_MODE VERBOSE)
else()
    set(websocketpp_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/websocketppTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${websocketpp_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(websocketpp_VERSION_STRING "0.8.2")
set(websocketpp_INCLUDE_DIRS ${websocketpp_INCLUDE_DIRS_DEBUG} )
set(websocketpp_INCLUDE_DIR ${websocketpp_INCLUDE_DIRS_DEBUG} )
set(websocketpp_LIBRARIES ${websocketpp_LIBRARIES_DEBUG} )
set(websocketpp_DEFINITIONS ${websocketpp_DEFINITIONS_DEBUG} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${websocketpp_BUILD_MODULES_PATHS_DEBUG} )
    message(${websocketpp_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


