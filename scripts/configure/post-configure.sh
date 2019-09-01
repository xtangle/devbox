#!/usr/bin/env bash

set -e

# remove any unused packages
sudo -E apt-get -qy autoremove

# ensure the ownership of all files in user's config directory
sudo chown -R vagrant /home/vagrant/.config

# ensure the user's bin directory exists
mkdir -p "${HOME}/bin"
