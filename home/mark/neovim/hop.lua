local hop = require('hop')
hop.setup()

vim.keymap.set('n', '<leader><leader>', hop.hint_anywhere())
vim.keymap.set('n', '<leader><leader>w', hop.hint_words())
vim.keymap.set('n', '<leader><leader>W', hop.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR }))

local directions = require('hop.hint').HintDirection

vim.keymap.set('', '<leader><leader>f',
  function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end, {remap=true})

vim.keymap.set('', '<leader><leader>F',
  function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end, {remap=true})

vim.keymap.set('', '<leader><leader>t',
  function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  end, {remap=true})

vim.keymap.set('', '<leader><leader>T',
  function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end, {remap=true})

