# Post-Install-Config
Configure an deployed with [MaaS](https://maas.io/) to NHSCS spec for edu use. 
## WARNING: Do not use this script without modifing it for your environment, it is hard coded for NHSCS and WILL FAIL without modification.

### What this system does:
We use a combonation of Systemd and MaaS to build out our deployment.
#### Configuration
* Enable Active Directory Authentication.
* Add the system to a ADDS domain.
* Define NTP server for ADDS use. (To stop time drift from breaking ADDS).
* Pull the ADDS join password from a webserver so that it isn't on GitHub.
* Configure sudoers to respect ADDS rights. (Sudo for users without endangering the system.)
* Configure pam.d to respect ADDS rights.
* Configure pam.d to allow ADDS users to create home directories.
* Add a service to run scripts to confirm the configuration of pam.d, realmd, systemd, and ADDS at boottime (to prevent an update from breaking ADDS).

#### Customisation
* Configure local apt-cache location.
* Configure GDM3 to disable auto login.
* Configure GDM3 to request a username for login.
* Configure GDM3 login branding.
* Automatically define hostname based on time/random var.
* Generate and Pull a password from a webserver so that root isn't accessable.

### Steps Breakdown
This is a breakdown of how the config should apply, please note that the scripts are coded for an existing environment and may fail if they are run without modification. Please head the warning at the top of this page.

#### At Install Time
*Note: postinit.service, and postinit.sh must be included in your installer image for any of this to work. I'd recomend [Cubic](https://launchpad.net/cubic) to modify the stock ubuntu installer. You must follow or modify the path provided by postinit.service.*
#### Installer
At install time no configuration will occur, but postinit.sh will run. The first part of postinit.sh checks to determine if the script is running in an installer or not, and will not continue in an installer, but will exit cleanly. If you get an error durring install check and make sure that postinit.service is activated, and that the files have correct unix syntax. 
* Use cat to verify: ``` cat --vet ./<filepath.sh>```
---
#### Firstboot after Install
MaaS installs are automatically configured with a live user, so we don't need to worry about logging in, yet. Systemd starts our service before the Xserver, so depending on the speed of your system you may not see the desktop before a reboot is triggered. This is normal.
Here are the steps that postinit.sh completes:
* Contacts Github without certificate verification and pulls [postinstall.sh](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/HW/postinstall.sh)
* Contacts Github without certificate verification and pulls [hw.service](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/HW/hw.service)
* Enables hw.service so on next boot configuration continues.
* Log to the system that postinit.sh has completed
* Writes  ```pinit.check``` with a 1 so that when postinstall.sh runs it can determine the system's current deployment status.
---
#### HW Boot
This part of configuration is called HW (short for hello world), we do not consider the system live untill this step has completed, hence why the section after this is called "Firstboot".
Here are the steps that postinstall.sh completes:
##### Part One
* Creates base deployment dirs in ```/etc/nhscs, /etc/nhscs/config, and /etc/nhscs/config/deploy```
* Creates storage dir for step 1: ```.../config/firstboot```
* Contacts Github without certificate verification and pulls [firstboot.sh](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/firstboot/firstboot.sh) placing the file in: ```/etc/nhscs/config/deploy/firstboot```.
* Contacts Github without certificate verification and pulls [firstboot.service](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/firstboot/firstboot.service) placing the file in: ```/etc/nhscs/config/deploy/firstboot```.
* Runs ```chmod +x``` on the script to enable execution.
* Enable the firstboot.serivce on startup.
* Runs daemon-reload.

##### Part Two
* Creates storage dir for step 2: ```.../config/secondboot```
* Contacts Github without certificate verification and pulls [secondboot.sh](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/secondboot/secondboot.sh) placing the file in: ```/etc/nhscs/config/deploy/secondboot```.
* Contacts Github without certificate verification and pulls [secondboot.service](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/secondboot/secondboot.service) placing the file in: ```/etc/nhscs/config/deploy/secondboot```.
* Runs ```chmod +x``` on the script to enable execution.
* Enable the secondboot.serivce on startup.
* Runs daemon-reload.

##### Part Three
* Creates storage dir for step 3: ```.../config/thirdboot```
* Contacts Github without certificate verification and pulls [thirdbootboot.sh](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/thirdboot/thirdboot.sh) placing the file in: ```/etc/nhscs/config/deploy/thirdboot```.
* Contacts Github without certificate verification and pulls [thirdbootboot.service](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/thirdboot/thirdboot.service) placing the file in: ```/etc/nhscs/config/deploy/thirdboot```.
* Runs ```chmod +x``` on the script to enable execution.
* Enable the thridbootboot.serivce on startup.
* Runs daemon-reload.

##### Part Four
* Creates check files for every step in deployment.
  * ``` mkdir .../config/checks/```
  * ``` mkdir .../config/checks/fbp1.check```
  * ``` mkdir .../config/checks/fbp2.check```
  * ``` mkdir .../config/checks/fbp3.check```
  * ``` mkdir .../config/checks/hwch.check```
* Creates storage dir for conf files.
  * ```mkdir .../config/files```

##### Part Five
* Creates storage dir for sudoers conf: ```.../files/sudoers```
* Contacts Github without certificate verification and pulls [sudoers](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/Config%20Files/sudoers/01domain) placing the file in: ```/etc/nhscs/config/files/sudoers```.
* Creates storage dir for pam.d conf: ```.../files/pam.d```
* Contacts Github without certificate verification and pulls [pam.d](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/Config%20Files/pam.d/common-session) placing the file in: ```/etc/nhscs/config/files/pam.d```.
* Creates storage dir for dconf files: ```.../files/dconf```
* Contacts Github without certificate verification and pulls [dconf](https://github.com/NHSCS-ORG/Post-Install-Config/tree/master/Config%20Files/dconf) placing the files in: ```/etc/nhscs/config/files/dconf```.
* Creates storage dir for gdm3 conf: ```.../files/gdm3```
* Contacts Github without certificate verification and pulls [gdm3](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/Config%20Files/gdm3/custom.conf) placing the file in: ```/etc/nhscs/config/files/gdm3```.

##### Part Six
* Creates storage dir for our certficates: ```.../files/telaforce```
* Contacts Github without certificate verification and pulls our [certs](https://github.com/NHSCS-ORG/Ubuntu-Kickstart/blob/master/Firewall_Certificate.cer) placing the file in: ```/etc/nhscs/config/files/telaforce```.

##### Part Seven
* Log to the system that postinstall.sh has completed
* Writes  ```hwch.check``` with a 1 so that when firstboot.sh runs it can determine the system's current deployment status.
---
#### Firstboot
