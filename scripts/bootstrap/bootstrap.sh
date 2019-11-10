#!/usr/bin/env bash

export DEVBOX_DIR="${HOME}/.provision"
export DEVBOX_FILES="${DEVBOX_DIR}/files"
export DEVBOX_SCRIPTS="${DEVBOX_DIR}/scripts"

export RESULTS_FILE="${DEVBOX_DIR}/out/provision-results.csv"
export LOGS_DIR="${DEVBOX_DIR}/out/logs"

# sources all files in the bootstrap directory except this one
eval "$(find "${DEVBOX_SCRIPTS}/bootstrap" -maxdepth 1 -type f ! -name 'bootstrap.sh' -exec echo source \'{}\'';' \;)"

load_provision_vars

export HAS_BOOTSTRAPED="true"
