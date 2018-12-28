#!/usr/bin/env bash

set -e

if ! installed viewnior; then
  sudo -E apt-get -qq install viewnior
fi
