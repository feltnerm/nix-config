map <space> <leader>

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
" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" W" Ex mode: no ty
map Q <Nop>

"" Normal Mode
nmap ; :
" turn off search highlight
nnoremap <leader>/ :nohlsearch<CR>
" move to beginning/end of line
nnoremap B ^
nnoremap E $
" highlight last inserted text
nnoremap gV `[v`]
"  Tabs
let notabs = 1
nmap <leader><Tab> :tabnext<CR>
nmap <leader><S-Tab> :tabprev<CR>
nmap <leader>tn :tabnext<CR>
nmap <leader>tp :tabprev<CR>
nmap <leader>tw :tabnew<CR>
nmap <leader>tc :tabclose<CR
" Create splits
nmap <leader>sw :split<cr>
nmap <leader>sv :vsplit<cr>
" Move between splits using hjkl
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-k> <C-w>k
" noremap <C-l> <C-w>l
nmap <leader>Wh <C-w>h
nmap <leader>Wj <C-w>j
nmap <leader>Wk <C-w>k
nmap <leader>Wl <C-w>l

"" Insert Mode
inoremap jj <Esc>
inoremap jk <Esc>
imap ii <C-[>

"" Visual Mode
vnoremap <ESC> <C-c>
vmap < <gv
vmap > >gv

"""" Fuck help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
