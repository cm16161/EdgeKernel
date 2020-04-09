#!/bin/bash

# function getTime(){
#     ts=$(date +%s%N)
#     $1
#     echo $((($(date +%s%N) - $ts)))
# }

# echo "This is a test Script to GET a value from a local Redis Store"
if [ ! -z $1 ]
then
    # echo "GET $1"
    # getTime "redis-cli GET $1"
    redis-cli GET $1
    
else
    echo "No Key to lookup"
    echo "Exiting"
fi
