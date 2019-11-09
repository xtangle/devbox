#!/usr/bin/env bash

set -e

if ! installed docker; then
  echo ">> Installing docker"
  # add Docker's official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # set up the stable repository
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # install docker
  sudo -E apt-get -qy update
  sudo -E apt-get -qy install docker-ce

  # add user to the docker group
  sudo groupadd -f docker
  sudo usermod -aG docker vagrant

  # configure docker to start on boot
  sudo systemctl enable docker
fi
