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

# disable auto-update since it interferes with provisioning
sudo bash -c "cat > /etc/apt/apt.conf.d/20auto-upgrades" << EOL
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOL

# update system
sudo -E apt-get -qq update
sudo -E apt-get -qq dist-upgrade --fix-missing
sudo -E apt-get -qq autoremove
sudo -E snap refresh
