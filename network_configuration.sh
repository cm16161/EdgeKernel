#!/bin/bash

adduser ${SUDO_USER:-${USER}} kvm
chown ${SUDO_USER:-${USER}} /dev/kvm

brctl addbr br0
ip addr add 10.0.0.1/24 dev br0 
ip link set dev br0 up 

for NUMBER in {2..51}
do
    ip tuntap add tap1000$NUMBER mode tap
    ip link set dev tap1000$NUMBER up
    brctl addif br0 tap1000$NUMBER
done

let DEVICE=virbr0

/sbin/iptables -t nat -A POSTROUTING -o $DEVICE -j MASQUERADE
/sbin/iptables -A FORWARD -i $DEVICE -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i br0 -o $DEVICE -j ACCEPT
