#!/usr/bin/env bash

set -e

# note: this script requires the following dependencies to be installed first:
# - install-java.sh

if installed lein; then
  yes | lein upgrade
else
  lein_file="${HOME}/bin/lein"
  curl -sSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o ${lein_file}
  chmod +x "${lein_file}"
  "${lein_file}" version
fi
