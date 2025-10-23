#!/bin/bash

# files
mkdir -p /opt/spcli/log
cp spcli /opt/spcli/spcli 2>/dev/null
ln -T /opt/spcli/spcli /usr/local/sbin/spcli 2>/dev/null

# dependancies
dnf install -y mtools
dnf install -y net-tools
dnf install -y expect
dnf install -y lm_sensors

# permissions
usermod -aG libvirt $USER




