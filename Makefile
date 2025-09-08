CURRENT_DIR = $(shell cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

setup-all: setup-zsh setup-git

setup-zsh:
	ln -sf $(CURRENT_DIR)/zsh/.zshenv $(HOME)/.zshenv

	. ${HOME}/.zshenv

	touch ${HOME}/.hushlogin
	mkdir -p ${XDG_CONFIG_HOME}

	mkdir -p ${XDG_CONFIG_HOME}/zsh

	ln -sf $(CURRENT_DIR)/.aliases ${XDG_CONFIG_HOME}/.aliases
	ln -sf $(CURRENT_DIR)/zsh/.zshrc ${XDG_CONFIG_HOME}/zsh/.zshrc
	ln -sf $(CURRENT_DIR)/zsh/.zprofile ${XDG_CONFIG_HOME}/zsh/.zprofile
	ln -sf $(CURRENT_DIR)/zsh/autocomplete.zsh ${XDG_CONFIG_HOME}/zsh/autocomplete.zsh
	ln -sf $(CURRENT_DIR)/zsh/prompt.zsh ${XDG_CONFIG_HOME}/zsh/prompt.zsh
	ln -sf $(CURRENT_DIR)/zsh/history.zsh ${XDG_CONFIG_HOME}/zsh/history.zsh

	. ${XDG_CONFIG_HOME}/zsh/.zshrc

setup-git: setup-zsh
	mkdir -p ${XDG_CONFIG_HOME}/git

	ln -sf $(CURRENT_DIR)/git/.gitignore_global ${XDG_CONFIG_HOME}/git/.gitignore_global
	git config --global core.excludesfile ${XDG_CONFIG_HOME}/git/.gitignore_global