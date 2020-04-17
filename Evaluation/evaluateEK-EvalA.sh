#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/EK-Times
}

cd ../server

for j in {1..10}
do
    for i in {1..10}
    do
	# echo "Starting Run $j:$i" 
	redis-cli lpush eval_a_trigger 1 >/dev/null
	ruby server.rb
	# ./EK-EvalA.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
