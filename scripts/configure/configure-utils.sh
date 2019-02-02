#!/usr/bin/env bash

set -e

# install packages to allow apt to use a repository over https
sudo -E apt-get -qq install apt-transport-https ca-certificates curl software-properties-common

# install useful packages that are needed in other installation scripts
sudo -E apt-get -qq install unzip xmlstarlet jq
