#!/bin/bash

function getTime(){
    ts=$(date +%s%N)
    $1
    echo $((($(date +%s%N) - $ts)))
}

# echo "This is a test Script to SET a value from a local Redis Store"
if ( [ ! -z $1 ] && [ ! -z $2 ] )
then
    # echo "SET $1 to $2"
    # getTime "redis-cli SET $1 $2"
    redis-cli SET $1 $2
else
    echo "No Key or Value to set"
    echo "Exiting"
fi
