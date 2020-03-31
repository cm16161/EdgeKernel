## Sofware Requirements

The following software is needed

``` bash
mirage --version
v3.7.6
$ opam --version
2.0.4

$ ocaml --version 
The OCaml toplevel, version 4.10.0

```


## Redis Configuration

By default, the `redis-server` is configured to only listen on the `lo` network.
To change this add/amend the following lines in `/etc/redis/redis.conf`:

Add:
```
bind 127.0.0.1 192.168.x.x
```
Where `192.168.x.x` is your IP address
You can find this like so: 
```bash
$ ifconfig
...
inet 192.168.x.x
...
```

You will also need to amend the following line:

```
bind 127.0.0.1 ::1
```
By commenting it out so it looks like this

```
# bind 127.0.0.1 ::1
```

Finally you will need to start the redis server with this change
To do this first find out where the executable for the redis-server is like so:

```bash
$ whereis redis-server
```

Once you have this location (for me it was in `/usr/bin`) enter the following:

```bash
$ sudo /usr/bin/redis-server /etc/redis/redis.conf
```


## Network Configuration

To run multiple networking Unikernels on Solo5, the following commands need to be executed:

``` bash
sudo su

# This step creates a bridge device that all network interfaces will communicate through
brctl addbr br0
ip addr add 10.0.0.1/24 dev br0 
ip link set dev br0 up 

# Set up the network devices for the Unikernels and add them to the bridge

ip tuntap add tap10002 mode tap
ip link set dev tap10002 up
brctl addif br0 tap10002

ip tuntap add tap10003 mode tap
ip link set dev tap10003 up
brctl addif br0 tap10003

# Do this for as many concurrent Solo5 Unikernels as you want

```

Alternatively, you can execute (as root) the `network_configuration.sh` script to setup 10 devices.

To execute the Unikernels on Solo5, they need to be executed like so:

``` bash
solo5-hvt --net:service=tap1000N -- my-unikernel-executable.hvt --ipv4=10.0.0.N/24 --ipv4-gateway=10.0.0.1

```


https://www.revsys.com/writings/quicktips/nat.html

It is essential to configure the system to allow any VM to access the outside world
This can be accomplished using the following commands

``` bash
$ sudo su
$ echo 1 > /proc/sys/net/ipv4/ip_forward # enables IP forwarding

# assuming "wlp59s0" is your default network interface where all the traffic goes to the Internet.
$ /sbin/iptables -t nat -A POSTROUTING -o wlp59s0 -j MASQUERADE
$ /sbin/iptables -A FORWARD -i wlp59s0 -o tap100 -m state --state RELATED,ESTABLISHED -j ACCEPT
$ /sbin/iptables -A FORWARD -i tap100 -o wlp59s0 -j ACCEPT

```
