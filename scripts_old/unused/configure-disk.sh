#!/usr/bin/env bash

# This script is not needed anymore, kept here for reference.

set -e

if [[ -f /etc/disk_configured ]]; then
  exit 0
fi

sec_end=$(sudo fdisk -l | grep '/dev/sda5' | awk '{ print $3 }')
new_sec_start=$((sec_end + 1))

# Temporarily disabling fail-fast because fdisk gives a warning about the kernel not reading from the updated partition table.
set +e
sudo fdisk -u /dev/sda << EOF
n
p
3
${new_sec_start}

t
3
8e
w
EOF
set -e

sudo partprobe
sudo pvcreate -y /dev/sda3
sudo vgextend vagrant-vg /dev/sda3
sudo lvextend -l +100%FREE /dev/vagrant-vg/root
sudo resize2fs /dev/vagrant-vg/root

echo ">> Successfully configured disk size on $(date)" | sudo tee /etc/disk_configured
