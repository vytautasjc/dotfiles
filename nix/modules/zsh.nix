{
  config,
  pkgs,
  ...
}:
let
  mkLink = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  home.file = {
    ".zshenv".source = mkLink "${dotfiles}/zsh/.zshenv";
    ".zprofile".source = mkLink "${dotfiles}/zsh/.zprofile";
  };

  home.packages = with pkgs; [
    zsh
  ];

  xdg.configFile."zsh".source = mkLink "${dotfiles}/zsh";
}
