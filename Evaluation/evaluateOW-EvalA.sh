#!/bin/bash

function echo_to_file(){
    echo $1 >> Times/OW-Times
}


for i in {1..10}
do
    echo_to_file "#################"
    ./chain.sh
    echo_to_file ""
    echo_to_file "#################"
    echo_to_file ""
    
done
