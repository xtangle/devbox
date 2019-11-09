#!/usr/bin/env bash

set -e

sudo -E apt-get -qy update --fix-missing
sudo -E apt-get -qy dist-upgrade --fix-missing
sudo -E apt-get -qy autoremove
