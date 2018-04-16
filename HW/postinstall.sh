# This script is a short setup script for our
# firstboot config. This script isn't complicated,
# don't try to modify it, you will break things.

hwch=$(cat /usr/nhscs/hwch.check)
if [[ $hwch = "1" ]];
  then
    exit
  else
    :
fi
curl -k https://github.com/NHSCS-ORG/Post-Install-Config/archive/master.zip /usr/nhscs/postinstall.zip
unzip /usr/nhscs/postinstall.zip
cp /usr/nhscs/master
