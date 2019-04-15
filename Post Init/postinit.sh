# This script calls for our post install script,
# sets it up, and the reboots.

# Check if this is an installer or not.
# This detection checks if an installer is running, and is OS dependent.
liveboot=$(pgrep ubiquity)
if [[ ! $liveboot = "" ]];
  then
    exit
  else
    :
fi

## <PER OS Detection will go here when we figure that out>

# Because this is our post init, we need to create all of our files.
if [[ ! -d "/usr/nhscs/" ]]; then
  mkdir /usr/nhscs/
fi
# Check if this is actually post init.
touch /usr/nhscs/pinit.check
pinit=$(cat /usr/nhscs/pinit.check)
if [[ $pinit = "1" ]];
  then
    exit
  else
    :
fi

# Pull post install script
apt update
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/HW/postinstall.sh -o /usr/nhscs/postinstall.sh
chmod +x /usr/nhscs/postinstall.sh
#Pull post install service
curl -k https://raw.githubusercontent.com/NHSCS-ORG/Post-Install-Config/master/HW/hw.service -o /etc/systemd/system/hw.service
sleep 2
systemctl enable hw.service
# Notify the desktop that install is running.
zenity --progress --no-cancel --text="Install in progress, please wait!" --title="NHSCS MAAS Linux Post Install System" --width=300 --window-icon=info
sleep 5

# Note that postinit finished.
logger "WE ARE NHSCS"
logger "[postinit.sh] Post init finished, rebooting to HWCH."
echo 1 > /usr/nhscs/pinit.check

# Reboot to HWCH.
reboot now
