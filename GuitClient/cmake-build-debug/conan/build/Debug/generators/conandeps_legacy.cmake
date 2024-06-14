message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(cpprestsdk)
find_package(Boost)

set(CONANDEPS_LEGACY  cpprestsdk::cpprestsdk  boost::boost )