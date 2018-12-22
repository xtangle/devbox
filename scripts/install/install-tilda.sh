#!/usr/bin/env bash

set -e

if ! installed tilda; then
  sudo -E apt-get -qq install tilda
fi

# add tilda to the list of terminal emulators
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/tilda 0
