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

Plug 'junegunn/vim-plug'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-syntastic/syntastic'
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
" \| Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'frazrepo/vim-rainbow'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
if executable('ack')
  Plug 'mileszs/ack.vim'
  nnoremap <leader>st  :Ack
elseif executable('rg')
  nnoremap <leader>st  :Rg<CR>
endif
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'psliwka/vim-smoothie'
Plug 'gruvbox-community/gruvbox'
Plug 'pprovost/vim-ps1'
Plug 'vim-python/python-syntax'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' } " :UpdateRemotePlugins
Plug 'mhinz/vim-startify'

call plug#end()

colorscheme gruvbox
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
set ttymouse=xterm2
set mouse=a
set foldmethod=indent
set foldlevel=99
set number relativenumber
set numberwidth=5
set signcolumn=yes
set colorcolumn=80
set wildmode=list:longest,list:full
set updatetime=100 "update time for git gutter

" set color of colorcolumn
highlight ColorColumn ctermbg=167
let python_highlight_all=1

" Plugin globals
let g:rainbow_active = 1
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_import=1
let g:coc_disable_startup_warning=1
let g:vifm_embed_term=1
let g:vifm_embed_split=1

" ALL PLUGIN RELATED mappings
nnoremap <leader>n  :NERDTreeToggle<CR>
nnoremap <leader>r  :RainbowToggle<CR>
nnoremap <leader>v  :GitGutterToggle<CR>
nnoremap <leader>hn :GitGutterNextHunk<CR>zz
nnoremap <leader>hl :GitGutterPrevHunk<CR>zz
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fc :execute "Files " expand('%:p:h')<cr>
nnoremap <leader>fv :Files<space>
nnoremap <leader>shl :set hlsearch!<CR>

" ALL Coc settings
"inoremap <silent><expr> <c-space> coc#refresh()
" coc-jedi: pip install pylint jedi; coc: enable jedi, jedi path
" coc-clangd: sudo apt install clangd && evtl symlink erstellen
" coc-r-lsp: install.packages('languageserver'); coc: addpath: /urs/bin/R
" coc-rls: install rustup, 'rustup component add rls rust-analysis rust-src'
let g:coc_global_extensions=['coc-json',
                \ 'coc-jedi', 'coc-sh', 'coc-clangd',
                \ 'coc-r-lsp', 'coc-marketplace', 'coc-vimlsp', 'coc-rls' ]
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nmap <leader> rn <Plug>(coc-rename)

function! Check_back_space()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return 1
    else
        return 0
    endif
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ Check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" fzf settings
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
let $FZF_DEFAULT_OPTS='--reverse'


"let c='a'
"while c <= 'z'
  "exec "set <A-".c.">=\e".c
  "exec "imap \e".c." <A-".c.">"
  "let c = nr2char(1+char2nr(c))
"endw

set timeout ttimeoutlen=50
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" clipboard shortcuts
nnoremap <leader>y "*y
nnoremap <leader>Y "+y
nnoremap <leader>p "*p
nnoremap <leader>P "+p

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" disable Background Color Erase (BCE)
if &term =~ '256color'
  set t_ut=
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim

  " remove trailing whitespace on saving
  autocmd BufWritePre * %s/\s\+$//e

augroup END


" Disable character forwarding for shell (removes weird character bug)
let &t_TI = ""
let &t_TE = ""

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

autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType sh setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType Rust setlocal shiftwidth=4 tabstop=4 softtabstop=4
