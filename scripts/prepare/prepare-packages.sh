#!/usr/bin/env bash

set -e
source bootstrap-devbox

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend

# update system
sudo -E apt-get -qy update --fix-missing
sudo -E apt-get -qy dist-upgrade --fix-missing
sudo -E apt-get -qy autoremove

# install snap
sudo -E apt-get -qy install snapd
sudo -E snap refresh
sudo -E snap install snap-store
