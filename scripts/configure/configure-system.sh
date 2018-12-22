#!/usr/bin/env bash

set -e

# set passwords
echo -e "root\nroot" | (sudo passwd -q root) >/dev/null 2>&1

# sets timezone to host machine's timezone
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Etc/${timezone} /etc/localtime
echo "Etc/${timezone}" | sudo tee /etc/timezone >/dev/null

# removes the ubuntu user, if it exists
if id -u ubuntu > /dev/null 2>&1; then
  sudo deluser --remove-home ubuntu
fi

# update system
sudo -E apt-get -qq update
sudo -E apt-get -qq dist-upgrade --fix-missing
sudo -E apt-get -qq autoremove
sudo snap refresh

# install packages to allow apt to use a repository over https
sudo -E apt-get -qq install apt-transport-https ca-certificates curl software-properties-common

# install useful packages that are needed in other installation scripts
sudo -E apt-get -qq install unzip xmlstarlet
