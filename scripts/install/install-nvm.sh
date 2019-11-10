#!/usr/bin/env bash

set -e
source bootstrap-devbox

# load nvm if exists
load "${HOME}/.nvm/nvm.sh"

# check installed version
if ! installed nvm; then
  installed_version=''
  echo ">> Nvm is not installed, installing"
else
  installed_version="$(nvm --version)"
  echo ">> Installed nvm version: ${installed_version}"
fi

# get latest version
latest_version="$(wget -qO- https://github.com/creationix/nvm/releases/latest | grep -oPm 1 'releases/tag/v\K([.0-9]*)(?=")' && :)"
if [[ -z "${latest_version}" ]]; then
  echo ">> Unable to get latest version of nvm" > /dev/stderr
  exit 1
fi
echo ">> Latest nvm version: ${latest_version}"

# install nvm if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  echo ">> Installing or updating nvm"
  export PROFILE="${HOME}/.profile"
  wget -qO- "https://raw.githubusercontent.com/creationix/nvm/v${latest_version}/install.sh" | bash
  load -f "${HOME}/.nvm/nvm.sh"
fi

# install latest version of node and npm
if [[ -z "${installed_version}" ]]; then
  nvm install node --latest-npm --no-progress 2>/dev/null
elif verlt "${installed_version}" "${latest_version}"; then
  nvm install node --reinstall-packages-from=node --latest-npm --no-progress 2>/dev/null
else
  nvm install node --latest-npm --no-progress 2>/dev/null
fi
nvm alias default node

# update global npm packages
npm update -g
