#!/usr/bin/env bash

set -e

# install packages to allow apt to use a repository over https
sudo -E apt-get -qy install apt-transport-https ca-certificates curl software-properties-common

# install useful packages that are needed in other installation scripts
sudo -E add-apt-repository ppa:rmescandon/yq
sudo -E apt-get -qy update
sudo -E apt-get -qy install unzip xmlstarlet jq yq shellcheck dos2unix
