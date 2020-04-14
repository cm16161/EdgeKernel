#!/bin/bash

ts=$(date +%s%N)
let a=$(./get_value.sh fib_number)
let b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/fib?fib_number=$a)
./set_value.sh ow-fib-res $b > /dev/null
let finished=$((($(date +%s%N) - $ts)))
# echo $finished ns >> Times/OW-Times
echo $(($finished/1000000)) >> Times/EvalFib/OW-Times

