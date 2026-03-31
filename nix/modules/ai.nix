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
  xdg.configFile = {
    "claude/settings.json".source = mkLink "${dotfiles}/claude/settings.json";
    "gemini/settings.json".source = mkLink "${dotfiles}/gemini/settings.json";
    "codex/config.toml".source = mkLink "${dotfiles}/codex/config.toml";
  };
}
