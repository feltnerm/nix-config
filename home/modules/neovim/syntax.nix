{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.neovim.syntax;

  syntaxPlugins = with pkgs.vimPlugins; [
    kotlin-vim
    rust-vim
    vim-markdown
    vim-nix
    vim-toml
  ];
in {
  options.feltnerm.neovim.syntax = {
    enable = lib.mkEnableOption "neovim syntax";
  };

  config = {
    programs.neovim.plugins = lib.mkIf cfg.enable syntaxPlugins;
  };
}
