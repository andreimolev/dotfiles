#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
set -euo pipefail

is_app_installed() {
#  type "$1" &>/dev/null
  brew ls --versions "$1" > /dev/null
}

install_app() {
  printf "$1: Checking if app is installed...\n"
  if ! is_app_installed "$1"; then
    echo "$1 is not found. Installing one...\n"
    brew install $1
  fi
}

install_app "ack"
install_app "coreutils"
install_app "moreutils"
install_app "findutils"
install_app "wget"
install_app "grep"
install_app "git"
install_app "imagemagick"
install_app "p7zip"
install_app "unrar"
install_app "youtube-dl"
install_app "socat"
install_app "flux"

install_app "vim"
install_app "the_silver_searcher"
install_app "ctags"
install_app "reattach-to-user-namespace"

install_app "nano"

install_app "tmux"

install_app "zsh"
