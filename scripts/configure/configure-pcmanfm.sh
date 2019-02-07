#!/usr/bin/env bash

set -e

# replace configs
mkdir -p "${HOME}/.config/pcmanfm/lubuntu"
backup "${HOME}/.config/pcmanfm/lubuntu/"*.conf
cp -f "${VAGRANT_FILES}/pcmanfm/desktop-items-0.conf" "${HOME}/.config/pcmanfm/lubuntu"
cp -f "${VAGRANT_FILES}/pcmanfm/pcmanfm.conf" "${HOME}/.config/pcmanfm/lubuntu"

mkdir -p "${HOME}/.config/libfm"
backup "${HOME}/.config/libfm/"*.conf
cp -f "${VAGRANT_FILES}/pcmanfm/libfm.conf" "${HOME}/.config/libfm"

# configure window sizes
width_ratio=0.55
height_ratio=0.65
win_width=$(bc <<< "${width_ratio} * ${DISPLAY_WIDTH} / 1")
win_height=$(bc <<< "${height_ratio} * ${DISPLAY_HEIGHT} / 1")
sed -i -E \
  -e "s/(win_width)=.*/\1=${win_width}/" \
  -e "s/(win_height)=.*/\1=${win_height}/" \
  "${HOME}/.config/pcmanfm/lubuntu/pcmanfm.conf"
