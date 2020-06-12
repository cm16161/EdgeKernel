#!/bin/bash

for f in */
do
    ln -s $(pwd)/EdgeKernelAPI.ml $f
done

ln -s $(pwd)/EdgeKernelAPI.ml evaluation_test_dhs/increment_day_count
ln -s $(pwd)/EdgeKernelAPI.ml evaluation_test_dhs/calculate_averages

