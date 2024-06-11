cmake_minimum_required(VERSION 3.28)
project(GuitClient)
set(CMAKE_CXX_STANDARD 17)



find_package(cpprestsdk REQUIRED)
find_package(Boost)
add_executable(GuitClient main.cpp)


target_link_libraries(GuitClient cpprestsdk::cpprestsdk)
target_link_libraries(GuitClient boost::boost)
