#!/usr/bin/env bash

set -e

if ! installed go; then
  sudo -E snap install go --classic
else
  sudo -E snap refresh go
fi
