#!/usr/bin/env bash

set -e
source bootstrap-devbox

# set passwords
#echo -e "root\nroot" | (sudo passwd -q root) >/dev/null 2>&1

# configure timezone
if [[ -n "${PROVISION_TIMEZONE}" ]]; then
  sudo timedatectl set-timezone "${PROVISION_TIMEZONE}"
fi

# removes the ubuntu user, if it exists
if id -u ubuntu > /dev/null 2>&1; then
  sudo deluser --remove-home ubuntu
fi

# disable auto-update since it interferes with provisioning
#sudo bash -c "cat > /etc/apt/apt.conf.d/20auto-upgrades" << EOL
#APT::Periodic::Update-Package-Lists "0";
#APT::Periodic::Unattended-Upgrade "0";
#EOL
