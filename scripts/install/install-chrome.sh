#!/usr/bin/env bash

set -e
source bootstrap-devbox

if ! installed google-chrome; then
  echo ">> Installing google-chrome"
  wget -q -O- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
  sudo -E apt-get -qy update
  sudo -E apt-get -qy install google-chrome-stable

  # set google-chrome as the default web browser
  sudo update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
fi
