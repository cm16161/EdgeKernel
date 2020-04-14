#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/EK-Times
}

for j in {1..10}
do
    for i in {1..10}
    do
	echo "Starting Run $j:$i"
	./EK-EvalA.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
