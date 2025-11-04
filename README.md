# spcli
An SP CLI for ONTAP Select on KVM

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
