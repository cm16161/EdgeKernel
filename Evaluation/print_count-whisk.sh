#!/bin/bash

function getTime(){
    ts=$(date +%s%N)
    $1
    echo $((($(date +%s%N) - $ts)))
}

echo "This will test running a script within a script"

getTime "./get_value.sh usage_count"
