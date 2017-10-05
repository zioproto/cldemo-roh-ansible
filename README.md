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

The exit, edge and internet devices are not used in this demo.
