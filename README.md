# Cumulus Routing on the Host Demo

This demo installs Cumulus Linux [Hostpack](https://cumulusnetworks.com/products/host-pack/) on Ubuntu 16.04 servers in the Cumulus [reference topology](https://github.com/cumulusnetworks/cldemo-vagrant). Please visit the reference topology github page for detailed instructions on using Cumulus Vx with Vagrant.


![Cumulus Reference Topology](https://raw.githubusercontent.com/CumulusNetworks/cldemo-vagrant/master/documentation/cldemo_topology.png)


Table of Contents
=================
* [Prerequisites](#prerequisites)
* [Demo Quickstart](#demo-quickstart)
* [Demo Details](#demo-details)


Prerequisites
------------------------
* Internet connectivity is required from the hypervisor. Multiple packages are installed on the servers when the lab is created.
* Download this repository locally with `git clone https://github.com/CumulusNetworks/cldemo-roh-ansible.git` or if you do not have Git installed, [Download the zip file](https://github.com/CumulusNetworks/cldemo-roh-ansible/archive/master.zip)
* Install [Vagrant](https://releases.hashicorp.com/vagrant/). Use release [1.9.5](https://releases.hashicorp.com/vagrant/1.9.5/).
* Install [Virtualbox](https://www.virtualbox.org/wiki/VirtualBox) or [Libvirt+KVM](https://libvirt.org/drvqemu.html) hypervisors.


Demo Quickstart
------------------------
* `git clone https://github.com/CumulusNetworks/cldemo-vagrant`
* `cd cldemo-vagrant`
* `vagrant up oob-mgmt-server oob-mgmt-switch`
* `vagrant up` (bringing up the oob-mgmt-server and switch first prevent DHCP issues)
* `vagrant ssh oob-mgmt-server`
* `git clone https://github.com/CumulusNetworks/cldemo-roh-ansible`
* `ansible-playbook run-demo.yml`


Demo Details
------------------------
The network consists of 2 spines, 4 leafs and 4 Ubuntu 16.04 servers.  
All four of the servers have the Cumulus Linux FRR package for Routing on the Host installed on them. 

The servers are configured with eBGP unnumbered to their top of rack switch pair. There are no bonds in the environment. 

All network devices are also configured with eBGP unnumbered. 

All devices have a /32 loopback IP address that is advertised via BGP. 

On `server01` we can see two equal cost routes to the spines, remote leafs and servers

```
cumulus@server01:~$ ip route show
default via 192.168.0.254 dev eth0
10.0.0.11 via 169.254.0.1 dev eth1  proto 186  metric 20 onlink
10.0.0.12 via 169.254.0.1 dev eth2  proto 186  metric 20 onlink
10.0.0.13  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.14  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.21  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.22  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.32  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.33  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
10.0.0.34  proto 186  metric 20
    nexthop via 169.254.0.1  dev eth1 weight 1 onlink
    nexthop via 169.254.0.1  dev eth2 weight 1 onlink
192.168.0.0/24 dev eth0  proto kernel  scope link  src 192.168.0.31
```

Notice that `10.0.0.11` and `10.0.0.12` only have a single path, as they are the locally attached `leaf01` and `leaf02` respectively. 

On the servers you can access FRR via `vtysh`. BGP information can be seen with `show ip bgp`

```
cumulus@server01:~$ sudo vtysh

Hello, this is FRRouting (version 3.1+cl3u2).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

server01# show ip bgp sum

IPv4 Unicast Summary:
BGP router identifier 10.0.0.31, local AS number 65101 vrf-id 0
BGP table version 99
RIB entries 19, using 2736 bytes of memory
Peers 2, using 41 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS MsgRcvd MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd
leaf01(eth1)    4      65011    1144    1166        0    0    0 00:04:15            9
leaf02(eth2)    4      65012    1140    1176        0    0    0 00:04:15            9

Total number of neighbors 2
server01# show ip bgp
BGP table version is 99, local router ID is 10.0.0.31
Status codes: s suppressed, d damped, h history, * valid, > best, = multipath,
              i internal, r RIB-failure, S Stale, R Removed
Origin codes: i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*  10.0.0.11/32     eth2                                   0 65012 65020 65011 i
*>                  eth1                     0             0 65011 i
*> 10.0.0.12/32     eth2                     0             0 65012 i
*                   eth1                                   0 65011 65020 65012 i
*= 10.0.0.13/32     eth2                                   0 65012 65020 65013 i
*>                  eth1                                   0 65011 65020 65013 i
*= 10.0.0.14/32     eth2                                   0 65012 65020 65014 i
*>                  eth1                                   0 65011 65020 65014 i
*= 10.0.0.21/32     eth2                                   0 65012 65020 i
*>                  eth1                                   0 65011 65020 i
*= 10.0.0.22/32     eth2                                   0 65012 65020 i
*>                  eth1                                   0 65011 65020 i
*> 10.0.0.31/32     0.0.0.0                  0         32768 i
*= 10.0.0.32/32     eth2                                   0 65012 65102 i
*>                  eth1                                   0 65011 65102 i
*= 10.0.0.33/32     eth2                                   0 65012 65020 65013 65103 i
*>                  eth1                                   0 65011 65020 65013 65103 i
*= 10.0.0.34/32     eth2                                   0 65012 65020 65013 65104 i
*>                  eth1                                   0 65011 65020 65013 65104 i

Displayed  10 routes and 19 total paths
server01#
```

The exit, edge and internet devices are not used in this demo.

