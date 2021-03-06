# Let's configure this system, and get it set up.

# Note: This script is called by systemd, do not try to run this by your self.
# This script should be placed in: /etc/nhscs/config/deploy/secondboot/

# The $hid varable is defined based on the UUID that MAAS gives to the system,
# you shouldn't change it as we're relying on the idea of the script creating a system name.
# The script creates the machine's name by grabbing the date and the UUID, smashing them together,
# and cutting it down to 14 characters.

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
    exit
  else
    :
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

# Join the machine to AD using our AD join account.
# Setup the hostname.
chid=$(cat /etc/hostname)
idp1=$(date | cut -c 12- | sed 's/ //g' | tr -d ':')
idp2=$(hostid)
nhid=$(echo $idp1 $idp2 | sed 's/ //g' | cut -c -14)
sed -i "s/$chid/$nhid/g" /etc/hosts
sed -i "s/$chid/$nhid/g" /etc/hostname
# Pull the password from the server. (So that we don't publish it to github.)
# djpass=$(curl -k <passwd server here>/djpass.txt) (Testing in progress, ignoring web call)
djpass=$(echo "mass_dj")
# Install realmd so that we can bind.
apt update
apt install realmd
# Bind to the domain.
realm join maas.nhscs.net --user=maas_dj --os-name="Ubuntu 18.04 LTS Bionic Beaver" --os-version="MAAS Deployed PXE Image" --computer-name=$nhid --one-time-password=$djpass
# Configure Domain Prvileges
realm deny --all
realm permit -g 'Domain Admins' 'Ubuntu Operators' 'Ubuntu Admins'
# Configure sudo so that we can be root when req.
cp /etc/nhscs/config/files/sudoers/01domain /etc/sudoers.d/01domain

# Note that we've run deploy part 2.
logger "WE ARE NHSCS"
logger "[secondboot.sh] Secondboot completed, rebooting to thirdboot."
echo 1 > /etc/nhscs/config/checks/fbp2.check

# Reboot for config #3.
reboot now
