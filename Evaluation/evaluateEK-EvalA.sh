#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/EK-Times
}


for i in {1..10}
do
    echo_to_file "#################"
    ./solo5-time-test.sh
    echo_to_file ""
    echo_to_file "#################"
    echo_to_file ""
    
done
