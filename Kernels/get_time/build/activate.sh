#!/usr/bin/env sh
export CONAN_OLD_CC="$CC"
export CONAN_OLD_CXX="$CXX"
export CONAN_OLD_CFLAGS="$CFLAGS"
export CONAN_OLD_CXXFLAGS="$CXXFLAGS"
export CONAN_OLD_INCLUDEOS_VMRUNNER="$INCLUDEOS_VMRUNNER"
export CONAN_OLD_INCLUDEOS_CHAINLOADER="$INCLUDEOS_CHAINLOADER"
export CONAN_OLD_PATH="$PATH"
export CONAN_OLD_PYTHONPATH="$PYTHONPATH"

while read -r line; do
    LINE="$(eval echo $line)";
    export "$LINE";
done < "/home/chetan/Documents/Unikernel-Serverless/Kernels/get_time/build/environment.sh.env"

export CONAN_OLD_PS1="$PS1"
export PS1="(conanenv) $PS1"
