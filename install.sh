#!/bin/bash

# files
mkdir -p /opt/spcli/log
cp spcli /opt/spcli/spcli 2>/dev/null
rm /usr/local/sbin/spcli
ln -s /opt/spcli/spcli /usr/sbin/spcli 
touch /opt/spcli/log/history
touch /opt/spcli/log/system_console

# permissions
chown -R :libvirt /opt/spcli
chmod g+rws /opt/spcli/
chmod g+rws /opt/spcli/log
chmod g+rw /opt/spcli/log/history
chmod g+rw /opt/spcli/log/system_console

# tools
dnf install -y perl-XML-XPath
dnf install -y mtools
dnf install -y net-tools
dnf install -y expect
dnf install -y lm_sensors

# probably not working
usermod -aG libvirt $USER
newgrp libvirt
