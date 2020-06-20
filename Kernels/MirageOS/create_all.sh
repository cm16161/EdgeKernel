#!/bin/bash

c=$(pwd) 

./link_api.sh

for file in */
do
    cd $file
    mirage configure -t hvt
    mirage build
    cd $c
done

cd evaluation_test_dhs
for file in */
do
    cd $file
    mirage configure -t hvt
    mirage build
    cd ..
done
