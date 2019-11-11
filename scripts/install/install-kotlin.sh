#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed kotlinc; then
  sudo -E snap install kotlin --classic
else
  sudo -E snap refresh kotlin
fi
