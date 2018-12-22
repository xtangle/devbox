#!/usr/bin/env bash

set -e

if ! installed gem; then
  sudo -E apt-get -qq install ruby-all-dev
fi
