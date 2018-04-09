#!/bin/bash
# MAAS Config Script for Firstboot - DR#-
# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/firstboot/

# First let's check if this is firstboot, secondboot, or thirdboot.
fbp1=$(cat /etc/nhscs/config/checks/fbp1.check)
if [ $fbp1 = "1" ];
  then
    exit
  else
    :
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

# Update the apt list to use our cache.
echo 'Acquire::http::Proxy "http://EH3-NHSCS-UUC01.ad.nhscs.net:3142";' >> /etc/apt/apt.conf.d/01proxy

# Add our NTP server so that realmd doesn't loose it's mind.
rm -rf /etc/ntp.conf
echo eh4-nhscs-msad01.maas.nhscs.net > /etc/ntp.conf
ntpupdate eh4-nhscs-msad01.maas.nhscs.new
systemctl enable ntp
systemctl start ntp


# Add TelaForce's certs.
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Ubuntu-Kickstart/master/Firewall_Certificate.cer -o /usr/share/ca-certificates/tf-firewall.crt
update-ca-certificates

# Note that we've run deploy part 1.
echo 1 > /etc/nhscs/config/checks/fbp1.check

# Reboot for config #2
reboot now
