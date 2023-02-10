{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.telescope;

  telescopeConfig = builtins.readFile ./telescope-nvim.lua;

  telescopePlugins = with pkgs.vimPlugins; [
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
in {
  options.feltnerm.programs.neovim.telescope = {
    enable = lib.mkOption {
      description = "Enable neovim telescope.";
      default = false;
    };
  };
  config = {
    programs.neovim.plugins = lib.mkIf cfg.enable telescopePlugins;
  };
}
