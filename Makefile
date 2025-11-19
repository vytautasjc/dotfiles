SHELL := /bin/zsh

# repo root (no trailing slash)
REPO_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
ZSH_SRC := $(REPO_DIR)/zsh

$(info REPO_DIR=$(REPO_DIR))
$(info ZSH_SRC=$(ZSH_SRC))

ZSHENV_FILES := $(ZSH_SRC)/.zshenv $(HOME)/.zshenv

define read_zshenv_var
$(strip $(shell \
	for f in $(ZSHENV_FILES); do \
		[ -f $$f ] || continue; \
		. $$f >/dev/null 2>&1; \
		val="$${$(1)}"; \
		if [ -n "$$val" ]; then \
			echo "$$val"; \
			break; \
		fi; \
	done))
endef

ifeq ($(XDG_CONFIG_HOME),)
	XDG_CONFIG_HOME := $(call read_zshenv_var,XDG_CONFIG_HOME)
endif

# fallback
XDG_CONFIG_HOME ?= $(HOME)/.config

$(info XDG_CONFIG_HOME=$(XDG_CONFIG_HOME))

ifeq ($(CODEX_HOME),)
	CODEX_HOME := $(call read_zshenv_var,CODEX_HOME)
endif

# fallback
CODEX_HOME ?= $(XDG_CONFIG_HOME)/codex

$(info CODEX_HOME=$(CODEX_HOME))

.PHONY: all zsh git

all: zsh git codex

# list of files in zsh/ (basename only)
ZSH_FILES := $(notdir $(wildcard $(ZSH_SRC)/*))

zsh:
	@mkdir -p "$(XDG_CONFIG_HOME)" "$(XDG_CONFIG_HOME)/zsh"
	@touch "$(HOME)/.hushlogin"
	@echo "Linking zsh files from $(ZSH_SRC) -> $(XDG_CONFIG_HOME)/zsh"
	
	@for f in $(ZSH_SRC)/*(N) $(ZSH_SRC)/.[!.]*(N) $(ZSH_SRC)/..?*(N); do \
		[ -e "$$f" ] || continue; \
		if [ -d "$$f" ]; then continue; fi; \
		base=$$(basename "$$f"); \
		ln -sf "$$f" "$(XDG_CONFIG_HOME)/zsh/$$base"; \
	done
	
	@ln -sf "$(REPO_DIR)/.aliases" "$(XDG_CONFIG_HOME)/.aliases"
	@ln -sf "$(REPO_DIR)/zsh/.zshenv" "$(HOME)/.zshenv"

	@echo "zsh files linked"

git: zsh
	@mkdir -p "$(XDG_CONFIG_HOME)/git"
	@ln -sf "$(REPO_DIR)/git/.gitignore_global" "$(XDG_CONFIG_HOME)/git/.gitignore_global"
	@git config --global core.excludesfile "$(XDG_CONFIG_HOME)/git/.gitignore_global"
	
	@echo "git files linked"

codex: zsh
	@mkdir -p "$(CODEX_HOME)"
	@ln -sf "$(REPO_DIR)/codex/codex.toml" "$(CODEX_HOME)/codex.toml"
	
	@echo "codex files linked"
