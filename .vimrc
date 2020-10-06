set encoding=utf-8

" Leader
let mapleader = " "

set nocompatible
filetype off

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'
Plug 'tmhedberg/SimpylFold'
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_import=1
"Plug 'Valloric/YouCompleteMe'
"let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g :YcmCompleter GoTo<CR>
Plug 'vim-syntastic/syntastic'
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized'
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
" \| Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
map <leader>n :NERDTreeToggle<CR>
Plug 'frazrepo/vim-rainbow'
map <leader>r :RainbowToggle<CR>
Plug 'airblade/vim-gitgutter'
map <leader>v :GitGutterToggle<CR>
nnoremap <leader>hn :GitGutterNextHunk<CR>
nnoremap <leader>hl :GitGutterPrevHunk<CR>
"let g:gitgutter_diff_args='--cached'
"Plugin 'mileszs/ack.vim'
"map <leader>a :Ack
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_disable_startup_warning = 1
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'davidhalter/jedi-vim'
Plug 'vifm/vifm.vim'
let g:vifm_embed_term=1
let g:vifm_embed_split=1
"map <leader>n :leftabove vertical 40Vifm<CR>
Plug 'guns/xterm-color-table.vim'

call plug#end()

colorscheme zenburn

set hlsearch

"set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noshowmode
set expandtab
set shiftwidth=2
set autoindent
set smartindent
set softtabstop=2
set tabstop=2
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set mouse=a
set foldmethod=indent
set foldlevel=99
set number relativenumber
set numberwidth=5
set signcolumn=yes
set colorcolumn=80
highlight ColorColumn ctermbg=167

let python_highlight_all=1
let g:rainbow_active = 1

" ALL Coc settings
"inoremap <silent><expr> <c-space> coc#refresh()
" coc-python: pip install pylint jedi; coc: enable jedi, jedi path
" coc-clangd: sudo apt install clangd && evtl symlink erstellen
" coc-r-lsp: install.packages('languageserver'); coc: addpath: /urs/bin/R
let g:coc_global_extensions=['coc-json',
                \ 'coc-python', 'coc-sh', 'coc-clangd',
                \ 'coc-r-lsp', 'coc-marketplace', 'coc-vimlsp' ]
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

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

autocmd BufWritePre * %s/\s\+$//e

let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

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

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
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

" Run commands that require an interactive shell
"nnoremap <Leader>r :RunInInteractiveShell<Space>

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

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
