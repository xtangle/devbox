#!/usr/bin/env bash

set -e
source bootstrap-devbox

###
# Note: This script should only be run after prepare-disksize.sh and machine has been rebooted (if needed)
#
# Configures a swapfile of size in gigabytes defined by PROVISION_SWAP_SIZE
# (or disables it if value is 0 or not set)
###

config_dir="${DEVBOX_GLOBAL_CONF_DIR}/prepare-disksize"
sudo mkdir -p "${config_dir}"

req_swap_size="${PROVISION_SWAP_SIZE:-0}"
prev_swap_size_file="${config_dir}/prev-swap-size"
swap_timestamp_file="${config_dir}/swap-timestamp"

# skip if script ran successfully before and swapfile size does not need to be changed
if [[ -f "${prev_swap_size_file}" ]]; then
  prev_swap_size="$(sudo swapon --raw --bytes --show=SIZE --noheadings | numfmt --to-unit=Gi)"
  if [[ "${req_swap_size}" -eq "${prev_swap_size:-0}" ]]; then
    echo ">> Swap size is the same, nothing to do"
    exit 0
  else
    echo ">> Detected change in swap size, proceeding to create new swapfile"
  fi
fi

# disable swap
sudo swapoff -a

# remove old swapfile and cryptswap configurations
echo ">> Removing old swapfile and cryptswap configurations"
sudo rm -f /swapfile
sudo rm -f /etc/crypttab
sudo sed -i.bak "\@^/dev/mapper/cryptswap@d" /etc/fstab
sudo sed -i.bak "\@^/swapfile@d" /etc/fstab

# if no swapfile is needed, skip creation of new swapfile
if [[ "${req_swap_size:-0}" -eq 0 ]]; then
  echo ">> Swap is disabled, skipping creation of new swapfile"
  exit 0
fi

# create and enable new swapfile
echo ">> Creating and enabling new swapfile"
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo ">> New swap summary:"
sudo swapon --show

# verify swap size
curr_swap_size="$(sudo swapon --raw --bytes --show=SIZE --noheadings | numfmt --to-unit=Gi)"
if [[ "${req_swap_size}" -ne "${curr_swap_size:-0}" ]]; then
  echo ">> Error occurred when configuring new swapfile, required swapfile size: ${req_swap_size}G, actual swapfile size: ${curr_swap_size}G" >/dev/stderr
  exit 1
fi

# add fstab entry
echo ">> Adding fstab entry"
# ensure fstab file ends with a newline
# shellcheck disable=SC1003
sudo sed -i -e '$a\' /etc/fstab
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# update cache files
sudo sh -c "echo ${curr_swap_size} > ${prev_swap_size_file}"
timestamp="$(date)"
echo ">> Successfully configured swapfile on ${timestamp}"
sudo sh -c "echo ${timestamp} > ${swap_timestamp_file}"
