# This script updates the conf files on every reboot in the event an update broke something.

# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/everyboot/

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
    :
  else
    exit
fi
# Configure pam.d so we can login and create home dirs.
cp /etc/nhscs/config/files/pam.d/common-session /etc/pam.d/common-session
# Configure sudo so that we can be root when req.
cp /etc/nhscs/config/files/sudoers/01domain /etc/sudoers.d/01domain

# Log conf file updates.
logger "WE ARE NHSCS"
logger "[updateconf.sh] Conf files updated at boot successfully."
