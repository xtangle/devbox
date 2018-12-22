#!/usr/bin/env bash

set -e

if ! installed go; then
  sudo snap install go --classic
fi
