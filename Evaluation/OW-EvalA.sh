#!/bin/bash

ts=$(date +%s%N)
let a=$(./get_value.sh usage_count)
let b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/increment?count=$a)
./set_value.sh test $b > /dev/null
let finished=$((($(date +%s%N) - $ts)))
# echo $finished ns
echo $(($finished/1000000)) >> Times/EvalA/OW-Times

