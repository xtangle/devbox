#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed code; then
  curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f microsoft.gpg
  sudo -E apt-get -qy update
fi

sudo -E apt-get -qy install code
