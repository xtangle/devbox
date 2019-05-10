#!/usr/bin/env bash

set -e

CONFLUENT_VERSION="2.11"

if ! installed confluent; then
  # add Confluent's official public key
  wget -qO - https://packages.confluent.io/deb/3.3/archive.key | sudo apt-key add -

  # set up the stable repository
  sudo add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/3.3 stable main"

  # install confluent-platform
  echo "Installing confluent-platform-${CONFLUENT_VERSION} ..."
  sudo -E apt-get -qq update
  sudo -E apt-get -qq install confluent-platform-${CONFLUENT_VERSION}
fi
