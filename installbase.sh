#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Kevin Fowlks <fowlk1kd@gmail.com>
#
# Description:
#   A post base tool installation bash script for Ubuntu 16.04+
#
# Legal Preamble:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>
# tab width

tabs 4
clear

ROOT_UID=0
E_NOTROOT=1
ADMIN_EMAIL=fowlk1kd@gmail.com

echoRed() {
  echo -e "\E[1;31m$1"
  echo -e '\e[0m'
}

echoGreen() {
  echo -e "\E[1;32m$1"
  echo -e '\e[0m'
}

echoCyan() {
  echo -e "\E[1;36m$1"
  echo -e '\e[0m'
}

echoMagenta() {
  echo -e "\E[1;35m$1"
  echo -e '\e[0m'
}

check_errs()
{
  # Function. Parameter 1 is the return code
  # Para. 2 is text to display on failure.
      if [ "${1}" -ne "0" ]; then
        echoRed "ERROR # ${1} : ${2}"
        # as a bonus, make our script exit with the right error code.
        if [ "$#" -eq 3 ]; then
          echoCyan "cleaning file from failed script attempt "
          rm -f ${3}
          check_errs $? "Failed to remove file - ${3}"
        fi

        exit ${1}
      fi
}

if [ $UID -ne $ROOT_UID ]
then                                                                                                       
    echoRed "﴾͡๏̯͡๏﴿ O'RLY? Sorry You must be root to run this script... Quiting";
    exit $E_NOTROOT
else
    echoGreen "(ง ͠° ͟ل͜ ͡°)ง go go get em cowboy"
fi

#sudo apt-add-repository --yes --force-yes ppa:ansible/ansible
#sudo apt-get --yes --force-yes update
#sudo apt-get --yes --force-yes install ansible

apt-get --yes --force-yes update
check_errs $? "Failed to apt-get update"

apt-get --yes --force-yes upgrade
check_errs $? "Failed to apt-get upgrade"

apt-get --yes --force-yes install unattended-upgrades
check_errs $? "Failed to configure unattended-upgrades"

truncate -s 0 /etc/apt/apt.conf.d/10periodic
check_errs $? "Failed to truncate 10periodic"

echo 'APT::Periodic::Update-Package-Lists "1";' >  /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >>  /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' >>  /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >>  /etc/apt/apt.conf.d/10periodic

echo '// Automatically upgrade packages from these (origin, archive) pairs' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo 'Unattended-Upgrade::Allowed-Origins {    ' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '    // ${distro_id} and ${distro_codename} will be automatically expanded' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '    "${distro_id} stable";' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '    "${distro_id} ${distro_codename}-security";' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '    "${distro_id} ${distro_codename}-updates";' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '//  "${distro_id} ${distro_codename}-proposed-updates";' >>  /etc/apt/apt.conf.d/50unattended-upgrades
echo '};' >>  /etc/apt/apt.conf.d/50unattended-upgrades


apt-get --yes --force-yes install fail2ban
check_errs $? "Failed to install fail2ban"

#ufw allow from {your-ip} to any port 22
#check_errs $? "Failed to configure ufw #1"

ufw allow 80
check_errs $? "Failed to configure ufw #2"

ufw allow 443
check_errs $? "Failed to configure ufw #3"

ufw allow 9252
check_errs $? "Failed to configure ufw #4"

ufw enable
check_errs $? "Failed to configure ufw #5"

# Secure Node 
sed -i '/^PermitRootLogin/s/yes/prohibit-password/' /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #1"

sed -i "s/.*RSAAuthentication.*/RSAAuthentication yes/g" /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #2"

sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #3"

sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #4"

sed -i "s/.*AuthorizedKeysFile.*/AuthorizedKeysFile\t\.ssh\/authorized_keys/g" /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #5"

sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
check_errs $? "Failed to config sshd config #6"

sshd -t
check_errs $? "Failed sshd config is not valid"

service sshd restart
check_errs $? "Failed to restart sshd"

# Install Log Watch
apt-get --yes --force-yes install logwatch
check_errs $? "Failed to install logwatch"

echo >> '/usr/sbin/logwatch --output mail --mailto $ADMIN_EMAIL --detail high' >> /etc/cron.daily/00logwatch
check_errs $? "Failed to configure logwatch"

# Install Docker
curl -sSL https://get.docker.com/ | sh
check_errs $? "Failed to install docker"

docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:alpine
check_errs $? "Failed to configure docker"

sudo usermod -aG docker deployer
check_errs $? "Failed to add user deployer to group docker"

#mkdir -p /srv/gitlab-runner/config
#check_errs $? "Failed to create /srv/gitlab-runner/config directory"
