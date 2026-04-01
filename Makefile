SHELL := /bin/zsh

# repo root (no trailing slash)
REPO_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
ZSH_SRC := $(REPO_DIR)/zsh
ZSH_DEST := $(XDG_CONFIG_HOME)/zsh

$(info REPO_DIR=$(REPO_DIR))
$(info ZSH_SRC=$(ZSH_SRC))
$(info ZSH_DEST=$(ZSH_DEST))

ZSHENV_FILES := $(wildcard $(ZSH_SRC)/.zshenv $(HOME)/.zshenv)
CACHE_FILE := .env.cache

# Include the cache if it exists
-include $(CACHE_FILE)

# Rule to generate the cache ONLY when .zshenv changes
$(CACHE_FILE): $(ZSHENV_FILES)
	@echo "Regenerating $(CACHE_FILE)..."
	@echo "# Auto-generated config" > $@
	@for f in $(ZSHENV_FILES); do . $$f >/dev/null 2>&1; done; \
	 echo "XDG_CONFIG_HOME=$${XDG_CONFIG_HOME:-$(HOME)/.config}" >> $@; \
	 echo "CLAUDE_CONFIG_DIR=$${CLAUDE_CONFIG_DIR:-$${XDG_CONFIG_HOME:-$(HOME)/.config}/claude}" >> $@; \
	 echo "GEMINI_CONFIG_DIR=$${GEMINI_CONFIG_DIR:-$${XDG_CONFIG_HOME:-$(HOME)/.config}/gemini}" >> $@; \
	 echo "CODEX_CONFIG_DIR=$${CODEX_HOME:-$${XDG_CONFIG_HOME:-$(HOME)/.config}/codex}" >> $@

# Force Make to check the cache file at startup
$(ZSHENV_FILES): ;

# Fallbacks in case the cache hasn't been built yet (first run)
XDG_CONFIG_HOME   ?= $(HOME)/.config
CLAUDE_CONFIG_DIR ?= $(XDG_CONFIG_HOME)/claude
GEMINI_CONFIG_DIR ?= $(XDG_CONFIG_HOME)/gemini
CODEX_CONFIG_DIR  ?= $(XDG_CONFIG_HOME)/codex

$(info XDG_CONFIG_HOME   = $(XDG_CONFIG_HOME))
$(info CLAUDE_CONFIG_DIR  = $(CLAUDE_CONFIG_DIR))
$(info GEMINI_CONFIG_DIR  = $(GEMINI_CONFIG_DIR))
$(info CODEX_CONFIG_DIR   = $(CODEX_CONFIG_DIR))

.PHONY: all zsh git claude gemini codex tmux

all: zsh git claude gemini codex tmux

hushlogin:
	@touch "$(HOME)/.hushlogin"

$(XDG_CONFIG_HOME)/.aliases: $(REPO_DIR)/.aliases
	@ln -sf $(realpath $<) $@

zsh: hushlogin $(XDG_CONFIG_HOME)/.aliases
	@mkdir -p "$(XDG_CONFIG_HOME)" "$(XDG_CONFIG_HOME)/zsh"
	
	@echo "Linking zsh files from $(ZSH_SRC) -> $(ZSH_DEST)"
	
	@echo "Mirroring $(ZSH_SRC) -> $(ZSH_DEST)"
	
	@mkdir -p "$(ZSH_DEST)"
	@find "$(ZSH_SRC)" -type f | while read -r src; do \
		rel_path=$${src#$(ZSH_SRC)/}; \
		dest_path="$(ZSH_DEST)/$$rel_path"; \
		mkdir -p "$$(dirname "$$dest_path")"; \
		ln -sf "$$src" "$$dest_path"; \
		echo "Linked $$rel_path"; \
	done

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

	@echo "claude files linked"

gemini: zsh
	@mkdir -p "$(GEMINI_CONFIG_DIR)"

	@if [ -f "$(GEMINI_CONFIG_DIR)/settings.json" ]; then \
		mv "$(GEMINI_CONFIG_DIR)/settings.json" "$(GEMINI_CONFIG_DIR)/settings.json.bak"; \
	fi

	@ln -sf "$(REPO_DIR)/gemini/settings.json" "$(GEMINI_CONFIG_DIR)/settings.json"

	@echo "gemini files linked"

codex: zsh
	@mkdir -p "$(CODEX_CONFIG_DIR)"

	@if [ -f "$(CODEX_CONFIG_DIR)/config.toml" ]; then \
		mv "$(CODEX_CONFIG_DIR)/config.toml" "$(CODEX_CONFIG_DIR)/config.toml.bak"; \
	fi

	@ln -sf "$(REPO_DIR)/codex/config.toml" "$(CODEX_CONFIG_DIR)/config.toml"

	@echo "codex files linked"

tmux: zsh
	@mkdir -p "$(XDG_CONFIG_HOME)/tmux"

	@ln -sf "$(REPO_DIR)/tmux/tmux.conf" "$(XDG_CONFIG_HOME)/tmux/tmux.conf"

	@echo "tmux files linked"