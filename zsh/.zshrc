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

# Source modular configs in alphanumeric order
# (-.N) is a Zsh glob qualifier:
#   -  : follow symlinks
#   .  : only regular files
#   N  : sets NULL_GLOB (don't error if directory is empty)
for file in "$ZDOTDIR"/zshrc.d/[0-9][0-9]-*.zsh(-.N); do
  source "$file"
done

source $XDG_CONFIG_HOME/.aliases
