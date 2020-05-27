# Installation

Debian install scripts are provided to install EdgeKernel

Start by running the `install.sh` script to install all of the debian dependencies and git modules

Next, download and install `opam` using the `download-opam.sh` script.

Once downloaded, configure and install the `mirage` program by running the `install-mirage.sh` script.

Finally, configure the network by modifying `Line 17` and running the `network_configuration.sh` script as `root`.
This needs to be configured to use your networking device. For PC's this will typically use the `eth0` interface and the `wlp59s0` interface for laptops. This can be found by running `ifconfig` and finding your `inet` which starts with `192.168..`.

Once you know what your private IP address is, configure `Line 12` in the `server/EdgeKernel.rb` so that EdgeKernel knows where to access Redis. 

Additionally, this change is required on `Line 9` on in the `Kernels/MirageOS/EdgeKernelAPI.ml` file.


EdgeKernel can be found in the `server/` directory.
Run EdgeKernel with `sudo ruby EdgeKernel.rb`

# Videos

A video presentation of EdgeKernel can be found here: [https://youtu.be/neguWBuOzgY](https://youtu.be/neguWBuOzgY)
A technical demonstration can be found here: [https://youtu.be/P9SZiQzDopU](https://youtu.be/P9SZiQzDopU)

