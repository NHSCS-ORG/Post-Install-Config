# Let's finish configuring this system, and get it set up.

# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/thirdboot/

# First let's check if this is firstboot, secondboot, or thirdboot.
fbp1=$(cat /etc/nhscs/config/checks/fbp1.check)
if [[ $fbp1 = "1" ]];
  then
    :
  else
    exit
fi
fbp2=$(cat /etc/nhscs/config/checks/fbp2.check)
if [[ $fbp2 = "1" ]];
  then
    :
  else
    exit
fi
fbp3=$(cat /etc/nhscs/config/checks/fbp3.check)
if [[ $fbp3 = "1" ]];
  then
    exit
  else
    :
fi
# Update the system and install our packages.
apt update
apt dist-upgrade -y
apt autoremove -y
apt install open-vm-tools -y
cp /etc/nhscs/config/files/dconf/gdm /etc/dconf/profile/gdm
mkdir /etc/dconf/db/gdm.d
cp /etc/nhscs/config/files/dconf/00-logo /etc/dconf/db/gdm.d/00-logo
cp /etc/nhscs/config/files/dconf/01-hide-user /etc/dconf/db/gdm.d/01-hide-user
cp /etc/nhscs/config/files/dconf/02-banner-message /etc/dconf/db/gdm.d/02-banner-message
dconf update

# Cleanup Phaze
# Remove startup scripts
systemctl disable hw.service
systemctl disable postinit.service
systemctl disable firsboot.service
systemctl disable secondboot.service
systemctl disable thirdboot.service
systemctl daemon-reload

# Note that we've run deploy part 3.
logger "WE ARE NHSCS"
logger "[thirdboot.sh] Thirdboot completed, rebooting to ready."
echo 1 > /etc/nhscs/config/checks/fbp3.check

# Reboot to apply final config.
reboot now
