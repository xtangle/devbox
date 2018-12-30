#!/usr/bin/env bash

set -e

# loads nvm
[[ -s ${HOME}/.nvm/nvm.sh ]] && . ${HOME}/.nvm/nvm.sh

# check installed version
if ! installed nvm; then
  installed_version=''
else
  installed_version="$(nvm --version)"
fi

# get latest version
latest_version="$(wget -q -O- https://github.com/creationix/nvm/releases/latest | grep -m1 '/tag/' | sed -n 's/.*<a[^>]*>v\(.*\)<\/a>.*/\1/p')"
if [[ -z "${latest_version}" ]]; then
  echo "Unable to get latest version of nvm" > /dev/stderr
  exit 1
fi

# install nvm if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  export PROFILE="${HOME}/.profile"
  wget -qO- "https://raw.githubusercontent.com/creationix/nvm/v${latest_version}/install.sh" | bash
  . ${HOME}/.nvm/nvm.sh

  # install latest version of node and npm
  if [[ -z "${installed_version}" ]]; then
    nvm install node --latest-npm --no-progress 2>/dev/null
  else
    nvm install node --reinstall-packages-from=node --latest-npm --no-progress 2>/dev/null
  fi
  nvm use node
  nvm alias default node

  # update global npm packages
  npm update -g
fi
