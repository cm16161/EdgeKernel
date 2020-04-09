#!/bin/bash

cd /home/chetan/Documents/Unikernel-Serverless/Kernels/MirageOS/evaluation_test_a
ts=$(date +%s%N)
solo5-hvt --net:service=tap10002 -- eval_test_a.hvt --ipv4=10.0.0.2/24 --ipv4-gateway=10.0.0.1 > /dev/null 2>&1
let finished=$((($(date +%s%N) - $ts)))
echo $finished ns
echo $(($finished/1000000)) ms

