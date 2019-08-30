#!/usr/bin/env bash

set -e

# install haskell-platform
if ! installed ghci; then
  sudo -E apt-get -qq install haskell-platform
fi

# install stack
if ! installed stack; then
  wget -qO- https://get.haskellstack.org/ | sh
else
  stack upgrade
fi
