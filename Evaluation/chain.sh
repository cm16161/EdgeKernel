#!/bin/bash

ts=$(date +%s%N)
let a=$(./get_value.sh usage_count)
let b=$(./get_from_whisk.sh $a)
./set_value.sh test $b > /dev/null
let finished=$((($(date +%s%N) - $ts)))
echo $finished ns >> Times/OW-Times
echo $(($finished/1000000)) ms >> Times/OW-Times

