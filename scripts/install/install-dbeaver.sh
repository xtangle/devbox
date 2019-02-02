#!/usr/bin/env bash

set -e

if ! installed dbeaver; then
  wget -qO- https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
  echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list

  sudo -E apt-get -qq update
  sudo -E apt-get -qq install dbeaver-ce
fi
