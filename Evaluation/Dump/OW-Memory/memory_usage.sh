#!/bin/bash

    for i in {1..250}
    do
	# ts=$(date +%s%N)
	a=$(../get_value.sh usage_count)
	b=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/fdc?count=$a) &
	pid=$!
	echo "$(ps -o rss= -p $pid),$i" >> ow-memory.csv
	../set_value.sh test $b > /dev/null
	# let finished=$((($(date +%s%N) - $ts)))
	# echo $finished ns
	# echo $(($finished/1000000))
    done
