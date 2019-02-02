#!/usr/bin/env bash

set -e

# remove any unused packages
sudo -E apt-get -qq autoremove
