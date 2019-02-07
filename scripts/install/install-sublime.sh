#!/usr/bin/env bash

set -e

if ! installed subl; then
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

  sudo -E apt-get -qq update
  sudo -E apt-get -qq install sublime-text

  # add sublime to the list of text editors
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/subl 0

  # set sublime as the default editor
  sudo update-alternatives --set editor /usr/bin/subl

  # add desktop icon
  cp -f "${VAGRANT_FILES}/Desktop/sublime_text.desktop" "${HOME}/Desktop"
fi
