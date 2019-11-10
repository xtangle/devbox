#!/usr/bin/env bash

set -e

# bootstraps the bootstrap script to be available in the path
mkdir -p "${HOME}/.rc"
cat > "${HOME}/.rc/devbox" << EOL
export PATH="${HOME}/.provision/scripts/bin:${PATH}"
EOL
source_in_profile "\${HOME}/.rc/devbox"
