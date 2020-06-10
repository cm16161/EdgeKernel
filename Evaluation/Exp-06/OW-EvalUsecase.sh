#!/bin/bash

for j in {1..50}
do
    ts=$(date +%s%N)
    for i in {1..11}
    do
	a=$(redis-cli rpop sensor_data)
	b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/usecase?sensor=$a)
	if [ b != "no" ]
	then
	    wget -O/dev/null -q "https://slack.com/api/chat.postMessage?token=xoxp-1084396346052-1063494560487-1102230419520-c0ec50f4afdae4c04103245d07d01e57&channel=edgekernel&text=ALERT-$b&pretty=1"
	fi
	
    done
    let finished=$((($(date +%s%N) - $ts)))
    # echo $finished ns >> Times/OW-Times
    echo $(($finished/1000000)) # >> Times/EvalFib/OW-Times
done
