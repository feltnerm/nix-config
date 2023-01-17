local telescope = require('telescope')

require('telescope').setup{
  pickers = {
    buffers = { theme = "dropdown", },
    find_files = { theme = "dropdown", },
    git_branches = { theme = "dropdown", },
    git_files = { theme = "dropdown", },
    help_tags = { theme = "dropdown", },
    help_tags = { theme = "dropdown", },
    live_grep = { theme = "dropdown" },

    current_buffer_fuzzy_find = { theme = "cursor" },
    current_buffer_tags = { theme = "cursor" },
    quickfix = { theme = "cursor" },

    command_history = { theme = "ivy" },
    search_history = { theme = "ivy" },
    help_tags = { theme = "ivy" },
  }
}
local builtin = require('telescope.builtin')

local opts = { desc = "search" }

vim.keymap.set('n', '<leader>p', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>pp', builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set('n', '<leader>pf', builtin.find_files, opts)

vim.keymap.set('n', '<leader>pb', builtin.buffers, opts)

vim.keymap.set('n', '<leader>pt', builtin.tags, opts)
vim.keymap.set('n', '<leader>pbt', builtin.current_buffer_tags, opts)

vim.keymap.set('n', '<leader>phc', builtin.command_history, opts)
vim.keymap.set('n', '<leader>phs', builtin.search_history, opts)
vim.keymap.set('n', '<leader>phh', builtin.help_tags, opts)

vim.keymap.set('n', '<leader>pq', builtin.quickfix, opts)

vim.keymap.set('n', '<leader>pg', builtin.git_files, opts)
vim.keymap.set('n', '<leader>pgc', builtin.git_commits, opts)
vim.keymap.set('n', '<leader>pgbc', builtin.git_bcommits, opts)
vim.keymap.set('n', '<leader>pgs', builtin.git_status, opts)
vim.keymap.set('n', '<leader>pgb', builtin.git_branches, opts)

vim.keymap.set('n', '<leader>cr', builtin.lsp_references, opts)
vim.keymap.set('n', '<leader>cci', builtin.lsp_incoming_calls, opts)
vim.keymap.set('n', '<leader>cco', builtin.lsp_outgoing_calls, opts)
vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>cws', builtin.lsp_workspace_symbols, opts)
vim.keymap.set('n', '<leader>ci', builtin.lsp_implementations, opts)
vim.keymap.set('n', '<leader>cd', builtin.lsp_definitions, opts)
vim.keymap.set('n', '<leader>ct', builtin.lsp_type_definitions, opts)
vim.keymap.set('n', '<leader>ctt', builtin.treesitter, opts)

