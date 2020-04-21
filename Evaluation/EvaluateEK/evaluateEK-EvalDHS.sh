#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/EK/Eval-FDC
}

cd ../../server

for j in {1..10}
do
    for i in {1..10}
    do
	# echo "Starting Run $j:$i" 
	redis-cli lpush eval_test_dhs_new_value 10.0 >/dev/null
	ruby server.rb # >> ../Times/EK/Eval-DHS.txt
	# ./EK-EvalA.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
