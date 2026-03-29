if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]] || [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    export INTELLIJ_TERMINAL=1
fi

export TMUX_AUTO_EXIT=true

# Auto-start tmux and attach to existing session (but not in IntelliJ)
if [[ -z "$INTELLIJ_TERMINAL" ]] && command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  if [[ "$TMUX_AUTO_EXIT" == "true" ]]; then
    # Exit terminal completely when tmux exits
    exec tmux new-session -A -s main
  else
    # Return to parent zsh when tmux exits
    tmux new-session -A -s main
  fi
fi