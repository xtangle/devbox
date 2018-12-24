#!/usr/bin/env bash

# configure debconf to use a frontend that expects no interactive input
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

source ${HOME}/vagrant-scripts/bootstrap/bootstrap.sh
bootstrap

reset_results_file

run configure-mounts.sh
run configure-system.sh
run configure-desktop.sh
run configure-panels.sh
run configure-screensaver.sh
run configure-autologin.sh
run configure-pcmanfm.sh
run configure-scaling.sh

run install-java.sh
run install-maven.sh
run install-nvm.sh
run install-sbt.sh
run install-kotlin.sh
run install-ruby.sh
run install-go.sh
run install-haskell.sh

run install-git.sh
run install-docker.sh
run install-fonts.sh
run install-tilda.sh
run install-postman.sh
run install-chrome.sh
run install-sublime.sh
run install-intellij.sh
run install-vscode.sh
run install-misc.sh

print_results
