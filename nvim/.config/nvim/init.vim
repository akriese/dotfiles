set encoding=utf-8

" Leader
let mapleader = " "

set nocompatible
filetype off


if has('win32') || has('win64')
  set shell=powershell shellquote= shellpipe=\| shellxquote=
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellredir=\|\ Out-File\ -Encoding\ UTF8
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  if has('win32') || has('win64')
    !New-Item -Path ~/.vim/autoload/ -ItemType Directory -ea 0
    !Invoke-WebRequest -OutFile ~/.vim/autoload/plug.vim
      \ -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set rtp +=~/.vim
call plug#begin('~/.vim/plugged')

" Plugin Manager
Plug 'junegunn/vim-plug'

" Miscellaneous Plugins
Plug 'tmhedberg/SimpylFold' " Folds
"Plug 'preservim/nerdcommenter' " Comments
Plug 'numToStr/Comment.nvim' " comments
Plug 'max397574/better-escape.nvim' " Escape with ii without delay
Plug 'itchyny/lightline.vim' " Status line
Plug 'mg979/vim-visual-multi' " Multiple Cursors
Plug 'psliwka/vim-smoothie' " Smooth scrolling

" Git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Bracket / pair plugins
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/sideways.vim' " Swap function arguments

" Color scheme
" Plug 'gruvbox-community/gruvbox'
Plug 'rebelot/kanagawa.nvim'
Plug 'guns/xterm-color-table.vim'

" Language sepcifics
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' } " :UpdateRemotePlugins
Plug 'pprovost/vim-ps1'

" Startup panel
Plug 'mhinz/vim-startify'

" Syntax plugins
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'nathom/filetype.nvim' " for faster startup time
" Plug 'vim-python/python-syntax'
" Plug 'vim-syntastic/syntastic'

" LSP plugins
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Completion plugins
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" file tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Indentation marker
Plug 'lukas-reineke/indent-blankline.nvim'

" Telescope
Plug 'nvim-lua/plenary.nvim' " dependency of Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Sidebar
Plug 'simrat39/symbols-outline.nvim'

call plug#end()

colorscheme kanagawa
set background=dark

set hlsearch
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noshowmode
set expandtab
"set shiftwidth=2
set autoindent
set smartindent
"set softtabstop=2
"set tabstop=2
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
if !has('nvim')
    set ttymouse=xterm2
endif
set mouse=a
set foldmethod=indent
set foldlevel=99
set number relativenumber
set numberwidth=5
set signcolumn=yes
set colorcolumn=80
set wildmode=list:longest,list:full
set updatetime=100 "update time for git gutter
set timeout ttimeoutlen=50
set inccommand=nosplit
if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': '/usr/local/bin/win32yank.exe -i --crlf',
          \      '*': '/usr/local/bin/win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': '/usr/local/bin/win32yank.exe -o --lf',
          \      '*': '/usr/local/bin/win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect

" set color of colorcolumn
highlight ColorColumn ctermbg=52
let python_highlight_all=1

" Plugin globals
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_import=1
let g:vifm_embed_term=1
let g:vifm_embed_split=1

" ALL PLUGIN RELATED mappings
nnoremap <leader>n  <cmd>NvimTreeToggle<CR>
nnoremap <leader>fg <cmd>Telescope git_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fb <cmd>Telescope git_branches<cr>
nnoremap <leader>fc <cmd>Telescope git_commits<cr>
nnoremap <leader>ft <cmd>Telescope live_grep<cr>
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>G <cmd>Git<CR>
nmap <C-d> <Plug>(SmoothieDownwards)zz
nmap <C-u> <Plug>(SmoothieUpwards)zz
nnoremap <leader>, <cmd>SidewaysLeft<cr>
nnoremap <leader>. <cmd>SidewaysRight<cr>
nnoremap <leader>st <cmd>SymbolsOutline<cr>


