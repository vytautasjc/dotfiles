{ config, pkgs, ... }:

let
  # Helper to avoid repeating the check-and-link logic for the mount
  # Logic:
  # 1. Check if the ACTUAL DATA (target) exists. If not, do nothing.
  # 2. If target exists, check if the SYMLINK (linkName) already exists.
  # 3. If linkName is missing, ensure its parent directory exists.
  # 4. Create the symlink.
  mkLink = target: linkName: ''
    if [ -e "${target}" ]; then
      if [ ! -e "${linkName}" ] && [ ! -L "${linkName}" ]; then
        echo "Target ${target} found. Linking ${linkName} -> ${target}"
        
        # Ensure the folder containing the link exists (e.g., ~/.config/app/)
        mkdir -p "$(dirname "${linkName}")"
        
        ln -s "${target}" "${linkName}"
      fi
    else
      echo "Target ${target} not found. Skipping link creation for ${linkName}."
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
        ${mkLink "$MOUNT/config/.zshenv.local" "${homeDir}/.zshenv.local"}
        ${mkLink "$MOUNT/config/ssh/config" "${homeDir}/.ssh/config"}
        ${mkLink "$MOUNT/config/.gitconfig" "${homeDir}/.gitconfig"}
        ${mkLink "$MOUNT/development" "${homeDir}/development"}
        ${mkLink "$MOUNT/config/codex" "${homeDir}/.config/codex"}
        ${mkLink "$MOUNT/config/claude" "${homeDir}/.config/claude"}
        ${mkLink "$MOUNT/config/gemini" "${homeDir}/.config/gemini"}

        # JetBrains
        ${mkLink "$MOUNT/config/JetBrains/config" "${homeDir}/.config/JetBrains"}
        ${mkLink "$MOUNT/config/JetBrains/local" "${homeDir}/.local/share/JetBrains"}
        ${mkLink "$MOUNT/config/JetBrains/cache" "${homeDir}/.cache/JetBrains"}
      fi
    '';
  };
}
