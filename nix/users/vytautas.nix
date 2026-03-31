{ config, pkgs, ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/zsh.nix
    ../modules/ai.nix
  ];
}
