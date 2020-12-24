#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed confluent; then
  echo ">> Installing confluent-platform"
  # add Confluent's official public key
  wget -qO - https://packages.confluent.io/deb/6.0/archive.key | sudo apt-key add -

  # set up the stable repository
  sudo -E add-apt-repository -y "deb [arch=amd64] https://packages.confluent.io/deb/6.0 stable main"

  # install confluent-platform
  echo ">> Installing confluent-platform ..."
  sudo -E apt-get -qy update
  sudo -E apt-get -qy install confluent-platform
fi
