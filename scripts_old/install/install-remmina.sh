#!/usr/bin/env bash

set -e

# installs Remmina
if ! installed remmina; then
  sudo -E apt-add-repository -y ppa:remmina-ppa-team/remmina-next
  sudo -E apt-get -qy update
fi

sudo -E apt-get -qy install remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice
