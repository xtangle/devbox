#!/usr/bin/env bash

set -e

# replace configs
mkdir -p ${HOME}/.config/lxpanel/Lubuntu/panels
backup ${HOME}/.config/lxpanel/Lubuntu/panels/panel
cp -f ${vagrant_files}/lxpanel/panel ${HOME}/.config/lxpanel/Lubuntu/panels
