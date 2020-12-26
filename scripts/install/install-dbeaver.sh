#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed dbeaver; then
  echo ">> Installing dbeaver"
  #  sudo -E add-apt-repository -y ppa:serge-rider/dbeaver-ce
  #  sudo -E apt-get -qy update
  #  sudo -E apt-get -qy install dbeaver-ce

  # use flatpak
  sudo flatpak install -y --noninteractive flathub io.dbeaver.DBeaverCommunity
fi
