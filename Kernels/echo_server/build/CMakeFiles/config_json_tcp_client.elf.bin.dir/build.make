# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build

# Include any dependencies generated for this target.
include CMakeFiles/config_json_tcp_client.elf.bin.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/config_json_tcp_client.elf.bin.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/config_json_tcp_client.elf.bin.dir/flags.make

config.json.o: ../config.json
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating config.json.o"
	/usr/bin/objcopy -I binary -O elf64-x86-64 -B i386 --rename-section .data=.config,CONTENTS,ALLOC,LOAD,READONLY,DATA /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/config.json /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build/config.json.o

# Object files for target config_json_tcp_client.elf.bin
config_json_tcp_client_elf_bin_OBJECTS =

# External object files for target config_json_tcp_client.elf.bin
config_json_tcp_client_elf_bin_EXTERNAL_OBJECTS = \
"/home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build/config.json.o"

lib/libconfig_json_tcp_client.elf.bin.a: config.json.o
lib/libconfig_json_tcp_client.elf.bin.a: CMakeFiles/config_json_tcp_client.elf.bin.dir/build.make
lib/libconfig_json_tcp_client.elf.bin.a: CMakeFiles/config_json_tcp_client.elf.bin.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library lib/libconfig_json_tcp_client.elf.bin.a"
	$(CMAKE_COMMAND) -P CMakeFiles/config_json_tcp_client.elf.bin.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/config_json_tcp_client.elf.bin.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/config_json_tcp_client.elf.bin.dir/build: lib/libconfig_json_tcp_client.elf.bin.a

.PHONY : CMakeFiles/config_json_tcp_client.elf.bin.dir/build

CMakeFiles/config_json_tcp_client.elf.bin.dir/requires:

.PHONY : CMakeFiles/config_json_tcp_client.elf.bin.dir/requires

CMakeFiles/config_json_tcp_client.elf.bin.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/config_json_tcp_client.elf.bin.dir/cmake_clean.cmake
.PHONY : CMakeFiles/config_json_tcp_client.elf.bin.dir/clean

CMakeFiles/config_json_tcp_client.elf.bin.dir/depend: config.json.o
	cd /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build /home/chetan/Documents/Unikernel-Serverless/Kernels/echo_server/build/CMakeFiles/config_json_tcp_client.elf.bin.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/config_json_tcp_client.elf.bin.dir/depend

