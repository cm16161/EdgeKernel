#!/bin/bash

brctl addbr br0
ip addr add 10.0.0.1/24 dev br0 
ip link set dev br0 up 

for NUMBER in {2..10}
do
    ip tuntap add tap1000$NUMBER mode tap
    ip link set dev tap1000$NUMBER up
    brctl addif br0 tap1000$NUMBER
done
