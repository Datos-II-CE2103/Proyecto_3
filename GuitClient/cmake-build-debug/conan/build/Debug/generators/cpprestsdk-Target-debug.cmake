# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(cpprestsdk_FRAMEWORKS_FOUND_DEBUG "") # Will be filled later
conan_find_apple_frameworks(cpprestsdk_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_FRAMEWORKS_DEBUG}" "${cpprestsdk_FRAMEWORK_DIRS_DEBUG}")

set(cpprestsdk_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET cpprestsdk_DEPS_TARGET)
    add_library(cpprestsdk_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET cpprestsdk_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Debug>:${cpprestsdk_FRAMEWORKS_FOUND_DEBUG}>
             $<$<CONFIG:Debug>:${cpprestsdk_SYSTEM_LIBS_DEBUG}>
             $<$<CONFIG:Debug>:Boost::headers;Boost::system;Boost::random;Boost::thread;Boost::filesystem;Boost::chrono;Boost::atomic;Boost::date_time;Boost::regex;openssl::openssl;cpprestsdk::cpprestsdk_boost_internal;cpprestsdk::cpprestsdk_openssl_internal;cpprestsdk::cpprestsdk_zlib_internal;cpprestsdk::cpprestsdk_websocketpp_internal;ZLIB::ZLIB;websocketpp::websocketpp>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### cpprestsdk_DEPS_TARGET to all of them
conan_package_library_targets("${cpprestsdk_LIBS_DEBUG}"    # libraries
                              "${cpprestsdk_LIB_DIRS_DEBUG}" # package_libdir
                              "${cpprestsdk_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_DEPS_TARGET
                              cpprestsdk_LIBRARIES_TARGETS  # out_libraries_targets
                              "_DEBUG"
                              "cpprestsdk"    # package_name
                              "${cpprestsdk_NO_SONAME_MODE_DEBUG}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${cpprestsdk_BUILD_DIRS_DEBUG} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Debug ########################################

    ########## COMPONENT cpprestsdk::cpprest #############

        set(cpprestsdk_cpprestsdk_cpprest_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(cpprestsdk_cpprestsdk_cpprest_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_cpprestsdk_cpprest_FRAMEWORKS_DEBUG}" "${cpprestsdk_cpprestsdk_cpprest_FRAMEWORK_DIRS_DEBUG}")

        set(cpprestsdk_cpprestsdk_cpprest_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET)
            add_library(cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET' to all of them
        conan_package_library_targets("${cpprestsdk_cpprestsdk_cpprest_LIBS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprest_LIB_DIRS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprest_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_cpprestsdk_cpprest_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprest_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET
                              cpprestsdk_cpprestsdk_cpprest_LIBRARIES_TARGETS
                              "_DEBUG"
                              "cpprestsdk_cpprestsdk_cpprest"
                              "${cpprestsdk_cpprestsdk_cpprest_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET cpprestsdk::cpprest
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_LIBRARIES_TARGETS}>
                     )

        if("${cpprestsdk_cpprestsdk_cpprest_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET cpprestsdk::cpprest
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         cpprestsdk_cpprestsdk_cpprest_DEPS_TARGET)
        endif()

        set_property(TARGET cpprestsdk::cpprest APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprest APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprest APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_LIB_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprest APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprest APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprest_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT cpprestsdk::cpprestsdk_websocketpp_internal #############

        set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORKS_DEBUG}" "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORK_DIRS_DEBUG}")

        set(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET)
            add_library(cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET' to all of them
        conan_package_library_targets("${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIB_DIRS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET
                              cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBRARIES_TARGETS
                              "_DEBUG"
                              "cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBRARIES_TARGETS}>
                     )

        if("${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_DEPS_TARGET)
        endif()

        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_LIB_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_websocketpp_internal APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_websocketpp_internal_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT cpprestsdk::cpprestsdk_zlib_internal #############

        set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORKS_DEBUG}" "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORK_DIRS_DEBUG}")

        set(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET)
            add_library(cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET' to all of them
        conan_package_library_targets("${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIB_DIRS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET
                              cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBRARIES_TARGETS
                              "_DEBUG"
                              "cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBRARIES_TARGETS}>
                     )

        if("${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_DEPS_TARGET)
        endif()

        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_LIB_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_zlib_internal APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_zlib_internal_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT cpprestsdk::cpprestsdk_openssl_internal #############

        set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORKS_DEBUG}" "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORK_DIRS_DEBUG}")

        set(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET)
            add_library(cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET' to all of them
        conan_package_library_targets("${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIB_DIRS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET
                              cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBRARIES_TARGETS
                              "_DEBUG"
                              "cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBRARIES_TARGETS}>
                     )

        if("${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_DEPS_TARGET)
        endif()

        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_LIB_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_openssl_internal APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_openssl_internal_COMPILE_OPTIONS_DEBUG}>)

    ########## COMPONENT cpprestsdk::cpprestsdk_boost_internal #############

        set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORKS_FOUND_DEBUG "")
        conan_find_apple_frameworks(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORKS_FOUND_DEBUG "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORKS_DEBUG}" "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORK_DIRS_DEBUG}")

        set(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET)
            add_library(cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_FRAMEWORKS_FOUND_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_SYSTEM_LIBS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPENDENCIES_DEBUG}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET' to all of them
        conan_package_library_targets("${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIB_DIRS_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_BIN_DIRS_DEBUG}" # package_bindir
                              "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBRARY_TYPE_DEBUG}"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_IS_HOST_WINDOWS_DEBUG}"
                              cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET
                              cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBRARIES_TARGETS
                              "_DEBUG"
                              "cpprestsdk_cpprestsdk_cpprestsdk_boost_internal"
                              "${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_NO_SONAME_MODE_DEBUG}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_OBJECTS_DEBUG}>
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBRARIES_TARGETS}>
                     )

        if("${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIBS_DEBUG}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET cpprestsdk::cpprestsdk_boost_internal
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_DEPS_TARGET)
        endif()

        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LINKER_FLAGS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_INCLUDE_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_LIB_DIRS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_DEFINITIONS_DEBUG}>)
        set_property(TARGET cpprestsdk::cpprestsdk_boost_internal APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Debug>:${cpprestsdk_cpprestsdk_cpprestsdk_boost_internal_COMPILE_OPTIONS_DEBUG}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET cpprestsdk::cpprestsdk APPEND PROPERTY INTERFACE_LINK_LIBRARIES cpprestsdk::cpprest)
    set_property(TARGET cpprestsdk::cpprestsdk APPEND PROPERTY INTERFACE_LINK_LIBRARIES cpprestsdk::cpprestsdk_websocketpp_internal)
    set_property(TARGET cpprestsdk::cpprestsdk APPEND PROPERTY INTERFACE_LINK_LIBRARIES cpprestsdk::cpprestsdk_zlib_internal)
    set_property(TARGET cpprestsdk::cpprestsdk APPEND PROPERTY INTERFACE_LINK_LIBRARIES cpprestsdk::cpprestsdk_openssl_internal)
    set_property(TARGET cpprestsdk::cpprestsdk APPEND PROPERTY INTERFACE_LINK_LIBRARIES cpprestsdk::cpprestsdk_boost_internal)

########## For the modules (FindXXX)
set(cpprestsdk_LIBRARIES_DEBUG cpprestsdk::cpprestsdk)
