#!/usr/bin/env bash

set -e
source bootstrap-devbox

# add Kubuntu Backports PPA
sudo -E add-apt-repository -y ppa:kubuntu-ppa/backports
sudo -E apt-get -qy update
sudo -E apt-get -qy install kde-plasma-desktop kompare
