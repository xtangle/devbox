#!/usr/bin/env bash

set -e

CONFLUENT_VERSION="2.11"

if ! installed confluent; then
  echo ">> Installing confluent-platform"
  # add Confluent's official public key
  wget -qO - https://packages.confluent.io/deb/3.3/archive.key | sudo apt-key add -

  # set up the stable repository
  sudo -E add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/3.3 stable main"

  # install confluent-platform
  echo ">> Installing confluent-platform-${CONFLUENT_VERSION} ..."
  sudo -E apt-get -qy update
  sudo -E apt-get -qy install confluent-platform-${CONFLUENT_VERSION}
fi
