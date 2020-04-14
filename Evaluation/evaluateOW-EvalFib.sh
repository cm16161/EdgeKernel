#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/OW-Times
}

for j in {1..10}
do
    for i in {1..10}
    do
	echo "Starting Run $j:$i"
	./OW-EvalFib.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
   
    done
done
