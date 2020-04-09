#!/bin/bash

ts=$(date +%s%N)
let a=$(./get_value.sh usage_count)
let b=$(./get_from_whisk.sh $a)
./set_value.sh test $b > /dev/null
echo $(./get_value.sh test)
let finished=$((($(date +%s%N) - $ts)))
echo $finished ns
echo $(($finished/1000000)) ms

