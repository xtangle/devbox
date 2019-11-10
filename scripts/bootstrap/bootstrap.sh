#!/usr/bin/env bash

export DEVBOX_DIR="${HOME}/.provision"
export DEVBOX_FILES="${DEVBOX_DIR}/files"
export DEVBOX_SCRIPTS="${DEVBOX_DIR}/scripts"

# export PATH="${DEVBOX_SCRIPTS}/configure:${DEVBOX_SCRIPTS}/install:${PATH}"

export RESULTS_FILE="${DEVBOX_DIR}/out/provision-results.csv"
export LOGS_DIR="${DEVBOX_DIR}/out/logs"

# sources all files in the bootstrap directory except this one
eval "$(find "${DEVBOX_SCRIPTS}/bootstrap" -maxdepth 1 -type f ! -name 'bootstrap.sh' -exec echo source \'{}\'';' \;)"

export HAS_BOOTSTRAPED="true"
