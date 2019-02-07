#!/usr/bin/env bash

set -e

if ! installed google-chrome; then
  wget -q -O- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
  sudo -E apt-get -qq update
  sudo -E apt-get -qq install google-chrome-stable

  # set google-chrome as the default web browser
  sudo update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

  # add desktop icon
  cp -f "${VAGRANT_FILES}/Desktop/google-chrome.desktop" "${HOME}/Desktop"
fi
