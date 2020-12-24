#!/usr/bin/env bash

export DEVBOX_DIR="${HOME}/.provision"
export DEVBOX_FILES="${DEVBOX_DIR}/files"
export DEVBOX_SCRIPTS="${DEVBOX_DIR}/scripts"

export DEVBOX_RESULTS_FILE="${DEVBOX_DIR}/out/provision-results.csv"
export DEVBOX_REBOOT_PROMPT_FILE="${DEVBOX_DIR}/out/.reboot-prompt"
export DEVBOX_LOGS_DIR="${DEVBOX_DIR}/out/logs"
export DEVBOX_GLOBAL_CONF_DIR="/etc/devbox"

# sources all files in the bootstrap directory except this one
eval "$(find "${DEVBOX_SCRIPTS}/bootstrap" -maxdepth 1 -type f ! -name 'bootstrap.sh' -exec echo source \'{}\'';' \;)"

load_provision_vars

export DEVBOX_HAS_BOOTSTRAPED="true"
