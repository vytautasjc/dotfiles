#!/usr/bin/env bash

set -euo pipefail

# Script's directory (absolute path, resolves symlinks too)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"


ln -sf $SCRIPT_DIR/.aliases $XDG_CONFIG_HOME/.aliases
ln -sf $SCRIPT_DIR/zsh/.zshenv $HOME/.zshenv
ln -sf $SCRIPT_DIR/zsh/.zshrc $XDG_CONFIG_HOME/zsh/.zshrc
