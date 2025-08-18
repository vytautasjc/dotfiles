#!/usr/bin/env bash

set -euo pipefail

# Script's directory (absolute path, resolves symlinks too)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

### SSH

ln -sf $SCRIPT_DIR/ssh/config $HOME/.ssh/config

### ZSH

ln -sf $SCRIPT_DIR/.aliases $XDG_CONFIG_HOME/.aliases
ln -sf $SCRIPT_DIR/zsh/.zshenv $HOME/.zshenv
ln -sf $SCRIPT_DIR/zsh/.zshrc $XDG_CONFIG_HOME/zsh/.zshrc
ln -sf $SCRIPT_DIR/zsh/.zprofile $XDG_CONFIG_HOME/zsh/.zprofile
ln -sf $SCRIPT_DIR/zsh/autocomplete.zsh $XDG_CONFIG_HOME/zsh/autocomplete.zsh
ln -sf $SCRIPT_DIR/zsh/prompt.zsh $XDG_CONFIG_HOME/zsh/prompt.zsh

### MISC

touch $HOME/.hushlogin