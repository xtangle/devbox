#!/usr/bin/env bash

set -e

if ! installed git; then
  sudo -E apt-get -qq install git
fi
