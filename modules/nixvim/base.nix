# Base nixvim configuration
# Core editor settings and essential plugins
{ ... }:
{
  # Basic settings
  opts = {
    number = true;
    relativenumber = true;
    cursorline = true;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    smartindent = true;
    wrap = false;
    termguicolors = true;
  };

  # Leader key
  globals.mapleader = " ";

  # Basic plugins
  plugins = {
    # File explorer
    neo-tree.enable = true;

    # Status line
    lualine.enable = true;

    # Fuzzy finder
    telescope.enable = true;

    # Syntax highlighting
    treesitter.enable = true;

    # Auto-save
    auto-save.enable = true;

    # Surround
    nvim-surround.enable = true;

    # Comments
    commentary.enable = true;

    # Which-key for keymap hints
    which-key.enable = true;
  };

  # Keymaps
  keymaps = [
    {
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options.desc = "toggle file explorer";
    }
    {
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "find files";
    }
    {
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "live grep";
    }
    {
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "find buffers";
    }
  ];
}
