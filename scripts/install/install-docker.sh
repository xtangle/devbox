#!/usr/bin/env bash

set -e
source bootstrap-devbox

if installed docker; then
  # uninstall older versions of docker
  sudo -E apt-get -qy remove docker docker-engine docker.io containerd runc
fi

if ! installed docker; then
  # add docker's official GPG key and set up the stable repository
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo -E add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # install latest version of docker
  sudo -E apt-get -qy update
  sudo -E apt-get -qy install docker-ce docker-ce-cli containerd.io

  # add user to the docker group
  sudo groupadd -f docker
  sudo usermod -aG docker vagrant

  # configure docker to start on boot
  sudo systemctl enable docker
fi
