#!/usr/bin/env bash

set -e
source bootstrap-devbox

# install haskell-platform
sudo -E apt-get -qy install haskell-platform hoogle

# install stack
if ! installed stack; then
  echo ">> Installing Haskell stack"
  wget -qO- https://get.haskellstack.org/ | sh
#else
#  echo ">> Updating Haskell stack"
#  stack upgrade
fi
