setopt AUTO_CD                          # Go to folder path without using cd.

setopt AUTO_PUSHD                       # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS                # Do not store duplicates in the stack.
setopt PUSHD_SILENT                     # Do not print the directory stack after pushd or popd.

setopt CORRECT                          # Spelling correction
setopt CDABLE_VARS                      # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB                    # Use extended globbing syntax.

# Set the theme (Options: dracula, molokai, gruvbox, iceberg, snazzy)
export LS_THEME="dracula"

if command -v dircolors > /dev/null; then
  eval "$(dircolors -b)"
fi

source $XDG_CONFIG_HOME/zsh/history.zsh
source $XDG_CONFIG_HOME/zsh/autocomplete.zsh
source $XDG_CONFIG_HOME/zsh/prompt.zsh
source $XDG_CONFIG_HOME/zsh/node.zsh
source $XDG_CONFIG_HOME/zsh/sdkman.zsh
source $XDG_CONFIG_HOME/zsh/nix.zsh
source $XDG_CONFIG_HOME/zsh/tmux.zsh

source $XDG_CONFIG_HOME/.aliases
