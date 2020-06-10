#!/bin/bash


for j in {1..10}
do
    for i in {1..10}
    do
	ts=$(date +%s%N)
	current_average=$(../get_value.sh ow-dhs-current-average)
	new_value=$(../get_value.sh ow-dhs-new-value)
	day=$(../get_value.sh ow-dhs-days)
	redis-cli incr ow-dhs-days > /dev/null
	result=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/dhs?current=$current_average&new_value=$new_value&day=$day)
	../set_value.sh ow-dhs-current-average $result > /dev/null
	let finished=$((($(date +%s%N) - $ts)))
	# echo $finished ns
	echo $(($finished/1000000))
    done
done
