#!/bin/bash

function getTime(){
    ts=$(date +%s%N)
    $1
    echo $((($(date +%s%N) - $ts)))
}

a=$(curl -sk https://172.17.0.1/api/v1/web/guest/default/increment?count=$1)
echo $a
