#!/usr/bin/env bash

set -e

# the shared folders needs to be remounted on every startup to change ownership from root to vagrant.

backup /etc/rc.local
backup /etc/systemd/system/rc-local.service
sudo cp -f "${VAGRANT_FILES}/rc-local/rc.local" /etc
sudo cp -f "${VAGRANT_FILES}/rc-local/rc-local.service" /etc/systemd/system
sudo chmod u+x /etc/rc.local
sudo chmod a-x /etc/systemd/system/rc-local.service
sudo systemctl -q enable rc-local.service
sudo systemctl -q daemon-reload
sudo systemctl -q restart rc-local.service
