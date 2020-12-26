#!/usr/bin/env bash

set -e
source bootstrap-devbox

sudo -E apt-get -qy autoremove

sudo flatpak uninstall --unused
