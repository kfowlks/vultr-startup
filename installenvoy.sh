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
DEBIAN_FRONTEND=noninteractive

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
export $DEBIAN_FRONTEND



sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
check_errs $? "Failed to install envoy deps"

curl -sL 'https://getenvoy.io/gpg' | sudo apt-key add -
check_errs $? "Failed to add key for envoy"

apt-key fingerprint 6FF974DB

sudo add-apt-repository \
"deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb \
$(lsb_release -cs) \
stable"
check_errs $? "Failed to add-apt-repository envoy"

sudo apt-get update && sudo apt-get install -y getenvoy-envoy
check_errs $? "Failed to install getenvoy-envoy"



