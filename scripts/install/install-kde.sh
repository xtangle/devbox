#!/usr/bin/env bash

set -e
source bootstrap-devbox

# add Kubuntu Backports PPA
sudo -E add-apt-repository -y ppa:kubuntu-ppa/backports
sudo -E apt-get -qy update
sudo -E apt-get -qy install plasma-desktop kde-plasma-desktop kompare
sudo -E apt-get -qy purge --auto-remove packagekit
