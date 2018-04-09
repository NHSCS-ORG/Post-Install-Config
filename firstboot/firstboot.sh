#!/bin/bash
# MAAS Config Script for Firstboot - DR#-
# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/firstboot/
# The $hid varable is defined based on the UUID that MAAS gives to the system,
# you shouldn't change it as we're relying on the idea of the script creating a system name.
# The script creates the machine's name by grabbing the date and the UUID, smashing them together,
# and cutting it down to 14 characters.

# First let's check if this is firstboot or secondboot.
fbp1=$(cat /etc/nhscs/config/checks/fbp1.check)
if [ $fbp1 = "1" ];
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

# Update the apt list to use our cache.
echo 'Acquire::http::Proxy "http://EH3-NHSCS-UUC01.ad.nhscs.net:3142";' >> /etc/apt/apt.conf.d/01proxy

# Add TelaForce's certs.
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Ubuntu-Kickstart/master/Firewall_Certificate.cer -o /usr/share/ca-certificates/tf-firewall.crt
update-ca-certificates

# Note that we've run deploy part 1.
echo 1 > /etc/nhscs/config/checks/fbp1.check
