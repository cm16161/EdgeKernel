#!/bin/bash

rm cpu.txt

while [ true ]
do
    mpstat >> cpu.txt
    echo "-------------------" >> cpu.txt
    echo "Active Unikernels" >> cpu.txt
    ip a show | awk '/master br0/' | grep -c "state UP" >> cpu.txt
    echo "###################" >> cpu.txt
    sleep 1
done

