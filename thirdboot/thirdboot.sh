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

# Notify the desktop that install is running.
zenity --progress --no-cancel --text="Install in progress, please wait!" --title="NHSCS MAAS Linux Post Install System" --width=300 --window-icon=info

# Disable auto login of the default ubuntu user.
cp /etc/nhscs/config/files/gdm3/custom.conf /etc/gdm3/custom.conf
# Update the system and install our packages.
apt update
apt dist-upgrade -y
apt autoremove -y
apt install open-vm-tools-desktop -y
# Configure GDM to our liking
cp /etc/nhscs/config/files/dconf/gdm /etc/dconf/profile/gdm
mkdir /etc/dconf/db/gdm.d
cp /etc/nhscs/config/files/dconf/00-logo /etc/dconf/db/gdm.d/00-logo
cp /etc/nhscs/config/files/dconf/01-hide-user /etc/dconf/db/gdm.d/01-hide-user
cp /etc/nhscs/config/files/dconf/02-banner-message /etc/dconf/db/gdm.d/02-banner-message
dconf update
rm -rf /etc/gdm3/custom.conf
cp /etc/nhscs/config/files/gdm3/custom.conf /etc/gdm3/custom.conf
# Configure pam.d so we can login and create home dirs.
cp /etc/nhscs/config/files/pam.d/common-session /etc/pam.d/common-session

# Cleanup Phaze
# Remove startup scripts
systemctl disable hw.service
systemctl disable postinit.service
systemctl disable firsboot.service
systemctl disable secondboot.service
systemctl disable thirdboot.service
# Remove service files
rm -rf /etc/systemd/system/firstboot.service
rm -rf /etc/systemd/system/secondboot.service
rm -rf /etc/systemd/system/thirdboot.service
rm -rf /etc/systemd/system/hw.service
rm -rf /etc/systemd/system/postinit.service

# Remove existing user account and create new local admin
userdel ubuntu
useradd -m -s /bin/bash maas-lca
usermod -a -G sudo maas-lca
# Update new local admin password
# passvar=$(curl -k /dailypass.txt) (Testing in progress, ignoring web call.)
passvar=$(echo "maas-lca")
echo -e "$passvar\n$passvar" | passwd maas-lca

# Note that we've run deploy part 3.
logger "WE ARE NHSCS"
logger "[thirdboot.sh] Thirdboot completed, rebooting to ready."
echo 1 > /etc/nhscs/config/checks/fbp3.check

# Reboot to apply final config.
reboot now
