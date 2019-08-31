#!/usr/bin/env bash

set -e

load_provision_vars

# installs lubuntu desktop core
if ! installed lubuntu-core; then
  sudo -E apt-get -qq install --no-install-recommends lubuntu-core
fi

# configure openbox
mkdir -p "${HOME}/.config/openbox"
backup "${HOME}/.config/openbox/lubuntu-rc.xml"
cp -f "${DEVBOX_FILES}/openbox/lubuntu-rc.xml" "${HOME}/.config/openbox"

# configure bookmarks
mkdir -p "${HOME}/.config/gtk-3.0"
backup "${HOME}/.config/gtk-3.0/bookmarks"
cp -f "${DEVBOX_FILES}/gtk/bookmarks" "${HOME}/.config/gtk-3.0"

# add extra mount paths to bookmarks
for mount_name in "${PROVISION_EXTRA_MOUNTS_KEYS[@]}"; do
  mount_path="${HOME}/${mount_name}"
  echo "file://${mount_path} ${mount_name}" >> "${HOME}/.config/gtk-3.0/bookmarks"
done

# configure lxde panel
mkdir -p "${HOME}/.config/lxpanel/Lubuntu/panels"
backup "${HOME}/.config/lxpanel/Lubuntu/panels/panel"
cp -f "${DEVBOX_FILES}/LXDE/panel" "${HOME}/.config/lxpanel/Lubuntu/panels"

# configure lxsession including gtk theme
mkdir -p "${HOME}/.config/lxsession/Lubuntu"
backup "${HOME}/.config/lxsession/Lubuntu/desktop.conf"
cp -f "${DEVBOX_FILES}/LXDE/desktop.conf" "${HOME}/.config/lxsession/Lubuntu"
