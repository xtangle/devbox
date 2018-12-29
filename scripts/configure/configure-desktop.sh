#!/usr/bin/env bash

set -e

# installs lubuntu desktop core
if ! installed lubuntu-core; then
  sudo -E apt-get -qq install --no-install-recommends lubuntu-core
fi

# configure openbox
mkdir -p ${HOME}/.config/openbox
backup ${HOME}/.config/openbox/lubuntu-rc.xml
cp -f ${vagrant_files}/openbox/lubuntu-rc.xml ${HOME}/.config/openbox

# configure bookmarks
mkdir -p ${HOME}/.config/gtk-3.0
backup ${HOME}/.config/gtk-3.0/bookmarks
cp -f ${vagrant_files}/gtk/bookmarks ${HOME}/.config/gtk-3.0

# configure lxde panel
mkdir -p ${HOME}/.config/lxpanel/Lubuntu/panels
backup ${HOME}/.config/lxpanel/Lubuntu/panels/panel
cp -f ${vagrant_files}/LXDE/panel ${HOME}/.config/lxpanel/Lubuntu/panels

# configure lxsession including gtk theme
mkdir -p ${HOME}/.config/lxsession/Lubuntu
backup ${HOME}/.config/lxsession/Lubuntu/desktop.conf
cp -f ${vagrant_files}/LXDE/desktop.conf ${HOME}/.config/lxsession/Lubuntu

# create Desktop directory and add desktop icons for mounted shared folders
mkdir -p ${HOME}/Desktop
if [[ ! -f ${HOME}/Desktop/vagrant-files.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/vagrant-files.desktop ${HOME}/Desktop
fi
if [[ ! -f ${HOME}/Desktop/vagrant-scripts.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/vagrant-scripts.desktop ${HOME}/Desktop
fi
if [[ ! -f ${HOME}/Desktop/Projects.desktop ]]; then
  cp -f ${vagrant_files}/Desktop/Projects.desktop ${HOME}/Desktop
fi
