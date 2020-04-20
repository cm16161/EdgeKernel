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
	# ./EK-EvalFib.sh
	redis-cli lpush eval_fib_trigger 1 >/dev/null
	ruby server.rb # >> ../Times/EK/Eval-FDC.txt
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
