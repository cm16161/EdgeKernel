# Installation

EdgeKernel utilises [MirageOS](https://mirage.io/) UniKernels and [Solo5](https://github.com/Solo5/solo5) as a execution environment.

## MirageOS Installation

Please follow [MirageOS Installation](https://mirage.io/wiki/install) to install opam, mirage.

## Solo5 Installation

Please follow [Building Solo5](https://github.com/Solo5/solo5/blob/master/docs/building.md#building-solo5) to install solo5.

As we are using Solo5-hvt (Hardware Virtualised Tender), copy `solo5-hvt` to `/usr/bin`

```
sudo -u $USER  cp tenders/hvt/solo5-hvt /usr/bin/
```

## EdgeKernel Requirements

Install the below packages

```
apt-get install -y libevent-dev ocaml redis libseccomp-dev ruby qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils gcc m4 pkg-config make ruby-dev net-tools curl
```

Install the below gems

```
gem install json
gem install redis
gem install redis-queue
gem install usagewatch_ext
```

### Git-clone EdgeKernel

```
git clone https://github.com/cm16161/EdgeKernel.git
```

### Run WebDis
```
git submodule update --init
cd webdis
make clean all
nohup ./webdis& > /dev/null
```

### Install VMTouch
```
cd ..
cd vmtouch
make
sudo -u $USER  make install
```

## Network Setup

Finally, configure the network by modifying `Line 17` and running the `network_configuration.sh` script as `root`.
This needs to be configured to use your networking device. For PC's this will typically use the `eth0` interface and the `wlp59s0` interface for laptops. This can be found by running `ifconfig` and finding your `inet` which starts with `192.168..`.

Once you know what your private IP address is, configure `Line 12` in the `server/EdgeKernel.rb` so that EdgeKernel knows where to access Redis. 

Additionally, this change is required on `Line 9` on in the `Kernels/MirageOS/EdgeKernelAPI.ml` file.

## Start EdgeKernel

EdgeKernel can be found in the `server/` directory.

Run EdgeKernel with 

```shell
sudo ruby EdgeKernel.rb`
```

# Videos

A video presentation of EdgeKernel can be found here: [https://youtu.be/neguWBuOzgY](https://youtu.be/neguWBuOzgY)

A technical demonstration can be found here: [https://youtu.be/P9SZiQzDopU](https://youtu.be/P9SZiQzDopU)

## Run Evaluation Experiments

Add How to replicate the experiments :)
