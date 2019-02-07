#!/usr/bin/env bash

set -e

load_nvm() {
  # shellcheck source=/dev/null
  . "${HOME}/.nvm/nvm.sh"
}

# loads nvm if exists
[[ -s "${HOME}/.nvm/nvm.sh" ]] && load_nvm

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
if ! contains "source ${HOME}/.rc/yarn" "${HOME}/.profile" ; then
  echo -e "source ${HOME}/.rc/yarn" >> "${HOME}/.profile"
fi
