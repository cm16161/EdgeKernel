#!/bin/bash

for j in {1..10}
do
    for i in {1..10}
    do
	ts=$(date +%s%N)
	a=$(../get_value.sh ow-doorb)
	b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/lights?sensor=$a)
	../set_value.sh ow-light-output $b > /dev/null
	let finished=$((($(date +%s%N) - $ts)))
	# echo $finished ns >> Times/OW-Times
	echo $(($finished/1000000))

    done
done
