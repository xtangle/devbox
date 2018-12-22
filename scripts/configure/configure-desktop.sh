#!/usr/bin/env bash

set -e

# installs lubuntu desktop core
if ! installed lubuntu-core; then
  sudo -E apt-get -qq install --no-install-recommends lubuntu-core
fi

# copy global openbox configs to user directory
if [[ ! -f ${HOME}/.config/openbox/lubuntu-rc.xml ]]; then
  mkdir -p ${HOME}/.config/openbox
  backup ${HOME}/.config/openbox/lubuntu-rc.xml
  cp -fT /usr/share/lubuntu/openbox/rc.xml ${HOME}/.config/openbox/lubuntu-rc.xml
fi

# set the number of workspaces to 1
xmlstarlet ed -L -u "//_:desktops/_:number" -v "1" ${HOME}/.config/openbox/lubuntu-rc.xml
# draw contents on resize
xmlstarlet ed -L -u "//_:resize/_:drawContents" -v "yes" ${HOME}/.config/openbox/lubuntu-rc.xml
# use the onyx theme as it looks better than the lubuntu theme
xmlstarlet ed -L -u "//_:theme/_:name" -v "Onyx" ${HOME}/.config/openbox/lubuntu-rc.xml

# create Desktop directory if it doesn't exist
mkdir -p ${HOME}/Desktop

# add bookmarks
backup ${HOME}/.gtk-bookmarks
cp -f ${vagrant_files}/gtk/.gtk-bookmarks ${HOME}
