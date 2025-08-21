# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)


prompt_git_branch() {
    autoload -Uz vcs_info 
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    zstyle ':vcs_info:git:*' formats '%b'
}

vcs_label() {
    if [[ -n $vcs_info_msg_0_ ]]; then
        echo "%F{red}λ%f:${vcs_info_msg_0_}%f"
    fi
}

path_label() {
    echo "%F{blue}%B%~%b%f"
}

prompt_setup() {
    prompt_git_branch

    NEWLINE=$'\n'

    RPROMPT=""
    PROMPT='$(path_label) $(vcs_label)${NEWLINE}> '
}

prompt_setup