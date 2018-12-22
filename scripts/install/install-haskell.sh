#!/usr/bin/env bash

set -e

if ! installed ghci; then
  sudo -E apt-get -qq install haskell-platform
fi
