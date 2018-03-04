#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
set -euo pipefail

printf "Copy configuration to ~/.zshrc\n"

if [ -e "$HOME/.zshrc" ]; then
  printf "Found existing .zshrc in your \$HOME directory. Will create a backup at $HOME/.zshrc.bak\n"
  cp -f "$HOME/.zshrc" "$HOME/.zshrc.bak" 2>/dev/null || true
fi

ln -sf "$DOTFILES"/zsh/zshrc "$HOME"/.zshrc

printf "OK: Completed\n"
