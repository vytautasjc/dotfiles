{ config, pkgs, ... }:

let
  # Helper to avoid repeating the check-and-link logic for the mount
  mkLinkScript = src: target: ''
    if [ ! -e "${src}" ]; then
      echo "Creating link: ${src} -> ${target}"
      mkdir -p "$(dirname "${src}")"
      mkdir -p "${target}"
      ln -s "${target}" "${src}"
    fi
  '';
  
  homeDir = config.home.homeDirectory;
  dotfilesDir = "${homeDir}/dotfiles"; # Adjust if your dotfiles are elsewhere
in {
  imports = [
    ../modules/common.nix
    ../modules/zsh.nix
    ../modules/ai.nix
    ../modules/node.nix
    ../modules/agents.nix
  ];

  home.activation = {
    # Logic for persistent Lima-VM configs
    setupDataLinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      MOUNT="${dataMountPath}"
      if [ -z "$MOUNT" ]; then 
        echo "Warning: DATA_MOUNT_PATH is empty, skipping mount links."
      else
        # Development and Configs
        ${mkLinkScript "${homeDir}/development" "$MOUNT/development"}
        ${mkLinkScript "${homeDir}/.config/codex" "$MOUNT/config/codex"}
        ${mkLinkScript "${homeDir}/.config/claude" "$MOUNT/config/claude"}
        ${mkLinkScript "${homeDir}/.config/gemini" "$MOUNT/config/gemini"}

        # JetBrains
        ${mkLinkScript "${homeDir}/.config/JetBrains" "$MOUNT/config/JetBrains/config"}
        ${mkLinkScript "${homeDir}/.local/share/JetBrains" "$MOUNT/config/JetBrains/local"}
        ${mkLinkScript "${homeDir}/.cache/JetBrains" "$MOUNT/config/JetBrains/cache"}
      fi
    '';
  };
}
