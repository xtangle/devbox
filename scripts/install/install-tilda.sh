#!/usr/bin/env bash

set -e
source bootstrap-devbox

sudo -E apt-get -qy install tilda

# add tilda to the list of terminal emulators
sudo -E update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/tilda 0

# set tilda as the preferred terminal emulator
# sudo -E update-alternatives --set x-terminal-emulator /usr/bin/tilda
