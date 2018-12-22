#!/usr/bin/env bash

# replace configs
mkdir -p ${HOME}/.config/pcmanfm/lubuntu
backup ${HOME}/.config/pcmanfm/lubuntu/*
cp -f ${vagrant_files}/pcmanfm/*.conf ${HOME}/.config/pcmanfm/lubuntu

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
