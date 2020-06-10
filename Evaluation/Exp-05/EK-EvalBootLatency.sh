#!/bin/bash

cd ../../server

for i in {1..50}
do
	redis-cli lpush time-test $( date +%s%N )
	sleep 1
    
done
