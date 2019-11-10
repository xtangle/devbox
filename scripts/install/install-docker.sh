#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed docker; then
  sudo -E apt-get -qy install docker.io

  # add user to the docker group
  sudo groupadd -f docker
  sudo usermod -aG docker vagrant

  # configure docker to start on boot
  sudo systemctl enable docker
fi
