#!/bin/bash

# redis-cli set eval_test_consume_all 0
# ts=$(date +%s%N)
for i in {1..100}
do
    redis-cli set consume_all_count 0 > /dev/null
    ts=$(date +%s%N)
    list=$(seq -s ' ' $(($i * 100)))
    echo "$i / 100"
    redis-cli lpush eval_test_consume_all_trigger $list > /dev/null

    let fin=$(redis-cli llen eval_test_consume_all_trigger)
    while [ $fin -ne 0 ]
    do
	let fin=$(redis-cli llen eval_test_consume_all_trigger)
    done
    let finished=$((($(date +%s%N) - $ts)))
    echo "$(($finished/1000000)) ms"
    sleep 1
    
done

echo "Finished"

# # let fin=$(redis-cli get eval_test_fdc_count)
# # while [ $fin -ne 6 ]
# # do
# #       let fin=$(redis-cli get eval_test_consume_all)
# # done      
# let finished=$((($(date +%s%N) - $ts)))
# echo "$(($finished/1000000)) ms"

   
