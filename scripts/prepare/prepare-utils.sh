#!/usr/bin/env bash

set -e
source bootstrap-devbox

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend

# install packages to allow apt to use a repository over https
sudo -E apt-get -qy install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# install useful packages that might be needed in other installation scripts
sudo -E apt-get -qy update
sudo -E apt-get -qy install ppa-purge unzip xmlstarlet jq gawk
sudo -E snap refresh
sudo -E snap install yq
