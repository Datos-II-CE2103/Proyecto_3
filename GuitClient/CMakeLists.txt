cmake_minimum_required(VERSION 3.28)
project(GuitClient)
set(CMAKE_CXX_STANDARD 17)



find_package(cpprestsdk REQUIRED)
find_package(Boost)
find_package(CURL)
add_executable(GuitClient main.cpp
        Commands/Command.cpp
        Commands/Command.h
        Commands/InitCommand.cpp
        Commands/InitCommand.h
        Managers/NetworkManager.cpp
        Managers/NetworkManager.h
        Data_Structures/FileStatus.cpp
        Data_Structures/FileStatus.h
        Commands/AddCommand.cpp
        Commands/AddCommand.h
        Data_Structures/listaEnlazada.cpp
        Data_Structures/listaEnlazada.h
        Managers/DirectoryManager.cpp
        Managers/DirectoryManager.h
        Commands/lsCommand.cpp
        Commands/lsCommand.h
        Commands/guitCommit.cpp
        Commands/guitCommit.h
        Commands/guitStatus.cpp
        Commands/guitStatus.h)


target_link_libraries(GuitClient cpprestsdk::cpprestsdk)
target_link_libraries(GuitClient boost::boost)
target_link_libraries(GuitClient CURL::libcurl)
