#!/usr/bin/env bash

set -e

if ! installed evince; then
  sudo -E apt-get -qq install evince
fi
