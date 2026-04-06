export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
export PNPM_CONF_GLOBAL_BIN_DIR="$PNPM_HOME"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export GEMINI_CONFIG_DIR="$XDG_CONFIG_HOME/gemini"

export EDITOR="nvim"
export VISUAL="nvim"

export DOTFILES="$HOME/dotfiles"

# Used by multi-user Nix setup
export NIX_REMOTE=daemon

export TMUX_AUTO_EXIT=true

ZDOTDIR="$XDG_CONFIG_HOME/zsh"

typeset -U path PATH

path=(
  "$PNPM_HOME"
  "$HOME/bin"
  "$HOME/.local/bin"
  "${XDG_DATA_HOME:-$HOME/.local/share}/fnm"
  $path
)

export PATH

if [ -s "$HOME/.zshenv.local" ]; then
    . "$HOME/.zshenv.local"
fi
