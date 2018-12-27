#!/usr/bin/env bash

set -e

# install miscellaneous useful command-line tools
sudo -E apt-get -qq install lynx

# install useful gui configuration software
sudo -E apt-get -qq install lxappearance obconf
