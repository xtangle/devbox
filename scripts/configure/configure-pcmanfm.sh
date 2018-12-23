#!/usr/bin/env bash

set -e

# replace configs
mkdir -p ${HOME}/.config/pcmanfm/lubuntu
backup ${HOME}/.config/pcmanfm/lubuntu/*.conf
cp -f ${vagrant_files}/pcmanfm/desktop-items-0.conf ${HOME}/.config/pcmanfm/lubuntu
cp -f ${vagrant_files}/pcmanfm/pcmanfm.conf ${HOME}/.config/pcmanfm/lubuntu

mkdir -p ${HOME}/.config/libfm
backup ${HOME}/.config/libfm/*.conf
cp -f ${vagrant_files}/pcmanfm/libfm.conf ${HOME}/.config/libfm

# add desktop icons
if [[ ! -f ${HOME}/Desktop/vagrant-files.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/vagrant-files.desktop ${HOME}/Desktop
fi

if [[ ! -f ${HOME}/Desktop/vagrant-scripts.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/vagrant-scripts.desktop ${HOME}/Desktop
fi

if [[ ! -f ${HOME}/Desktop/Projects.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/Projects.desktop ${HOME}/Desktop
fi
