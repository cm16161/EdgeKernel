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
CMAKE_SOURCE_DIR = /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build

# Utility rule file for popipuch_diskbuilder.

# Include the progress variables for this target.
include CMakeFiles/popipuch_diskbuilder.dir/progress.make

CMakeFiles/popipuch_diskbuilder: memdisk.fat


memdisk.fat: manifest.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Creating memdisk"
	/home/chetan/.conan/data/diskbuilder/0.15.1-14/includeos/latest/package/44fcf6b9a7fb86b2586303e3db40189d3b511830/bin/diskbuilder -o memdisk.fat /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build/certs

popipuch_diskbuilder: CMakeFiles/popipuch_diskbuilder
popipuch_diskbuilder: memdisk.fat
popipuch_diskbuilder: CMakeFiles/popipuch_diskbuilder.dir/build.make

.PHONY : popipuch_diskbuilder

# Rule to build all files generated by this target.
CMakeFiles/popipuch_diskbuilder.dir/build: popipuch_diskbuilder

.PHONY : CMakeFiles/popipuch_diskbuilder.dir/build

CMakeFiles/popipuch_diskbuilder.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/popipuch_diskbuilder.dir/cmake_clean.cmake
.PHONY : CMakeFiles/popipuch_diskbuilder.dir/clean

CMakeFiles/popipuch_diskbuilder.dir/depend:
	cd /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build /home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build/CMakeFiles/popipuch_diskbuilder.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/popipuch_diskbuilder.dir/depend

