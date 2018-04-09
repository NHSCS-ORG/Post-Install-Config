#!/bin/bash
# Let's configure this system, and get it set up.

# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/secondboot/

# The $hid varable is defined based on the UUID that MAAS gives to the system,
# you shouldn't change it as we're relying on the idea of the script creating a system name.
# The script creates the machine's name by grabbing the date and the UUID, smashing them together,
# and cutting it down to 14 characters.

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
    exit
  else
    :
fi
fbp3=$(cat /etc/nhscs/config/checks/fbp3.check)
if [ $fbp3 = "1" ];
  then
    exit
  else
    :
fi

# Join the machine to AD using our AD join account.
# Setup the hostname.
idp1=$(date | cut -c 12- | sed 's/ //g' | tr -d ':')
idp2=$(hostid)
hid=$(echo $idp1 $idp2 | sed 's/ //g' | cut -c -14)
# Pull the password from the server. (So that we don't publish it to github.)
djpass=$(curl -k http://eh4-nhscs-ms01.maas.nhscs.net:5499/)
# Install realmd so that we can bind.
apt update
apt install realmd
# Bind to the domain.
realm join maas.nhscs.net --user=maas_dj --os-name="Ubuntu 18.04 LTS Bionic Beaver" --os-version="MAAS Deployed PXE Image" --computer-name=$hid --one-time-password=$djpass

# Note that we've run deploy part 2.
echo 1 > /etc/nhscs/config/checks/fbp2.check
