#!/usr/bin/env bash

set -e

# the shared folders needs to be remounted on every startup to change ownership from root to vagrant.

echo ">> (Re)creating rc-local.service"
backup /etc/rc.local
backup /etc/systemd/system/rc-local.service
sudo cp -f "${DEVBOX_FILES}/rc-local/rc.local" /etc
sudo cp -f "${DEVBOX_FILES}/rc-local/rc-local.service" /etc/systemd/system
sudo chmod u+x /etc/rc.local
sudo chmod a-x /etc/systemd/system/rc-local.service

echo ">> (Re)starting rc-local.service"
sudo systemctl enable rc-local.service
sudo systemctl daemon-reload
sudo systemctl restart rc-local.service
