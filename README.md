# Vultr minimal rundeck post install script

This single bash script can be called from the vultr Startup Script section of your instance. This will script does the below task

+ Creates user to be used by Rundeck
+ Added public key to newly created user
+ Added newly created user to sudoers with NOPASSWD
 
After this all other changes change be made from Rundeck and Ansible/Puppet

###Reference


###Requires

Ubuntu 16.04

Under CYGWIN run the below to install pip

### Version
0.0.1

### Running the program 
