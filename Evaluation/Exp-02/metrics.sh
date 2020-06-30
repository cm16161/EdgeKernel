#!/bin/bash

while [ true ]
do
    date +"%F %X %::z" >> memory.txt
    free -m >> memory.txt
    # mpstat >> cpu.txt
    sleep 1
done

