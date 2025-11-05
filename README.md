# spcli
A Service-Processor-like CLI for ONTAP Select on KVM

### About
SPCLI implements much of the Service Processor Command Line Interface for an ONTAP Select kvm host.  SPCLI can be run as a command or as an interactive shell.  SPCLI can also be used to prepare a linux host for an ONTAP Select deployment.  



To install:

    sudo git clone https://github.com/madlabber/spcli.git
    sudo /opt/spcli/install.sh 

for an interactive shell:

    sudo spcli

to run a command noninteractively:

    sudo spcli <command>

Note:
To allow a non-root user to use spcli, add them to the libvirt group first:

    sudo usermod -aG libvirt $USER
    newgrp libvirt

Some functions still require sudo or root group membership.

### Preparing a host with SPCLI
Invoke the host setup process:

    sudo spcli host setup

Then follow the prompts to install and configure host software packages, storage pool creation, and configure host networking.

