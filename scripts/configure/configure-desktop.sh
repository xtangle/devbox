#!/usr/bin/env bash

set -e

# installs lubuntu desktop core
if ! installed lubuntu-core; then
  sudo -E apt-get -qq install --no-install-recommends lubuntu-core
fi

# copy openbox configs
mkdir -p ${HOME}/.config/openbox
backup ${HOME}/.config/openbox/lubuntu-rc.xml
cp -f ${vagrant_files}/openbox/lubuntu-rc.xml ${HOME}/.config/openbox

# configure bookmarks and lxde theme
gtk_dir="${HOME}/.config/gtk-3.0"
mkdir -p ${gtk_dir}
backup ${gtk_dir}/bookmarks
backup ${gtk_dir}/settings.ini
cp -f ${vagrant_files}/gtk/bookmarks ${gtk_dir}
cp -f ${vagrant_files}/gtk/settings.ini ${gtk_dir}

# create Desktop directory if it doesn't exist
mkdir -p ${HOME}/Desktop
