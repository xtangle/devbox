#!/usr/bin/env bash

set -e

# the shared folders needs to be remounted on every startup to change ownership from root to vagrant.
# this can be done through rc.local, but check first if rc-local.service exists to see if it has been done before.
if [[ -f /etc/systemd/system/rc-local.service ]]; then
  exit
fi

backup /etc/rc.local
backup /etc/systemd/system/rc-local.service
sudo cp -f ${vagrant_files}/rc-local/rc.local /etc
sudo cp -f ${vagrant_files}/rc-local/rc-local.service /etc/systemd/system
sudo chmod u+x /etc/rc.local
sudo chmod a-x /etc/systemd/system/rc-local.service
sudo systemctl -q enable rc-local.service
sudo systemctl -q start rc-local.service
