#!/bin/bash

for j in {1..10}
do
    for i in {1..10}
    do
	ts=$(date +%s%N)
	a=$(../get_value.sh ow-sensor-reading)
	b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/alert?sensor=$a)
	../set_value.sh ow-alert-output $b > /dev/null
	let finished=$((($(date +%s%N) - $ts)))
	# echo $finished ns >> Times/OW-Times
	echo $(($finished/1000000)) # >> Times/EvalFib/OW-Times
    done
done
