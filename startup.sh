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

HOMEDIR=/home
USERNAME="deploy"
USERNAME_UID="1979"

SSHDIR=".ssh"
USER_SSH_DIR="$HOMEDIR/$USERNAME/SSHDIR"

# DISTROS AND RELEASES
RELEASE=$(lsb_release -c | cut -f 2 -d $'\t')
DISTRO=$(lsb_release -i | cut -f 2 -d $'\t')

#----- Fancy Messages -----#
show_error(){
echo -e "\033[1;31m$@\033[m" 1>&2
}
show_info(){
echo -e "\033[1;32m$@\033[0m"
}
show_warning(){
echo -e "\033[1;33m$@\033[0m"
}
show_question(){
echo -e "\033[1;34m$@\033[0m"
}
show_success(){
echo -e "\033[1;35m$@\033[0m"
}
show_header(){
echo -e "\033[1;36m$@\033[0m"
}
show_listitem(){
echo -e "\033[0;37m$@\033[0m"
}

ROOT_UID=0
if [ $UID -ne $ROOT_UID ]
then                                                                                                       
    echo ":/ You must be root to run this script... Quiting"
exit $E_NOTROOT
else
  show_info()
  echo ";) Welcome root"
fi

useradd -u $USERNAME_UID --shell '/bin/bash' $USERNAME

usermod -aG sudo $USERNAME

mkdir -p $USER_SSH_DIR

chmod 600 $USER_SSH_DIR

echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRTnJn7fp32e3pitCOW5vuo4NB3wZw4arz286mk4CR/PzNyQvLE4YBKhSKCLg0Cw7iP2E8xLmUtDemjEKQZALzGZRTCDQN4Qqs4M0NFYiL1G5kYA806R6qCVxjhrQG85AK0AW5nk/rVw4IgD2/y4ojmhGCvbdW9nN522r8nZjs4d175nMyJRfohOqrNZAz/dD1Ph8U5kljg/Jz80A4t6x9E6Rl+8VolKnvo7U/k4yGWOhxsj6KutqFmdJVaiP+UCL9y8FeM4qHsVe5MpQGN+RxANhDf0OiMHZh9l0ani2Gqf3HyCbHJgE98aA1TNxVi0fJUy0gOfAsM7hzj3TxY5yR FOWLKS@AVPHR-2F1SP32 > "$USER_SSH_DIR/authorized_keys"

chmod 700 "$USER_SSH_DIR/authorized_keys"