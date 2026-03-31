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
  home.file.".hushlogin".text = "";
  home.stateVersion = "25.11";

  # Standard XDG paths
  xdg.enable = true;

  programs.home-manager.enable = true;

  # Standard Packages
  home.packages = with pkgs; [
    git
    tmux
    neovim
  ];

  # Shared Variables
  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES = dotfiles;
  };

  xdg.configFile = {
    "tmux/tmux.conf".source = mkLink "${dotfiles}/tmux/tmux.conf";
    ".aliases".source = mkLink "${dotfiles}/.aliases";
  };
}
