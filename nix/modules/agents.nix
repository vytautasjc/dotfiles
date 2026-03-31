{ config, pkgs, lib, ... }:
{

  home.activation = {
    installGlobalAgents = lib.hm.dag.entryAfter ["bootstrapNode"] ''
      export PATH="${pkgs.fnm}/bin:${pkgs.corepack}/bin:$PATH"
      eval "$(fnm env --use-on-cd)"

      # Tell corepack where to store pnpm/yarn binaries so they don't 
      # get wiped if the VM's temporary storage clears.
      export COREPACK_HOME="$HOME/.cache/corepack"

      if command -v node > /dev/null; then
        echo "Enabling Corepack..."
        corepack enable
        
        pnpm install -g @openai/codex @anthropic-ai/claude-code @google/gemini-cli
      fi
    '';
  };
}