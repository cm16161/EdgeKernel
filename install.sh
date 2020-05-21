#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi


sudo apt-get install -y libevent-dev ocaml redis libseccomp-dev ruby qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils gcc m4 pkg-config make ruby-dev net-tools curl
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

sudo gem install json
sudo gem install redis
sudo gem install redis-queue

git submodule update --init
cd webdis
make clean all
nohup ./webdis& > /dev/null

cd ..
cd vmtouch
make
sudo -u $USER  make install

cd
git clone https://www.github.com/Solo5/solo5.git
cd solo5
./configure.sh
make
sudo -u $USER  cp tenders/hvt/solo5-hvt /usr/bin/
cd

# adduser ${SUDO_USER:-${USER}} kvm
# chown ${SUDO_USER:-${USER}} /dev/kvm

# brctl addbr br0
# ip addr add 10.0.0.1/24 dev br0 
# ip link set dev br0 up 

# for NUMBER in {2..11}
# do
#     ip tuntap add tap1000$NUMBER mode tap
#     ip link set dev tap1000$NUMBER up
#     brctl addif br0 tap1000$NUMBER
# done


# let DEVICE=wlp59s0

# /sbin/iptables -t nat -A POSTROUTING -o $DEVICE -j MASQUERADE
# /sbin/iptables -A FORWARD -i $DEVICE -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# /sbin/iptables -A FORWARD -i br0 -o $DEVICE -j ACCEPT


