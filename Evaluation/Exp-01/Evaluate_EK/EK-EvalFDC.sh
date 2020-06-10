#!/bin/bash

function magic(){
    redis-cli set consume_all_count 0 > /dev/null
    ts=$(date +%s%N)
    list=$(seq -s ' ' $(($1 * 1)))
    redis-cli lpush $2 $list > /dev/null

    let fin=$(redis-cli llen $2)
    while [ $fin -ne 0 ]
    do
	let fin=$(redis-cli llen $2)
    done
    let finished=$((($(date +%s%N) - $ts)))
    echo "$(($finished/1000000)) ms"
    sleep 1
}

for i in {1..10}
do
    magic 1 eval_fdc_trigger
done

echo "Finished"
