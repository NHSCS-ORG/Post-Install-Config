# This script is a short setup script for our
# firstboot config. This script isn't complicated,
# don't try to modify it, you will break things.

# Check if we are now post install boot.
hwch=$(cat /etc/nhscs/config/checks/hwch.check)
if [[ $hwch = "1" ]];
  then
    exit
  else
    :
fi
apt update
apt install curl

# Create base dirs.
mkdir /etc/nhscs
mkdir /etc/nhscs/config
mkdir /etc/nhscs/config/deploy

# Pull Firstboot
# Pull script
mkdir /etc/nhscs/config/deploy/firstboot
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/firstboot/firstboot.sh -o /etc/nhscs/config/deploy/firstboot/firstboot.sh
chmod +x /etc/nhscs/config/deploy/firstboot/firstboot.sh
# Pull service
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/firstboot/firstboot.service -o /etc/systemd/system/firstboot.service
systemctl daemon-reload
systemctl enable firstboot.service

# Pull Secondboot
# Pull script
mkdir /etc/nhscs/config/deploy/secondboot
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/secondboot/secondboot.sh -o /etc/nhscs/config/deploy/secondboot/secondboot.sh
chmod +x /etc/nhscs/config/deploy/secondboot/secondboot.sh
# Pull service
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/secondboot/secondboot.service -o /etc/systemd/system/secondboot.service
systemctl daemon-reload
systemctl enable secondboot.service

# Pull Thirdboot
mkdir /etc/nhscs/config/deploy/thirdboot
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/thirdboot/thirdboot.sh -o /etc/nhscs/config/deploy/thirdboot/thirdboot.sh
chmod +x /etc/nhscs/config/deploy/thirdboot/thirdboot.sh
# Pull service
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/thirdboot/thirdboot.service -o /etc/systemd/system/thirdboot.service
systectl daemon-reload
systemctl enable thirdboot.service

# Create Check Files
mkdir /etc/nhscs/config/checks
touch /etc/nhscs/config/checks/fbp1.check
touch /etc/nhscs/config/checks/fbp2.check
touch /etc/nhscs/config/checks/fbp2.check
touch /etc/nhscs/config/checks/hwch.check

# Create conf dirs
mkdir /etc/nhscs/config/files

# Pull sudoers config
mkdir /etc/nhscs/config/files/sudoers
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/sudoers/sudoers -o /etc/nhscs/config/files/sudoers/sudoers

# Pull pam.d config
mkdir /etc/nhscs/config/files/pam.d
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/pam.d/common-session -o /etc/nhscs/config/files/pam.d/common-session

# Pull dconf config
mkdir /etc/nhscs/config/dconf
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/dconf/00-logo -o /etc/nhscs/config/files/dconf/00-logo
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/dconf/01-hide-user -o /etc/nhscs/config/files/dconf/01-hide-user
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/dconf/02-banner-message -o /etc/nhscs/config/files/dconf/02-banner-message
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/Config%20Files/dconf/gdm -o /etc/nhscs/config/files/dconf/gdm

# Note that we've run HWCH.
logger "WE ARE NHSCS"
echo 1 > /etc/nhscs/config/checks/hwch.check

# Reboot for config.
reboot now
