#!/bin/bash
# Let's finish configuring this system, and get it set up.
# First let's check if this is firstboot or secondboot.
fbp1=$(cat /etc/nhscs/config/checks/fbp1.check)
if [ $fbp1 = "1" ];
  then
    :
  else
    exit
fi
apt update
apt dist-upgrade -y
apt autoremove -y
apt install open-vm-tools-desktop oem-config -y
oem-config-prepare
