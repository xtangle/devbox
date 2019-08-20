#!/usr/bin/env bash

set -e

sudo -E apt-get -qq install texlive-latex-extra

if ! installed texstudio; then
  sudo -E add-apt-repository ppa:sunderme/texstudio
  sudo -E apt-get -qq update
  sudo -E apt-get -qq install texstudio
fi
