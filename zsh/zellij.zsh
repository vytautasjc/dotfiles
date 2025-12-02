# Autostart Zellij
if [[ -z "$ZELLIJ" ]] && [[ -n "$PS1" ]] && [[ "$TERM" != "dumb" ]]; then
    if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
        exec zellij attach -c
    else
        exec zellij
    fi
fi