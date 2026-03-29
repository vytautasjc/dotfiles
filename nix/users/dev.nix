{ config, pkgs, ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/zsh.nix
  ];

  home.packages = with pkgs; [
    lima
  ];
}
