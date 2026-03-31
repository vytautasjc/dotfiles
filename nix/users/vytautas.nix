{ config, pkgs, ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/zsh.nix
  ];
}
