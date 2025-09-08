CURRENT_DIR = $(shell cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Load XDG_CONFIG_HOME from .zshenv
ifneq ($(wildcard $(CURRENT_DIR)/.zshenv),)
    XDG_CONFIG_HOME := $(shell . $(HOME)/.zshenv && echo $$XDG_CONFIG_HOME)
endif

# Fallback if not set
XDG_CONFIG_HOME ?= $(HOME)/.config

setup-all: setup-zsh setup-git

setup-zsh:
	touch ${HOME}/.hushlogin
	mkdir -p $$XDG_CONFIG_HOME $$XDG_CONFIG_HOME/zsh

	ln -sf $(CURRENT_DIR)/zsh/.zshenv $(HOME)/.zshenv
	ln -sf $(CURRENT_DIR)/.aliases $$XDG_CONFIG_HOME/.aliases
	ln -sf $(CURRENT_DIR)/zsh/.zshrc $$XDG_CONFIG_HOME/zsh/.zshrc
	ln -sf $(CURRENT_DIR)/zsh/.zprofile $$XDG_CONFIG_HOME/zsh/.zprofile
	ln -sf $(CURRENT_DIR)/zsh/autocomplete.zsh $$XDG_CONFIG_HOME/zsh/autocomplete.zsh
	ln -sf $(CURRENT_DIR)/zsh/prompt.zsh $$XDG_CONFIG_HOME/zsh/prompt.zsh
	ln -sf $(CURRENT_DIR)/zsh/history.zsh $$XDG_CONFIG_HOME/zsh/history.zsh

setup-git: setup-zsh
	mkdir -p $$XDG_CONFIG_HOME/git

	ln -sf $(CURRENT_DIR)/git/.gitignore_global $$XDG_CONFIG_HOME/git/.gitignore_global
	git config --global core.excludesfile $$XDG_CONFIG_HOME/git/.gitignore_global