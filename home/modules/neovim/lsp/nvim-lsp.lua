-- https://github.com/neovim/nvim-lspconfig#suggested-configuration
local lspconfig = require('lspconfig')
local opts = { noremap=true, silent=true, desc="lsp" }

function add_lsp(binary, server, options)
  if vim.fn.executable(binary) == 1 then server.setup(options) end
end

vim.keymap.set('n', '<space>ce', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr, desc="code" }
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>cgD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>cgd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>cgi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>cgr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>cD', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
add_lsp("bash-language-server", lspconfig.bashls, {})
add_lsp("efm-langserver", lspconfig.efm, {})
add_lsp("gopls", lspconfig.gopls, {})
add_lsp("gradle-language-server", lspconfig.efm, {})
add_lsp("jdt-language-server", lspconfig.jdtls, { cmd = { "jdt-language-server" } })
add_lsp("kotlin-language-server", lspconfig.kotlin_language_server, {})
add_lsp("nil", lspconfig.nil_ls, {})
add_lsp("pyright", lspconfig.pylsp, {})
add_lsp("rust_analyzer", lspconfig.rust_analyzer, {})
add_lsp("ltex-ls", lspconfig.ltex, { lang = { "en-US" } })
-- require('lspconfig')['pyright'].setup{
--     on_attach = on_attach,
--     flags = lsp_flags,
-- }
-- require('lspconfig')['tsserver'].setup{
--     on_attach = on_attach,
--     flags = lsp_flags,
-- }
-- require('lspconfig')['rust_analyzer'].setup{
--     on_attach = on_attach,
--     flags = lsp_flags,
--     -- Server-specific settings...
--     settings = {
--       ["rust-analyzer"] = {}
--     }
-- }
