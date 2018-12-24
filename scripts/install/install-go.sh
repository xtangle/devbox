#!/usr/bin/env bash

set -e

if ! installed go; then
  sudo -E snap install go --classic
fi
