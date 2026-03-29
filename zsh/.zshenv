export PATH="$PATH:$HOME/bin"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export GEMINI_CONFIG_DIR="$XDG_CONFIG_HOME/gemini"

export EDITOR="nvim"
export VISUAL="nvim"

export DOTFILES="$HOME/dotfiles"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [ -s "$HOME/.zshenv.local" ]; then
    . "$HOME/.zshenv.local"
fi
