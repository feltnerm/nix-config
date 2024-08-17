{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.neovim.telescope;

  telescopeConfig = builtins.readFile ./telescope-nvim.lua;
in {
  options.feltnerm.neovim.telescope = {
    enable = lib.mkEnableOption "neovim telescope";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        type = "lua";
        config = telescopeConfig;
      }
      {
        plugin = telescope-file-browser-nvim;
        type = "lua";
        config = ''
          require("telescope").load_extension "file_browser"
          vim.keymap.set("n", "<leader>pd", require "telescope".extensions.file_browser.file_browser, {})
        '';
      }
    ];
  };
}
