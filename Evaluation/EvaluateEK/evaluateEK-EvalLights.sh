#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/EK/Eval-FDC
}

cd ../server

for j in {1..10}
do
    for i in {1..10}
    do
	# echo "Starting Run $j:$i" 
	redis-cli lpush eval_lights_input true >/dev/null
	ruby server.rb # >> Times/EK/Eval-Lights.txt
	# ./EK-EvalA.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
