#!/usr/bin/env bash

set -e

if ! installed python3; then
  sudo -E apt-get -qq install python3
fi

if ! installed pip3; then
  sudo -E apt-get -qq install python3-pip
fi
