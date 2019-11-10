#!/usr/bin/env bash

set -e

source "${HOME}/.provision/scripts/bootstrap/bootstrap.sh"

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend

# install packages to allow apt to use a repository over https
sudo -E apt-get -qy install apt-transport-https ca-certificates curl software-properties-common

# install useful packages that are needed in other installation scripts
sudo -E add-apt-repository -y ppa:rmescandon/yq
sudo -E apt-get -qy update
sudo -E apt-get -qy install unzip xmlstarlet jq yq shellcheck dos2unix
