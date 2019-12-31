#!/usr/bin/env bash

set -e
source bootstrap-devbox

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend

# update system
sudo -E apt-get -qy update --fix-missing
sudo -E apt-get -qy dist-upgrade --fix-missing
sudo -E apt-get -qy autoremove
sudo -E snap refresh
