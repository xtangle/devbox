#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed dbeaver; then
  echo ">> Installing dbeaver"
  wget -qO- https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
  echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

  sudo -E apt-get -qy update
  sudo -E apt-get -qy install dbeaver-ce
fi
