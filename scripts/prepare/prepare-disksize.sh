#!/usr/bin/env bash

set -e
source bootstrap-devbox

###
# Run this if the VM hard disk is configured with either:
#   - 1 partition: /dev/sda1 (primary data), or
#   - 2 partitions: /dev/sda1 (primary data), and /dev/sda2 (swap)
#
# In either case, this script will remove the swap partition (if it exists) and allocates
# the entire disk to the primary data partition by deleting and re-creating the partition with fdisk.
#
# It will only do this if there is a change in the disk size. The previous disk size is cached in a file
# located at "${DEVBOX_GLOBAL_CONF_DIR}/prepare-disksize/prev-disk-size".
###

config_dir="${DEVBOX_GLOBAL_CONF_DIR}/prepare-disksize"
sudo mkdir -p "${config_dir}"

prev_disk_size_file="${config_dir}/prev-disk-size"
continue_from_prev_file="${config_dir}/continue-from-previous"
disk_timestamp_file="${config_dir}/disk-timestamp"

device=/dev/sda
primary_label="${device}1"
swap_label="${device}2"

# calculate sector end of device
sector_end="$(sudo fdisk -l "${device}" | grep "${device}" -m 1 | sed -rn 's/.* ([0-9]+) sectors.*/\1/gp')"

function finalize {
  timestamp="$(date)"
  sudo rm -f "${continue_from_prev_file}"
  sudo sh -c "echo ${sector_end} > ${prev_disk_size_file}"
  sudo sh -c "echo '${timestamp}' > ${disk_timestamp_file}"
  echo ">> Successfully configured disk size on ${timestamp}"
}

function expand_filesystem {
  echo ">> Expanding the file system"
  sudo resize2fs "${primary_label}"

  echo ">> New available size of filesystem:"
  df -h /
}

# continuing where previously left off if the trigger file is found
if [[ -f "${continue_from_prev_file}" ]]; then
  echo ">> Continuing from previous installation"
  expand_filesystem
  finalize
  exit 0
fi

# skip if script ran successfully before and disk size is unchanged (ie. sector end is the same as before)
if [[ -f "${prev_disk_size_file}" ]]; then
  prev_sector_end="$(cat "${prev_disk_size_file}")"
  if [[ "${sector_end}" -eq "${prev_sector_end:-0}" ]]; then
    echo ">> Disk size is the same, nothing to do"
    exit 0
  else
    echo ">> Detected change in hard disk size, proceeding to update partition table"
  fi
fi

# check if how the disk is partitioned is a known valid configuration
# (either only /dev/sda1 for data, or /dev/sda1 for data with /dev/sda2 for swap)
is_valid=false
has_swap_partition=false
fdisk_output="$(sudo fdisk -l "${device}" | grep "${device}[0-9]")"
num_partitions="$(echo "${fdisk_output}" | wc -l)"
first_partition_is_linux="$(if echo "${fdisk_output}" | grep "${primary_label}" | grep -qi 'Linux'; then echo "true"; fi)"
second_partition_is_swap="$(if echo "${fdisk_output}" | grep "${swap_label}" | grep -qi 'Linux swap'; then echo "true"; fi)"

if [[ "${num_partitions}" -eq 1 && "${first_partition_is_linux}" == true ]]; then
  is_valid=true
elif [[ "${num_partitions}" -eq 2 && "${first_partition_is_linux}" == true && "${second_partition_is_swap}" == true ]]; then
  is_valid=true
  has_swap_partition=true
fi

if [[ "${is_valid}" != true ]]; then
  echo ">> The partitions on device ${device} is not configured in a way that is supported by the provisioning script. " \
    "Either only: ${primary_label} for data, or ${primary_label} for data and ${swap_label} for swap, is allowed." >/dev/stderr
  exit 1
fi

# modify the partition table
echo ">> Partitions of ${device} before modifying the partition table:"
sudo fdisk -l "${device}"

primary_sec_start="$(sudo fdisk -l "${device}" | grep "${primary_label}" | awk '{ print $2 }')"
sudo swapoff -a

# remove the swap partition
if [[ "${has_swap_partition}" == true ]]; then
  echo ">> Modifying partition table: removing swap partition..."
  set +e # temporarily disabling fail-fast because fdisk gives a warning about the kernel not reading from the updated partition table.
  sudo fdisk "${device}" << EOF
d
2
EOF
  set -e
  echo ">> Partitions of ${device} after removing the swap partition:"
  sudo fdisk -l "${device}"
fi

# expand the primary partition
echo ">> Modifying partition table: expanding the primary partition..."
set +e # temporarily disabling fail-fast because fdisk gives a warning about the kernel not reading from the updated partition table.
sudo fdisk "${device}" << EOF
d
1
n
p
1
${primary_sec_start}

w
EOF
set -e
echo ">> Partitions of ${device} after expanding the primary partition:"
sudo fdisk -l "${device}"

# verify partition has been modified successfully
primary_sec_end="$(sudo fdisk -l "${device}" | grep "${primary_label}" | awk '{ print $3 }')"
if [[ "${primary_sec_end}" -ne $((sector_end - 1)) ]]; then
  echo ">> Error occurred when modifying the partition table, changes were not saved" >/dev/stderr
  exit 1
fi

# clear previous swap partition configuration
sudo rm -f /etc/crypttab
sudo sed -i.bak "\@^/dev/mapper/cryptswap@d" /etc/fstab
sudo sed -i.bak "\@^${swap_label}@d" /etc/fstab

# mark for reboot and exit if there was a swap partition that was deleted
if [[ "${has_swap_partition}" == true ]]; then
  sudo touch "${continue_from_prev_file}"
  touch "${DEVBOX_REBOOT_PROMPT_FILE}"
  echo ">> A reboot is now required"
  exit 0
fi

# otherwise, finish by expanding the filesystem
expand_filesystem
finalize
