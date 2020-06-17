#!/bin/bash

cd ../server

for j in {1..10}
do
    for i in {1..1}
    do
	# echo "Starting Run $j:$i" 
	redis-cli lpush print_count_trigger 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 >/dev/null
	# ./EK-EvalA.sh
	# echo_to_file ""
	# echo_to_file "#################"
	# echo_to_file ""
    
    done
done
