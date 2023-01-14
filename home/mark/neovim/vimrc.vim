map <space> <leader>
"
" save faster
" map <leader>w :w<CR>
lua <<EOF
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = "save" })
EOF

" reload vimrc
" map <leader>VR :source $MYVIMRC<CR>
lua <<EOF
vim.keymap.set('n', '<leader>VR', ':source $MYVIMRC<CR>', { desc = "reload vimrc" })
EOF

lang en_US

set modeline
set magic
set smartcase
set autoindent
set autoread
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nojoinspaces
set termguicolors

set list
set more
set number
set numberwidth=5
set relativenumber
set ruler
set scrolloff=1
set showcmd
set showmatch
set sidescrolloff=1
" splitting a window will put the new window below the current one
set splitbelow
set t_Co=256
set termguicolors
set title
set ttyfast
set mat=2
set lazyredraw
set backspace=eol,start,indent
set mouse=a
set mousehide

set completeopt=menu,menuone,noselect

set foldenable
set foldlevelstart=10
set foldmethod=indent

"""" Backups
set nobackup
set nowritebackup

"""" Bells/Sound
set noerrorbells
set novisualbell
set visualbell
set noerrorbells
set t_vb=

"""" Diff
" Add vertical spaces to keep right and left aligned
set diffopt=filler
" Ignore whitespace changes (focus on code changes)
set diffopt+=iwhite
set diffopt+=vertical

" set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

"""" Vimrc editing
autocmd! bufwritepost .vimrc source %
" no trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

"""" Appearance
colorscheme base16-gruvbox-dark-soft
set background=dark
set cmdheight=1
set colorcolumn=80
set cursorline
set updatetime=300
set signcolumn=yes

""" Keybindings
map qq <Nop>
" Disable accidental macro recording when I spaz out on the q key
command! W w
command! Q q
cmap w!! w !sudo tee % >/dev/null

" W" Ex mode: no ty
map Q <Nop>

lua <<EOF
-- turn off search highlight
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = "clear search" })

-- move to beginning/end of line
vim.keymap.set('n', 'B', '^', { desc = "go to beginning of line" })
vim.keymap.set('n', 'E', '$', { desc = "go to end of line" })

-- find merge conflicts
-- vim.keymap.set('n', '<leader>gfc', '/\v^[<\|=>]{7}( .*\|$)<CR>', { desc = "find merge conflicts" })

-- Tabs
-- let notabs = 1
vim.keymap.set('n', '<leader><Tab>', ':tabnext<CR>', { desc = "next tab" })
vim.keymap.set('n', '<leader><S-Tab>', ':tabprev<CR>', { desc = "prev tab" })
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', { desc = "next tab" })
vim.keymap.set('n', '<leader>tp', ':tabprev<CR>', { desc = "prev tab" })
vim.keymap.set('n', '<leader>tw', ':tabnew<CR>', { desc = "new tab" })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = "close tab" })

-- Create splits
vim.keymap.set('n', '<leader>sw', ':split<CR>', { desc = "split horizontal" })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = "split vertical" })

-- Move between splits using h
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = "move split left" })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = "move split down" })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = "move split right" })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = "move split up" })

-- Insert mode
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
-- vim.keymap.set('i', 'ii', '<Esc>')

-- Visual mode
vim.keymap.set('v', '<ESC>', '<C-c>')
vim.keymap.set('v', '<', '<gv', { desc = 'tab left' })
vim.keymap.set('v', '>', '>gv', { desc = 'tab right' })

vim.keymap.set('i', '<F1>', '<ESC>', { desc = 'fuck help' })
vim.keymap.set('n', '<F1>', '<ESC>', { desc = 'fuck help' })
vim.keymap.set('v', '<F1>', '<ESC>', { desc = 'fuck help' })
EOF
