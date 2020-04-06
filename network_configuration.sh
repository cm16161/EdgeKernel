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

/sbin/iptables -t nat -A POSTROUTING -o wlp59s0 -j MASQUERADE
/sbin/iptables -A FORWARD -i wlp59s0 -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i br0 -o wlp59s0 -j ACCEPT
