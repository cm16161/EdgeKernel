#!/bin/bash

rm memory.txt

while [ true ]
do
    date +"%F %X %::z" >> memory.txt
    free -m >> memory.txt
    echo "-------------------" >> memory.txt
    echo "Active Unikernels" >> memory.txt
    ip a show | awk '/master br0/' | grep -c "state UP" >> memory.txt
    echo "###################" >> memory.txt
    sleep 1
done

