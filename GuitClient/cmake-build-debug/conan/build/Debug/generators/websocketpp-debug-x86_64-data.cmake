########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(websocketpp_COMPONENT_NAMES "")
if(DEFINED websocketpp_FIND_DEPENDENCY_NAMES)
  list(APPEND websocketpp_FIND_DEPENDENCY_NAMES OpenSSL Boost ZLIB)
  list(REMOVE_DUPLICATES websocketpp_FIND_DEPENDENCY_NAMES)
else()
  set(websocketpp_FIND_DEPENDENCY_NAMES OpenSSL Boost ZLIB)
endif()
set(OpenSSL_FIND_MODE "NO_MODULE")
set(Boost_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(websocketpp_PACKAGE_FOLDER_DEBUG "/home/alex/.conan2/p/webso7a47c7731495b/p")
set(websocketpp_BUILD_MODULES_PATHS_DEBUG )


set(websocketpp_INCLUDE_DIRS_DEBUG )
set(websocketpp_RES_DIRS_DEBUG )
set(websocketpp_DEFINITIONS_DEBUG )
set(websocketpp_SHARED_LINK_FLAGS_DEBUG )
set(websocketpp_EXE_LINK_FLAGS_DEBUG )
set(websocketpp_OBJECTS_DEBUG )
set(websocketpp_COMPILE_DEFINITIONS_DEBUG )
set(websocketpp_COMPILE_OPTIONS_C_DEBUG )
set(websocketpp_COMPILE_OPTIONS_CXX_DEBUG )
set(websocketpp_LIB_DIRS_DEBUG )
set(websocketpp_BIN_DIRS_DEBUG )
set(websocketpp_LIBRARY_TYPE_DEBUG UNKNOWN)
set(websocketpp_IS_HOST_WINDOWS_DEBUG 0)
set(websocketpp_LIBS_DEBUG )
set(websocketpp_SYSTEM_LIBS_DEBUG )
set(websocketpp_FRAMEWORK_DIRS_DEBUG )
set(websocketpp_FRAMEWORKS_DEBUG )
set(websocketpp_BUILD_DIRS_DEBUG )
set(websocketpp_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(websocketpp_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${websocketpp_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${websocketpp_COMPILE_OPTIONS_C_DEBUG}>")
set(websocketpp_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${websocketpp_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${websocketpp_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${websocketpp_EXE_LINK_FLAGS_DEBUG}>")


set(websocketpp_COMPONENTS_DEBUG )