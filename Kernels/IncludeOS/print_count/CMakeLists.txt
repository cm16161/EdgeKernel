cmake_minimum_required(VERSION 3.0)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
project (print_count)
include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake OPTIONAL RESULT_VARIABLE HAS_CONAN)
conan_basic_setup()
include(os)

os_add_executable(print_count "Print the number of times the Chain-System has been run" main.cpp)
os_add_drivers(print_count virtionet vmxnet3 e1000 boot_logger)
os_add_plugins(print_count autoconf)
os_add_stdout(print_count default_stdout)
os_add_ssl_certificates(print_count)
