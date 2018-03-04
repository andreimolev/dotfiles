#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
set -euo pipefail

printf "vim: Linking configuration files\n"

mkdir -p "$DOTFILES"/vim/vim
mkdir -p "$DOTFILES"/vim/bundle

ln -sf "$DOTFILES"/vim/bundle "$DOTFILES"/vim/vim/bundle
ln -sf "$DOTFILES"/vim/maximum-awesome/vim/plugin "$DOTFILES"/vim/vim/plugin
ln -sf "$DOTFILES"/vim/maximum-awesome/vim/snippets "$DOTFILES"/vim/vim/snippets

ln -sf "$DOTFILES"/vim/vim "$HOME"/.vim
ln -sf "$DOTFILES"/vim/vimrc "$HOME"/.vimrc
ln -sf "$DOTFILES"/vim/vimrc.local "$HOME"/.vimrc.local
ln -sf "$DOTFILES"/vim/vimrc.bundles "$HOME"/.vimrc.bundles
ln -sf "$DOTFILES"/vim/vimrc.bundles.local "$HOME"/.vimrc.bundles.local

# Vundle
git clone https://github.com/VundleVim/Vundle.vim "$DOTFILES"/vim/bundle/Vundle.vim
vim -c "PluginInstall!" -c "q" -c "q"

printf "vim: OK: Completed\n"

