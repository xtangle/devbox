#!/usr/bin/env bash

set -e

# configure debconf to use a frontend that expects no interactive input
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

# shellcheck disable=SC1090
source "${HOME}/.provision/scripts/bootstrap/bootstrap.sh"

run "${@}"
