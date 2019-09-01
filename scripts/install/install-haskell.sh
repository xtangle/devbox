#!/usr/bin/env bash

set -e

# install haskell-platform
sudo -E apt-get -qy install haskell-platform

# install stack
if ! installed stack; then
  echo ">> Installing Haskell stack"
  wget -qO- https://get.haskellstack.org/ | sh
else
  echo ">> Updating Haskell stack"
  stack upgrade
fi
