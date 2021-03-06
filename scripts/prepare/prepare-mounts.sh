#!/usr/bin/env bash

set -e
source bootstrap-devbox

# the shared folders needs to be remounted on every startup to change ownership from root to vagrant.

echo ">> (Re)creating rc-local.service"
#backup /etc/rc.local
#backup /etc/systemd/system/rc-local.service
sudo cp -f "/vagrant/files/rc-local/rc.local" /etc
sudo cp -f "/vagrant/files/rc-local/rc-local.service" /etc/systemd/system
sudo chmod u+x /etc/rc.local
sudo chmod a-x /etc/systemd/system/rc-local.service

echo ">> (Re)starting rc-local.service"
sudo systemctl enable rc-local.service
sudo systemctl daemon-reload
sudo systemctl restart rc-local.service

echo ">> Waiting for rc-local.service to finish mounting..."
sleep 6

if [[ -d "${HOME}/.provision/scripts" ]]; then
  echo ">> Successfully mounted shared folders"
else
  echo ">> Error: Unable to mount shared folders"
  exit 1
fi

# view logs from current boot
# sudo journalctl -u rc-local.service -b
