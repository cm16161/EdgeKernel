#!/usr/bin/env sh
export CONAN_OLD_PATH="$PATH"

while read -r line; do
    LINE="$(eval echo $line)";
    export "$LINE";
done < "/home/chetan/Documents/Unikernel-Serverless/Kernels/pop_int_push_char/build/environment.sh.env"

export CONAN_OLD_PS1="$PS1"
export PS1="(conanenv) $PS1"
