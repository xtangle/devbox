#!/usr/bin/env bash

set -e

if ! installed kotlinc; then
  sudo snap install kotlin --classic
fi
