#!/bin/bash

echo "Getting Warm Times"

for i in {1..51}
do
    echo "$i/51"
    wsk -i action invoke --result time -p initial $( date +%s%N ) | grep "body" >> warm.log
done

echo "Starting Cold Times"

for i in {1..50}
do
    echo "$i/50"
    wsk -i action invoke --result time -p initial $( date +%s%N ) | grep "body" >> cold.log
    sleep 5
done

