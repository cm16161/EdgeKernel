#!/bin/bash

root=$(pwd)
cd ../Kernels/MirageOS/evaluation_test_fibonacci
ts=$(date +%s%N)
solo5-hvt --net:service=tap10003 -- eval_test_fib.hvt --ipv4=10.0.0.3/24 --ipv4-gateway=10.0.0.1 > /dev/null 2>&1
let finished=$((($(date +%s%N) - $ts)))
cd $root
# echo $finished ns >> Times/EK-Times
echo $(($finished/1000000))  >> Times/EvalFib/EK-Times

