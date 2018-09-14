# Post-Install-Config
## WARNING: Do not use this script without modifing it for your environment, it is hard coded for NHSCS and WILL FAIL without modification.
Config a MaaS installed image after deployment.

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

#### Firstboot after Install
MaaS installs are automatically configured with a live user, so we don't need to worry about logging in, yet. Systemd starts our service before the Xserver, so depending on the speed of your system you may not see the desktop before a reboot is triggered. This is normal.
Here are the steps that postinit.sh completes:
* Contacts Github without certificate verification and pulls [postinstall.sh](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/HW/postinstall.sh)
* Contacts Github without certificate verification and pulls [hw.service](https://github.com/NHSCS-ORG/Post-Install-Config/blob/master/HW/hw.service)
* Enables hw.service so on next boot configuration continues.
* Log to the system that postinit.sh has completed
* Writes  ```pinit.check``` with a 1 so that when postinstall.sh runs it can determine the systems current deployment status.

Note: For editing, next hw.service and postinstall.sh
