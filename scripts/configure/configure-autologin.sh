#!/usr/bin/env bash

set -e

# enable autologin for vagrant user
backup /etc/lightdm/lightdm.conf
sudo cp -f ${vagrant_files}/LightDM/lightdm.conf /etc/lightdm
