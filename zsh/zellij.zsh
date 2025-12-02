export ZELLIJ_AUTO_EXIT=true

# Autostart Zellij
if [[ -z "$ZELLIJ" ]] && [[ -n "$PS1" ]] && [[ "$TERM" != "dumb" ]]; then
    if command -v zellij &> /dev/null; then
        if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
            zellij attach -c
        else
            zellij
        fi

        # Exit shell when zellij exits
        if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
            exit
        fi
    fi
fi