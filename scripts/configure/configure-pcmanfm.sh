#!/usr/bin/env bash

set -e

load_provision_vars

# replace configs
echo ">> Replacing configs"
mkdir -p "${HOME}/.config/pcmanfm/lubuntu"
backup "${HOME}/.config/pcmanfm/lubuntu/"*.conf
cp -f "${DEVBOX_FILES}/pcmanfm/desktop-items-0.conf" "${HOME}/.config/pcmanfm/lubuntu"
cp -f "${DEVBOX_FILES}/pcmanfm/pcmanfm.conf" "${HOME}/.config/pcmanfm/lubuntu"

mkdir -p "${HOME}/.config/libfm"
backup "${HOME}/.config/libfm/"*.conf
cp -f "${DEVBOX_FILES}/pcmanfm/libfm.conf" "${HOME}/.config/libfm"

# configure window sizes
echo ">> Configuring window sizes"
width_ratio=0.55
height_ratio=0.65
win_width=$(bc <<< "${width_ratio} * ${PROVISION_DISPLAY_WIDTH} / 1")
win_height=$(bc <<< "${height_ratio} * ${PROVISION_DISPLAY_HEIGHT} / 1")
sed -i -E \
  -e "s/(win_width)=.*/\1=${win_width}/" \
  -e "s/(win_height)=.*/\1=${win_height}/" \
  "${HOME}/.config/pcmanfm/lubuntu/pcmanfm.conf"
