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

convert_time() {
    local t=$1

    local d=$((t/1000/60/60/24))
    local h=$((t/1000/60/60%24))
    local m=$((t/1000/60%60))
    local s=$((t/1000%60))
    local ms=$((t%1000))

    if [[ $d -gt 0 ]]; then
        echo -n " ${d}d"
    fi

    if [[ $h -gt 0 ]]; then
        echo -n " ${h}h"
    fi

    if [[ $m -gt 0 ]]; then
        echo -n " ${m}m"
    fi

    if [[ $s -gt 0 ]]; then
      echo -n " ${s}s"
    fi

    if [[ $ms -gt 0 ]]; then
      echo -n " ${ms}ms"
    fi
    
    echo
}

precmd() {
    if [ $timer ]; then
        now=$(($(print -P %D{%s%6.})/1000))
        timer_elapsed=$((now - timer))
        converted_time=$(convert_time "$timer_elapsed")

        medium_gray="%F{240}"
        print -P ''
        print -P "${medium_gray}$(date '+%a %b %d, %T'), took${converted_time}%f"
        print -P ''
        unset timer
    fi
}

preexec() {
    timer=$(($(print -P %D{%s%6.})/1000))
}

prompt_setup() {
    prompt_git_branch

    NEWLINE=$'\n'

    RPROMPT=""
    PROMPT='$(path_label) $(vcs_label)${NEWLINE}> '
}

prompt_setup