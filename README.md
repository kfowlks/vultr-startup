# Vultr minimal rundeck post install script for Ubuntu 16.04

This single bash script can be called from the vultr Startup Script section of your instance. This script performs the below tasks.

+ Creates new user to be used by Rundeck/Ansible/Puppet
+ Adds public key to newly created user
+ Adds newly created user to sudoers with NOPASSWD
 
After this all other changes should be issued from your server management tools e.g. Ansible/Puppet/Fabric

###Reference
The below can be overridden by exporting new environmental shell values before executing the script (See example under usage)

* export USERNAME=deployer
* export USERNAME_UID=2079
* export SSH_PUB_KEY1='YOUR PUBLIC KEY HERE'

###Requires

* Ubuntu 16.04 x64
* WGET
* BASH
* SUDERS

### Version
0.0.1

### Usage

By using the below you can ensure you are always using the latest version of the script for your nodes.

```bash
# Just copy and paste the below into your Startup Scripts under Servers. 
#!/bin/sh

export STARTUP_URL=https://raw.githubusercontent.com/kfowlks/vultr-startup/master/startup.sh
export STARTUP_LOCAL_FILE=startup.sh

wget $STARTUP_URL

chmod +x $STARTUP_LOCAL_FILE

export SSH_PUB_KEY1='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRTnJn7fp32e3pitCOW5vuo4NB3wZw4arz286mk4CR/PzNyQvLE4YBKhSKCLg0Cw7iP2E8xLmUtDemjEKQZALzGZRTCDQN4Qqs4M0NFYiL1G5kYA806R6qCVxjhrQG85AK0AW5nk/rVw4IgD2/y4ojmhGCvbdW9nN522r8nZjs4d175nMyJRfohOqrNZAz/dD1Ph8U5kljg/Jz80A4t6x9E6Rl+8VolKnvo7U/k4yGWOhxsj6KutqFmdJVaiP+UCL9y8FeM4qHsVe5MpQGN+RxANhDf0OiMHZh9l0ani2Gqf3HyCbHJgE98aA1TNxVi0fJUy0gOfAsM7hzj3TxY5yR FOWLKS@AVPHR-2F1SP32'

export USERNAME=deployer
export USERNAME_UID=2079

source $STARTUP_LOCAL_FILE
```
Step - 1 
![Alt text](/vultr-shot1.PNG?raw=true "Vultr Startup Scripts")

Step - 2
![Alt text](/vultr-shot2.PNG?raw=true "Vultr Startup Scripts - Editor")
