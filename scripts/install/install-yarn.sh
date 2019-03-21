#!/usr/bin/env bash

set -e

# load nvm if exists
load "${HOME}/.nvm/nvm.sh"

# add GPG key
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

# install yarn
if ! installed yarn; then
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo -E apt-get -qq update
  sudo -E apt-get -qq install --no-install-recommends yarn
fi

# add yarn to PATH
yarn_bin="$(yarn global bin)"
mkdir -p "${HOME}/.rc"
cat > "${HOME}/.rc/yarn" << EOL
export PATH=${yarn_bin}:\${PATH}
EOL
source_in_profile "\${HOME}/.rc/yarn"
