#!/usr/bin/env bash

set -e

# note: this script *must* be the first script to run by Utils::provision_script method in the 'prepare' stage

# bootstraps the devbox bootstrap script to be available in the path
bin_dir="\${HOME}/.provision/scripts/bin"
mkdir -p "${HOME}/.rc"
cat > "${HOME}/.rc/devbox" << EOL
export PATH="${bin_dir}:\${PATH}"
EOL
source_in_profile "\${HOME}/.rc/devbox"

echo "Sourced the devbox bootstrap scripts to be available in the PATH"
