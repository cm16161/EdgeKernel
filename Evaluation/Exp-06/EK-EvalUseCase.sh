#!/bin/bash

cd ../../server

for i in {1..10}
do
    redis-cli lpush sensor_data 24.45 41.86 100 299 53.56 101.58 306.0 1668.0 12 18 18 >/dev/null
    ruby server.rb
done
