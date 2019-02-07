#!/usr/bin/env bash

set -e

if ! installed postman; then
  sudo -E snap install postman --classic

  # add desktop icon
  cp -f "${VAGRANT_FILES}/Desktop/postman_postman.desktop ${HOME}/Desktop"
fi
