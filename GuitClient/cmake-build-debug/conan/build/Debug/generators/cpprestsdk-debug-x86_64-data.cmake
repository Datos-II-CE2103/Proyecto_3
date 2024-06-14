########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND cpprestsdk_COMPONENT_NAMES cpprestsdk::cpprestsdk_boost_internal cpprestsdk::cpprestsdk_openssl_internal cpprestsdk::cpprestsdk_zlib_internal cpprestsdk::cpprestsdk_websocketpp_internal cpprestsdk::cpprest)
list(REMOVE_DUPLICATES cpprestsdk_COMPONENT_NAMES)
if(DEFINED cpprestsdk_FIND_DEPENDENCY_NAMES)
  list(APPEND cpprestsdk_FIND_DEPENDENCY_NAMES websocketpp OpenSSL Boost ZLIB)
  list(REMOVE_DUPLICATES cpprestsdk_FIND_DEPENDENCY_NAMES)
else()
  set(cpprestsdk_FIND_DEPENDENCY_NAMES websocketpp OpenSSL Boost ZLIB)
endif()
set(websocketpp_FIND_MODE "NO_MODULE")
set(OpenSSL_FIND_MODE "NO_MODULE")
set(Boost_FIND_MODE "NO_MODULE")
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(cpprestsdk_PACKAGE_FOLDER_DEBUG "/home/alex/.conan2/p/b/cppre392ba417172d2/p")
set(cpprestsdk_BUILD_MODULES_PATHS_DEBUG )


set(cpprestsdk_INCLUDE_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/include")
set(cpprestsdk_RES_DIRS_DEBUG )
set(cpprestsdk_DEFINITIONS_DEBUG "-D_NO_ASYNCRTIMP"
			"-D_NO_PPLXIMP")
set(cpprestsdk_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_OBJECTS_DEBUG )
set(cpprestsdk_COMPILE_DEFINITIONS_DEBUG "_NO_ASYNCRTIMP"
			"_NO_PPLXIMP")
set(cpprestsdk_COMPILE_OPTIONS_C_DEBUG )
set(cpprestsdk_COMPILE_OPTIONS_CXX_DEBUG )
set(cpprestsdk_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_BIN_DIRS_DEBUG )
set(cpprestsdk_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_LIBS_DEBUG cpprest)
set(cpprestsdk_SYSTEM_LIBS_DEBUG pthread)
set(cpprestsdk_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_FRAMEWORKS_DEBUG )
set(cpprestsdk_BUILD_DIRS_DEBUG )
set(cpprestsdk_NO_SONAME_MODE_DEBUG FALSE)


# COMPOUND VARIABLES
set(cpprestsdk_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_COMPILE_OPTIONS_C_DEBUG}>")
set(cpprestsdk_LINKER_FLAGS_DEBUG
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_SHARED_LINK_FLAGS_DEBUG}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_EXE_LINK_FLAGS_DEBUG}>")


set(cpprestsdk_COMPONENTS_DEBUG cpprestsdk::cpprestsdk_boost_internal cpprestsdk::cpprestsdk_openssl_internal cpprestsdk::cpprestsdk_zlib_internal cpprestsdk::cpprestsdk_websocketpp_internal cpprestsdk::cpprest)
########### COMPONENT cpprestsdk::cpprest VARIABLES ############################################

set(cpprestsdk_cpprestsdk_cpprest_INCLUDE_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/include")
set(cpprestsdk_cpprestsdk_cpprest_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_cpprestsdk_cpprest_BIN_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_cpprestsdk_cpprest_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_cpprestsdk_cpprest_RES_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_DEFINITIONS_DEBUG "-D_NO_ASYNCRTIMP"
			"-D_NO_PPLXIMP")
set(cpprestsdk_cpprestsdk_cpprest_OBJECTS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_COMPILE_DEFINITIONS_DEBUG "_NO_ASYNCRTIMP"
			"_NO_PPLXIMP")
set(cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_C_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_CXX_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprest_LIBS_DEBUG cpprest)
set(cpprestsdk_cpprestsdk_cpprest_SYSTEM_LIBS_DEBUG pthread)
set(cpprestsdk_cpprestsdk_cpprest_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_FRAMEWORKS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_DEPENDENCIES_DEBUG cpprestsdk::cpprestsdk_boost_internal cpprestsdk::cpprestsdk_openssl_internal cpprestsdk::cpprestsdk_zlib_internal cpprestsdk::cpprestsdk_websocketpp_internal)
set(cpprestsdk_cpprestsdk_cpprest_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprest_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(cpprestsdk_cpprestsdk_cpprest_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_cpprestsdk_cpprest_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_cpprestsdk_cpprest_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_cpprestsdk_cpprest_EXE_LINK_FLAGS_DEBUG}>
)
set(cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT cpprestsdk::cpprestsdk_websocketpp_internal VARIABLES ############################################

set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_INCLUDE_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_BIN_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_RES_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_OBJECTS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_C_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_CXX_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_SYSTEM_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORKS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPENDENCIES_DEBUG websocketpp::websocketpp)
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_EXE_LINK_FLAGS_DEBUG}>
)
set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT cpprestsdk::cpprestsdk_zlib_internal VARIABLES ############################################

set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_INCLUDE_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_BIN_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_RES_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_OBJECTS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_C_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_CXX_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_SYSTEM_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORKS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPENDENCIES_DEBUG ZLIB::ZLIB)
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_EXE_LINK_FLAGS_DEBUG}>
)
set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT cpprestsdk::cpprestsdk_openssl_internal VARIABLES ############################################

set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_INCLUDE_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_BIN_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_RES_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_OBJECTS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_C_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_CXX_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_SYSTEM_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORKS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPENDENCIES_DEBUG openssl::openssl)
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_EXE_LINK_FLAGS_DEBUG}>
)
set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_C_DEBUG}>")
########### COMPONENT cpprestsdk::cpprestsdk_boost_internal VARIABLES ############################################

set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_INCLUDE_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIB_DIRS_DEBUG "${cpprestsdk_PACKAGE_FOLDER_DEBUG}/lib")
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_BIN_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBRARY_TYPE_DEBUG STATIC)
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_IS_HOST_WINDOWS_DEBUG 0)
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_RES_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_OBJECTS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_DEFINITIONS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_C_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_CXX_DEBUG "")
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_SYSTEM_LIBS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORK_DIRS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORKS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPENDENCIES_DEBUG Boost::headers Boost::system Boost::random Boost::thread Boost::filesystem Boost::chrono Boost::atomic Boost::date_time Boost::regex)
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_SHARED_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_EXE_LINK_FLAGS_DEBUG )
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_NO_SONAME_MODE_DEBUG FALSE)

# COMPOUND VARIABLES
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LINKER_FLAGS_DEBUG
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_SHARED_LINK_FLAGS_DEBUG}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_EXE_LINK_FLAGS_DEBUG}>
)
set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_DEBUG
    "$<$<COMPILE_LANGUAGE:CXX>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_CXX_DEBUG}>"
    "$<$<COMPILE_LANGUAGE:C>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_C_DEBUG}>")