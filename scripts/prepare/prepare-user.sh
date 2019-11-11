#!/usr/bin/env bash

set -e
source bootstrap-devbox

# ensure the user's bin directory exists
mkdir -p "${HOME}/bin"
sudo chown -R vagrant "${HOME}/bin"
