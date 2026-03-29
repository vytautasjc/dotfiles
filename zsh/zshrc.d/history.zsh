autoload -Uz add-zsh-hook

setopt HIST_SAVE_NO_DUPS                # Do not write a duplicate event to the history file.
setopt EXTENDED_HISTORY                 # Write the history file in the ':start:elapsed;command' format.

setopt NO_SHARE_HISTORY                 # Prevent interferring with EXTENDED_HISTORY to record elapsed time.
setopt NO_INC_APPEND_HISTORY             # Does not store elapsed time since it records commands right after starting execution.

setopt INC_APPEND_HISTORY_TIME          # Use this instead of SHARE_HISTORY to write to the history file (without reading).
setopt HIST_EXPIRE_DUPS_FIRST           # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS                 # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS             # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS                # Do not display a previously found event.
setopt HIST_IGNORE_SPACE                # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS                # Do not write a duplicate event to the history file.
setopt HIST_VERIFY                      # Do not execute immediately upon history expansion.

read-history() {
    fc -R
}

add-zsh-hook precmd read-history

autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[OA" history-beginning-search-backward-end

bindkey "^[[B" history-beginning-search-forward-end
bindkey "^[OB" history-beginning-search-forward-end