" useful commands
nnoremap <leader>shl <cmd>set hlsearch!<CR>
nnoremap <leader>w <cmd>w<CR>
nnoremap <leader>q <cmd>q<CR>
nnoremap <leader>Q <cmd>qa<CR>
nnoremap Q <Nop>
nnoremap Y y$
inoremap <C-BS> <C-W>
inoremap <C-h> <C-W>
nnoremap <leader>[ <cmd>clast<cr>
nnoremap <leader>] <cmd>cnext<cr>

" recenter after search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap J mzJ`z

" moving text
inoremap <C-k> <ESC><cmd>m .-2<CR>==i
inoremap <C-j> <ESC><cmd>m .+1<CR>==i
nnoremap <leader>k <cmd>m .-2<CR>==
nnoremap <leader>j <cmd>m .+1<CR>==
vnoremap K <cmd>m '<-2<CR>gv=gv
vnoremap J <cmd>m '>+1<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

" vimrc loading and saving
nnoremap <leader>sv <cmd>source $MYVIMRC<CR>
nnoremap <leader>ev <cmd>vsplit $MYVIMRC<CR>

" clipboard shortcuts
nnoremap <leader>Y "*y
nnoremap <leader>y "+y
vnoremap <leader>Y "*y
vnoremap <leader>y "+y
nnoremap <leader>P "*p
nnoremap <leader>p "+p

" disable Background Color Erase (BCE)
if &term =~ '256color'
  set t_ut=
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!
  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
  autocmd BufRead,BufNewFile *bashrc set filetype=sh

  " remove trailing whitespace on saving
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Disable character forwarding for shell (removes weird character bug)
let &t_TI = ""
let &t_TE = ""
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[2 q"

" shell for syntax highlighting purposes.
let g:is_posix = 1

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
" go back to insert mode when warning not to use arrow keys in insert mode
inoremap <Left> <esc>l:echo "Use h" <bar> star<CR>
inoremap <Right> <esc>l:echo "Use l" <bar> star<CR>
inoremap <Up> <esc>l:echo "Use k" <bar> star<CR>
inoremap <Down> <esc>l:echo "Use j" <bar> star<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Exit terminal
tnoremap ii <C-\><C-n>
if &shell =~ "zsh"
  nnoremap <leader>t <cmd>split term://export THIS=%; unset ZDOTDIR; zsh<CR><cmd>resize12<cr>
else
  nnoremap <leader>t <cmd>split term://export THIS=%; bash<CR><cmd>resize12<cr>
endif


" new operators for 'inside' next/last parens, braces etc.
function! s:Pair_mappings()
  let l:pair_dict = { ')':'(', ']':'[', '}':'{', 'b':')',
      \ '(':'(', '[':'[', '{':'{', '<':'<', '>':'<', '''': '''', '"': '\"' }
  for [key, val] in items(l:pair_dict)
    execute 'onoremap in'.key.' :execute "keeppatterns normal! /'.val.'\rvi'.val.'"<cr>'
    execute 'onoremap il'.key.' :execute "keeppatterns normal! ?'.val.'\rvi'.val.'"<cr>'
    execute 'onoremap an'.key.' :execute "keeppatterns normal! /'.val.'\rva'.val.'"<cr>'
    execute 'onoremap al'.key.' :execute "keeppatterns normal! ?'.val.'\rva'.val.'"<cr>'
  endfor
endfunction
call s:Pair_mappings()

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

autocmd FileType python,sh,zsh,Rust,cpp,lua setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType vim setlocal sw=2 ts=2 sts=2

set termguicolors
"autocmd BufEnter term://* setlocal termguicolors
"autocmd BufLeave term://* setlocal notermguicolors


lua require("akriese.nvim-cmp")
lua require("akriese.treesitter")
lua require("akriese.nvim-tree")
lua require("akriese.indent")
lua require("akriese.lspconfig")
lua require("akriese.telescope")
lua require("akriese.symbols")
lua require("akriese.comment")
lua require("akriese.better-escape")
lua require("akriese.filetype")
