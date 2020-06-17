#!/bin/bash

for j in {1..10}
do
    for i in {1..10}
    do
	ts=$(date +%s%N)
	a=$(redis-cli get ow-door)
	b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/lights?sensor=$a)
	redis-cli set ow-light-output $b > /dev/null
	let finished=$((($(date +%s%N) - $ts)))
	echo $(($finished/1000000))

    done
done
