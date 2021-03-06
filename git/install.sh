#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

printf "Copy configuration to ~/.gitconfig\n"

ln -sf "$DOTFILES"/git/gitconfig ~/.gitconfig

printf "OK: Completed\n"
