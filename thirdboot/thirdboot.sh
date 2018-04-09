#!/bin/bash
# Let's finish configuring this system, and get it set up.

# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/thirdboot/

# First let's check if this is firstboot, secondboot, or thirdboot.
fbp1=$(cat /etc/nhscs/config/checks/fbp1.check)
if [ $fbp1 = "1" ];
  then
    :
  else
    exit
fi
#
fbp2=$(cat /etc/nhscs/config/checks/fbp2.check)
if [ $fbp2 = "1" ];
  then
    :
  else
    exit
fi
fbp3=$(cat /etc/nhscs/config/checks/fbp3.check)
if [ $fbp3 = "1" ];
  then
    exit
  else
    :
fi
apt update
apt dist-upgrade -y
apt autoremove -y
apt install open-vm-tools-desktop oem-config -y
oem-config-prepare

# Note that we've run deploy part 3.
echo 1 > /etc/nhscs/config/checks/fbp3.check
