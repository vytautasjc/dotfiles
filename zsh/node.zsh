export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    export NVM_SYMLINK_CURRENT=true;

    . "$NVM_DIR/nvm.sh" --no-use # This loads nvm, without auto-using the default version

    NODE_VER=$(nvm version default 2>/dev/null)

    if [[ -n "$NODE_VER" && "$NODE_VER" != "N/A" ]]; then
        export PATH="$XDG_CONFIG_HOME/nvm/versions/node/$NODE_VER/bin:$PATH"
    fi

    autoload -U add-zsh-hook

    nvm-switch() {
        local node_version="$(nvm version)"
        local nvmrc_path="$(nvm_find_nvmrc)"
        local switch_to_default=false;

        if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

            if [ "$nvmrc_node_version" = "N/A" ]; then
                nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
                nvm use
            fi
        elif [ "$switch_to_default" = true ] && [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi

        # Create a symlink to current node binary, useful when configuring IDEs to use project's node version
        mkdir -p $HOME/bin
        ln -sf $NVM_DIR/current/bin/node $HOME/bin/node-current
    }

    add-zsh-hook chpwd nvm-switch

    nvm-switch
fi
