#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi


sudo apt-get install -y libevent-dev ocaml redis libseccomp-dev ruby qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils gcc m4 pkg-config make ruby-dev net-tools curl


sudo gem install json
sudo gem install redis
sudo gem install redis-queue
sudo gem install usagewatch_ext

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




