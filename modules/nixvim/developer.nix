# Developer nixvim configuration
# LSP, debugging, git integration, and development tooling
{ ... }:
{
  # Enable LSP
  plugins.lsp.enable = true;

  # Enable completion
  plugins.blink-cmp.enable = true;

  # Git integration
  plugins.fugitive.enable = true;
  plugins.gitblame.enable = true;
  plugins.gitgutter.enable = true;

  # Better diagnostics
  plugins.trouble.enable = true;

  # Debugging
  plugins.dap.enable = true;
  plugins.dap-virtual-text.enable = true;
  plugins.dap-ui.enable = true;

  # Project management
  plugins.project-nvim.enable = true;

  # Snacks for better UI
  plugins.snacks = {
    enable = true;
    settings = {
      input.enabled = true;
      picker.enabled = true;
      terminal.enabled = true;
    };
  };

  # Treesitter with all grammars
  plugins.treesitter.enable = true;

  # Which-key for keymap hints
  plugins.which-key.enable = true;

  # LSP keymaps
  keymaps = [
    {
      key = "<leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      options.desc = "code action";
    }
    {
      key = "<leader>cr";
      action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      options.desc = "rename symbol";
    }
    {
      key = "<leader>cf";
      mode = [ "n" "v" ];
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "format buffer/selection";
    }
    {
      key = "<leader>cd";
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      options.desc = "line diagnostics";
    }
  ];

  # LSP servers
  plugins.lsp.servers = {
    bashls.enable = true;
    cssls.enable = true;
    html.enable = true;
    jsonls.enable = true;
    lua_ls.enable = true;
    marksman.enable = true;
    nil_ls.enable = true;
    rust_analyzer.enable = true;
    ts_ls.enable = true;
    vimls.enable = true;
    yamlls.enable = true;
  };

  # Blink-cmp configuration
  plugins.blink-cmp.settings = {
    appearance.nerd_font_variant = "mono";
    sources.default = [
      "lsp"
      "snippets"
      "path"
      "buffer"
    ];
    completion.documentation.auto_show = true;
    keymap.preset = "enter";
  };
}
