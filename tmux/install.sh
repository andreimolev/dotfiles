#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error when substituting.
set -euo pipefail

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
 at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

printf "Copy configuration to ~/.tmux.conf\n"

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
  cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true
fi

ln -sf "$DOTFILES"/tmux/renew_env.sh "$HOME"/.tmux/renew_env.sh
ln -sf "$DOTFILES"/tmux/yank.sh "$HOME"/.tmux/yank.sh
ln -sf "$DOTFILES"/tmux/tmux.conf "$HOME"/.tmux/tmux.conf
ln -sf "$DOTFILES"/tmux/tmux.remote.conf "$HOME"/.tmux/tmux.remote.conf
ln -sf .tmux/tmux.conf "$HOME"/.tmux.conf;

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

printf "OK: Completed\n"
