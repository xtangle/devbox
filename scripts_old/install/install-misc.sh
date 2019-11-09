#!/usr/bin/env bash

set -e

# install miscellaneous useful command-line tools
sudo -E apt-get -qy install lynx

# install useful gui configuration software
sudo -E apt-get -qy install lxappearance obconf
