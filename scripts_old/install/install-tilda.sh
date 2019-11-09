#!/usr/bin/env bash

set -e

sudo -E apt-get -qy install tilda

# add tilda to the list of terminal emulators
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/tilda 0
