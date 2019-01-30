#!/usr/bin/env bash

set -e

if ! installed meld; then
  sudo -E apt-get -qq install meld
fi
