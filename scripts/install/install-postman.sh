#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed postman; then
  sudo -E snap install postman --classic
else
  sudo -E snap refresh postman
fi
