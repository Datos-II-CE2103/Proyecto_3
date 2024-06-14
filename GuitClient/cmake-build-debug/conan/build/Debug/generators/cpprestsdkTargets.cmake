# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/cpprestsdk-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${cpprestsdk_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${cpprestsdk_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET cpprestsdk::cpprestsdk)
    add_library(cpprestsdk::cpprestsdk INTERFACE IMPORTED)
    message(${cpprestsdk_MESSAGE_MODE} "Conan: Target declared 'cpprestsdk::cpprestsdk'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/cpprestsdk-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()