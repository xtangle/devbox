#!/usr/bin/env bash

set -e

if ! installed postman; then
  sudo -E snap install postman --classic

  # add desktop icon
  # shellcheck disable=SC2225
  cp -f "${DEVBOX_FILES}/Desktop/postman_postman.desktop ${HOME}/Desktop"
else
  sudo -E snap refresh postman
fi
