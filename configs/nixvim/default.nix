{ lib, ... }:
{
  colorschemes.base16 = {
    enable = lib.mkDefault true;
    colorscheme = "gruvbox-dark-hard";
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  plugins = {
    lsp.enable = true;
    blink-cmp.enable = true;
  };

}
