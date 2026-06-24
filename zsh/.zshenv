export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"

export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export GEMINI_CONFIG_DIR="$XDG_CONFIG_HOME/gemini"

export EDITOR="nvim"
export VISUAL="nvim"

export DOTFILES="$HOME/dotfiles"

# Used by multi-user Nix setup
export NIX_REMOTE=daemon

export TMUX_AUTO_EXIT=true

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# POSIX compatible
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$PNPM_HOME/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$XDG_DATA_HOME/fnm"

export PATH

if [ -s "$HOME/.zshenv.local" ]; then
    . "$HOME/.zshenv.local"
fi
