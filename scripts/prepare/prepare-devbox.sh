#!/usr/bin/env bash

set -e

# bootstraps the devbox bootstrap script to be available in the path
bin_dir="\${HOME}/.provision/scripts/bin"
mkdir -p "${HOME}/.rc"
cat > "${HOME}/.rc/devbox" << EOL
export PATH="${bin_dir}:\${PATH}"
EOL
source_in_profile "\${HOME}/.rc/devbox"
