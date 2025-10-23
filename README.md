# spcli
An SP CLI for ONTAP Select on KVM

To install:
  sudo ./install.sh 

for an interactive shell:
  spcli

to run a command noninteractively:
  spcli <command>

Note:
To allow a non-root user to use spcli, add them to the libvirt group first:
  sudo usermod -aG libvirt $USER
  newgrp libvirt

