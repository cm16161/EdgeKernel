cmake_minimum_required(VERSION 3.0)

#Avoid cmake from test compiling to host
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)


# Service
project (sleep)

#check if conan is already run outside of project
if (NOT DEFINED CONAN_DEPENDENCIES)
  include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake OPTIONAL RESULT_VARIABLE HAS_CONAN)
  if (NOT HAS_CONAN)
    message(FATAL_ERROR "missing conanbuildinfo.cmake did you forget to run conan install ?")
  endif()
endif()
conan_basic_setup()


include(os)

set(SOURCES
  main.cpp # ...add more here
  sleep.cpp
)

os_add_executable(sleep "Sleep Example" ${SOURCES})

if ("$ENV{PLATFORM}" STREQUAL "x86_solo5")
  os_add_drivers(sleep
    solo5net
    )
else()
  os_add_drivers(sleep
    virtionet
    vmxnet3
    e1000
    boot_logger
    )
endif()

os_add_stdout(sleep default_stdout)
os_add_plugins(sleep autoconf)
