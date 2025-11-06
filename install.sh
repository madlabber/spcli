#!/bin/bash

# tools
echo "SPCLI Installer: Installing dependencies"
dnf install -y perl-XML-XPath mtools net-tools expect lm_sensors

# files
echo "SPCLI Installer: Copying Files"
mkdir -p /opt/spcli/log
if [ "$(which spcli 2>/dev/null)" != "" ];then rm "$(which spcli)";fi
cp spcli /opt/spcli/spcli 2>/dev/null
ln -s /opt/spcli/spcli /usr/sbin/spcli 
touch /opt/spcli/log/history
touch /opt/spcli/log/system_console

# permissions
echo "SPCLI Installer: Setting permissions"
groupadd --system libvirt 2>/dev/null
usermod -aG libvirt $USER
chown -R :libvirt /opt/spcli
chmod g+rws /opt/spcli/
chmod g+rws /opt/spcli/log
chmod g+rw /opt/spcli/log/history
chmod g+rw /opt/spcli/log/system_console

# done
echo "SPCLI Installer: Done!"