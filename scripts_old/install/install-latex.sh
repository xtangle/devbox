#!/usr/bin/env bash

set -e

sudo -E apt-get -qy install texlive-latex-extra

if ! installed texstudio; then
  sudo -E add-apt-repository ppa:sunderme/texstudio
  sudo -E apt-get -qy update
fi
sudo -E apt-get -qy install texstudio
