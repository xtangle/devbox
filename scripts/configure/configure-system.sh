#!/usr/bin/env bash

set -e

load_provision_vars

# set passwords
echo -e "root\nroot" | (sudo passwd -q root) >/dev/null 2>&1

# configure timezone
sudo timedatectl set-timezone "${PROVISION_TIMEZONE}"

# removes the ubuntu user, if it exists
if id -u ubuntu > /dev/null 2>&1; then
  sudo deluser --remove-home ubuntu
fi

# disable auto-update since it interferes with provisioning
sudo bash -c "cat > /etc/apt/apt.conf.d/20auto-upgrades" << EOL
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOL

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend

# update system
sudo -E apt-get -qy update
sudo -E apt-get -qy dist-upgrade --fix-missing
sudo -E apt-get -qy autoremove
sudo -E snap refresh
