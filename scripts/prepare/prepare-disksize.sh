#!/usr/bin/env bash

set -e
source bootstrap-devbox

config_dir="${DEVBOX_GLOBAL_CONF_DIR}/prepare-disksize"
sudo mkdir -p "${config_dir}"

state_file="${config_dir}/state"
continue_from_prev_file="${config_dir}/continue-from-previous"
timestamp_file="${config_dir}/timestamp"

###
# continuing where previously left off if trigger file is found
###

if [[ -f "${continue_from_prev_file}" ]]; then
  echo ">> Continuing from previous installation, expanding file system"
  sudo resize2fs /dev/sda1

  echo ">> Available disk space:"
  df -h /

  echo ">> Configuring swapfile"
  # create new swapfile crypttab configuration
  sudo mkswap /dev/sda2
  sudo swapon /dev/sda2
  sudo yes | sudo ecryptfs-setup-swap || true # this is known to fail, should be properly configured after a reboot
  sudo cryptdisks_start cryptswap1
  sudo swapon -a
  sudo swapon -s

  echo ">> Successfully configured disk size on $(date)" | sudo tee "${timestamp_file}"
  sudo rm -f "${continue_from_prev_file}"
  exit 0
fi

###
# otherwise, continue on to modify partitions
###

sector_end="$(sudo fdisk -l /dev/sda | grep 'dev/sda' -m 1 | sed -rn 's/.* ([0-9]+) sectors.*/\1/gp')"

# skip if script ran successfully before and disk size is unchanged (ie. sector end is the same as before)
if [[ -f "${state_file}" ]]; then
  prev_sector_end="$(cat "${state_file}")"
  if [[ "${sector_end}" -eq "${prev_sector_end:-0}" ]]; then
    exit 0
  else
    echo ">> Detected change in hard disk size, proceeding to update partition table"
  fi
fi

sector_size="$(cat /sys/block/sda/queue/hw_sector_size)"

# calculate swap size in sectors
swap_size_gb=16
swap_size_sectors=$(((swap_size_gb * 1024 * 1024 * 1024) / sector_size))

# calculate new swap partition end
new_swap_sec_start=$((sector_end - swap_size_sectors))

# get ext sector start
fdisk_output="$(sudo fdisk -l /dev/sda)"
ext4_sec_start=$(echo "${fdisk_output}" | grep '/dev/sda1' | awk '{ print $2 }')

echo ">> Partitions before operation:"
sudo fdisk -l /dev/sda

echo ">> Modifying partition table..."
sudo swapoff -a
# temporarily disabling fail-fast because fdisk gives a warning about the kernel not reading from the updated partition table.
set +e
sudo fdisk /dev/sda << EOF
d
2
n
p
2
${new_swap_sec_start}

t
2
82
d
1
n
p
1
${ext4_sec_start}

w
EOF
set -e

echo ">> Partitions after operation:"
sudo fdisk -l /dev/sda

# verify partition has been modified successfully
fdisk_output="$(sudo fdisk -l /dev/sda)"
new_ext4_sec_end=$(echo "${fdisk_output}" | grep '/dev/sda1' | awk '{ print $3 }')
if [[ "${new_ext4_sec_end}" -ne $((new_swap_sec_start - 1)) ]]; then
  echo ">> Error occurred when modifying the partition table, changes were not saved"
  exit 1
fi

# clear previous swapfile crypttab configuration
sudo rm -f /etc/crypttab
sudo sed -i.bak "\@/dev/mapper/cryptswap@d" /etc/fstab

sudo sh -c "echo ${sector_end} > ${state_file}"
sudo touch "${continue_from_prev_file}"
touch "${DEVBOX_REBOOT_PROMPT_FILE}"

echo ">> A reboot is now required"
