if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]] || [[ -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    export INTELLIJ_TERMINAL=1
fi

# Auto-start tmux and attach to existing session (but not in IntelliJ)
if [[ -z "$INTELLIJ_TERMINAL" ]] && command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  if [[ "$TMUX_AUTO_EXIT" == "true" ]]; then
    # Exit terminal completely when tmux exits
    exec tmux new-session
  else
    # Return to parent zsh when tmux exits
    tmux new-session
  fi
fi