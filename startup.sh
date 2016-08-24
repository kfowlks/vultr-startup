#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Kevin Fowlks <fowkl1kd@gmail.com>
#
# Description:
#   A post-installation bash script for ubuntu 16.4
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
HOMEDIR=/home
USERNAME=${USERNAME:-deploy}
USERNAME_UID=${USERNAME_UID:-1979}
SUDOERS_DEPLOYFILE="/etc/sudoers.d/automate-deploy"
SSHDIR=".ssh"
USER_SSH_DIR="$HOMEDIR/$USERNAME/$SSHDIR"
SSH_PUB_KEY1=${SSH_PUB_KEY1:-ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRTnJn7fp32e3pitCOW5vuo4NB3wZw4arz286mk4CR/PzNyQvLE4YBKhSKCLg0Cw7iP2E8xLmUtDemjEKQZALzGZRTCDQN4Qqs4M0NFYiL1G5kYA806R6qCVxjhrQG85AK0AW5nk/rVw4IgD2/y4ojmhGCvbdW9nN522r8nZjs4d175nMyJRfohOqrNZAz/dD1Ph8U5kljg/Jz80A4t6x9E6Rl+8VolKnvo7U/k4yGWOhxsj6KutqFmdJVaiP+UCL9y8FeM4qHsVe5MpQGN+RxANhDf0OiMHZh9l0ani2Gqf3HyCbHJgE98aA1TNxVi0fJUy0gOfAsM7hzj3TxY5yR FOWLKS@AVPHR-2F1SP32}

RELEASE=$(lsb_release -c | cut -f 2 -d $'\t')
DISTRO=$(lsb_release -i | cut -f 2 -d $'\t')

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

useradd -u $USERNAME_UID --shell '/bin/bash' $USERNAME
check_errs $? "Failed create user $USERNAME"

echoGreen "$USERNAME with UID:$USERNAME_UID was successfully created!"

usermod -aG sudo $USERNAME
check_errs $? "Failed to add user $USERNAME to group sudo"

mkdir -p $USER_SSH_DIR
check_errs $? "Failed to create directory $USER_SSH_DIR"

chmod 600 $USER_SSH_DIR
check_errs $? "Failed change permission on $USER_SSH_DIR"

echo $SSH_PUB_KEY1 > "$USER_SSH_DIR/authorized_keys"
check_errs $? "Failed to add public key to account $USER_SSH_DIR/authorized_keys"

chmod 700 "$USER_SSH_DIR/authorized_keys"
check_errs $? "Failed to modifiy permissions on $USER_SSH_DIR/authorized_keys"

chown -R $USERNAME:$USERNAME $USER_SSH_DIR
check_errs $? "Failed to modifiy permissions on $USER_SSH_DIR/authorized_keys"

echoGreen "SSH PUBLIC Key has been successfully added to USER:$USERNAME"

echo "$USERNAME	ALL = NOPASSWD: ALL" > $SUDOERS_DEPLOYFILE
check_errs $? "Failed to create sudoers file"

visudo -c -f $SUDOERS_DEPLOYFILE
check_errs $? "Validate suders file $SUDOERS_DEPLOYFILE" $SUDOERS_DEPLOYFILE

echoGreen "USER:$USERNAME has been successfully added to custom suders file"

echoGreen "Script has been executed successfully"
exit 0
