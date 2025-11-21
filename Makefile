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

.PHONY: all zsh git

ifeq ($(CLAUDE_CONFIG_DIR),)
	CLAUDE_CONFIG_DIR := $(call read_zshenv_var,CLAUDE_CONFIG_DIR)
endif

# fallback
CLAUDE_CONFIG_DIR ?= $(XDG_CONFIG_HOME)/claude

$(info CLAUDE_CONFIG_DIR=$(CLAUDE_CONFIG_DIR))

.PHONY: all zsh git

all: zsh git

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

claude: zsh
	@mkdir -p "$(CLAUDE_CONFIG_DIR)"

	@ln -sf "$(REPO_DIR)/claude/settings.json" "$(CLAUDE_CONFIG_DIR)/settings.json"