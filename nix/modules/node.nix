{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fnm
    corepack
  ];

  home.activation = {
    bootstrapNode = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Setup PATH for the script
      export PATH="${pkgs.fnm}/bin:${pkgs.corepack}/bin:$PATH"
      
      # Initialize fnm
      eval "$(fnm env --use-on-cd)"

      # Install Node if missing
      if ! fnm ls | grep -q "default"; then
        echo "Bootstrapping Node LTS with fnm..."
        fnm install --lts
        fnm default lts
      fi
    '';
  };
}