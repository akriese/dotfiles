local has = function(option)
    return vim.fn.has(option) == 1
end

local plug = function(plugin)
    vim.cmd("Plug " .. plugin)
end

-- Functional wrapper for mapping custom keybindings
local map = function(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

vim.opt.encoding = "utf-8"
vim.g.mapleader = " "
-- vim.opt.nocompatible = true
vim.cmd("filetype off")

if has('win32') or has('win64') then
    vim.cmd([[
        set shell=powershell shellquote= shellpipe=\| shellxquote=
        set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
        set shellredir=\|\ Out-File\ -Encoding\ UTF8
    ]])
end

if vim.fn.empty("glob('~/.vim/autoload/plug.vim')") == 1 then
    if has('win32') or has('win64') then
        vim.cmd([[
            !New-Item -Path ~/.vim/autoload/ -ItemType Directory -ea 0
            !Invoke-WebRequest -OutFile ~/.vim/autoload/plug.vim
          \ -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        ]])
    else
        vim.cmd([[
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        ]])
    end

    vim.api.nvim_create_autocmd("VimEnter", { pattern = "*", command = "PlugInstall --sync | source $MYVIMRC"})
end

vim.opt.rtp:append("~/.vim/")
vim.cmd([[ call plug#begin('~/.vim/plugged') ]])

-- plugin Manager
plug("'junegunn/vim-plug'")

-- Miscellaneous plugins
plug("'tmhedberg/SimpylFold'") -- Folds
plug("'nvim-lua/plenary.nvim'") -- General utility

plug("'numToStr/Comment.nvim'") -- comments
plug("'max397574/better-escape.nvim'") -- Escape with ii without delay
plug("'itchyny/lightline.vim'") -- Status line
plug("'mg979/vim-visual-multi'") -- Multiple Cursors
plug("'karb94/neoscroll.nvim'") -- Smooth scrolling

-- Git plugins
plug("'lewis6991/gitsigns.nvim'")
plug("'tpope/vim-fugitive'")

-- Bracket / pair plugins
plug("'jiangmiao/auto-pairs'")
plug("'tpope/vim-surround'")
plug("'AndrewRadev/sideways.vim'") -- Swap function arguments

-- Color scheme
plug("'rebelot/kanagawa.nvim'")
plug("'guns/xterm-color-table.vim'")

-- Language sepcifics
plug("'pprovost/vim-ps1'")
plug("'snakemake/snakemake', {'rtp': 'misc/vim/'}")

-- Debugging
plug("'mfussenegger/nvim-dap'")
plug("'mfussenegger/nvim-dap-python'")
plug("'rcarriga/nvim-dap-ui'")

-- Startup panel
plug("'mhinz/vim-startify'")

-- Syntax plugins
plug "'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}"
plug("'p00f/nvim-ts-rainbow'")
plug("'nathom/filetype.nvim'") -- for faster startup time

-- LSP plugins
plug("'neovim/nvim-lspconfig'")
plug("'williamboman/nvim-lsp-installer'")
plug("'folke/lua-dev.nvim'")

-- Completion plugins
plug("'hrsh7th/nvim-cmp'")
plug("'hrsh7th/cmp-buffer'")
plug("'hrsh7th/cmp-path'")
plug("'hrsh7th/cmp-cmdline'")
plug("'hrsh7th/cmp-nvim-lsp'")
plug("'hrsh7th/cmp-nvim-lua'")
plug("'hrsh7th/vim-vsnip'")
plug("'hrsh7th/vim-vsnip-integ'")

-- file tree
plug("'kyazdani42/nvim-web-devicons'") -- for file icons
plug("'kyazdani42/nvim-tree.lua'")

-- Indentation marker
plug("'lukas-reineke/indent-blankline.nvim'")

-- Telescope
plug("'nvim-lua/plenary.nvim'") -- dependency of Telescope
plug("'nvim-telescope/telescope.nvim'")
plug "'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }"

plug "'junegunn/fzf', { 'do': './install --all' }"
plug("'junegunn/fzf.vim'")

-- Sidebar
plug("'simrat39/symbols-outline.nvim'")

vim.cmd("call plug#end()")

vim.cmd("colorscheme kanagawa")
vim.opt.background = "dark"

vim.opt.hlsearch = true
vim.opt.backspace = "2"   -- Backspace deletes like most programs in insert mode
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.showmode = false
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false    -- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.opt.history = 50
vim.opt.ruler = true         -- show the cursor position all the time
vim.opt.showcmd = true       -- display incomplete commands
vim.opt.incsearch = true    -- do incremental searching
vim.opt.laststatus = 2  -- Always display the status line
vim.opt.autowrite = true     -- Automatically :write before running commands

vim.opt.mouse = "a"
if not has('nvim') then
    vim.opt.ttymouse = "xterm2"
end
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 5
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.wildmode = "list:longest,list:full"
vim.opt.updatetime = 100 -- update time for git gutter
vim.opt.timeout = true
vim.opt.ttimeoutlen = 50
vim.opt.inccommand = "nosplit"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.termguicolors = true

if has('wsl') then
    vim.cmd([[
        let g:clipboard = {
        \   'name': 'wslclipboard',
        \   'copy': {
        \       '+': '/usr/local/bin/win32yank.exe -i --crlf',
        \       '*': '/usr/local/bin/win32yank.exe -i --crlf',
        \   },
        \   'paste': {
        \       '+': '/usr/local/bin/win32yank.exe -o --lf',
        \       '*': '/usr/local/bin/win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \}
    ]])
end
vim.opt.shada = "'100,n~/.local/share/nvim/shada/main.shada"
vim.opt.list = true
vim.opt.listchars:append({ tab = "»·", trail = "·", nbsp = "·", eol = "↲" })

-- Use one space, not two, after punctuation.
vim.opt.joinspaces = false

-- Open new split panes to right and bottom, which feels more natural
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Autocomplete with dictionary words when spell check is on
vim.opt.complete:append("kspell")

-- Always use vertical diffs
vim.opt.diffopt:append("vertical")

-- disable Background Color Erase (BCE)
if string.find(vim.o.term, '256color') then
    vim.o.t_ut = ""
end

-- Disable character forwarding for shell (removes weird character bug)
vim.o.t_TI = ""
vim.o.t_TE = ""
vim.o.t_SI = [[\<Esc>[6 q]]
vim.o.t_SR = [[\<Esc>[3 q]]
vim.o.t_EI = [[\<Esc>[2 q]]

if vim.fn.exists('$TMUX') == 1 then
    vim.o.t_SI = [[\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\]]
    vim.o.t_EI = [[\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\]]
else
    vim.o.t_SI = [[\e[5 q]]
    vim.o.t_EI = [[\e[2 q]]
end

vim.cmd("highlight ColorColumn ctermbg=52")

-- ALL PLUGIN RELATED mappings
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
-- Telescope stuff
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>")
map("n", "<leader>fg", "<cmd>Telescope git_files<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>")
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
map("n", "<leader>ft", "<cmd>Telescope live_grep<cr>") -- live grep with respect to gitignore and hidden files
map("n", "<leader>fT", function() -- same but includes search in hidden and ignored files
    require("telescope.builtin").live_grep({additional_args = function(_)
        return {"-uu"} -- pass flag to search in hidden and ignored files too
    end})
end)
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>")

-- Git stuff
map("n", "<leader>ga", "<cmd>Git commit --amend<CR>")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
map("n", "<leader>gB", "<cmd>Git blame<CR>")
map("n", "<leader>gc", ":Git cherry-pick")
map("n", "<leader>gg", "<cmd>Git<CR>")
map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>gL", "<cmd>Gclog<CR>")
map("n", "<leader>gP", "<cmd>Git push<CR>")
map("n", "<leader>gp", "<cmd>Git pull<CR>")
-- Sideways stuff
map("n", "<leader>,", "<cmd>SidewaysLeft<cr>")
map("n", "<leader>.", "<cmd>SidewaysRight<cr>")
map("n", "<leader>st", "<cmd>SymbolsOutline<cr>")

-- Debug commands
local dap = require'dap'
local widgets = require'dap.ui.widgets'
map("n", "<F5>", dap.continue, {silent = true})
map("n", "<F10>", dap.step_over, {silent = true})
map("n", "<F11>", dap.step_into, {silent = true})
map("n", "<F12>", dap.step_out, {silent = true})
map("n", "<leader>db", dap.toggle_breakpoint, {silent = true})
map("n", "<leader>di", dap.step_into, {silent = true})
map("n", "<leader>do", dap.step_over, {silent = true})
map("n", "<leader>dc", dap.continue, {silent = true})
map("n", "<leader>dt", dap.terminate, {silent = true})
map("n", "<leader>dr", dap.repl.open, {silent = true})
map("n", "<leader>dv", widgets.sidebar(widgets.scopes).open, {silent = true})
map("n", "<leader>K", widgets.hover, {silent = true})
map("n", "<leader>D", vim.diagnostic.open_float, { silent = true })

vim.api.nvim_create_autocmd("FileType", { pattern = "dap-float", command = "nnoremap <buffer><silent> q <cmd>close!<CR>" })
vim.api.nvim_create_autocmd("FileType", { pattern = "dap-float", command = "nnoremap <buffer><silent> <esc> <cmd>close!<CR>" })

-- useful commands
map("n", "<leader>shl", "<cmd>set hlsearch!<CR>")
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>qa<CR>")
map("n", "Q", "<Nop>")
map("n", "Y", "y$")
map("i", "<C-BS>", '<C-W>')
map("i", "<C-h>", '<C-W>')
map("n", "<leader>[", '<cmd>cprevious<cr>')
map("n", "<leader>]", '<cmd>cnext<cr>')

-- recenter after search
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "J", "mzJ`z")

-- moving text
map("i", "<C-k>", "<ESC><cmd>m .-2<CR>==i")
map("i", "<C-j>", "<ESC><cmd>m .+1<CR>==i")
map("n", "<leader>k", "<cmd>m .-2<CR>==")
map("n", "<leader>j", "<cmd>m .+1<CR>==")
map("v", "J", "<cmd>m '>+1<CR>gv=gv")
map("v", "K", "<cmd>m '<-2<CR>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gp", "'[v']")
map("n", "gP", "'[V']")

-- vimrc loading and saving
map("n", "<leader>sv", Source_local_config)
map("n", "<leader>ev", "<cmd>vsplit $MYVIMRC<CR>")

-- clipboard shortcuts
map("n", "<leader>Y", '"*y')
map("n", "<leader>y", '"+y')
map("v", "<leader>Y", '"*y')
map("v", "<leader>y", '"+y')
map("n", "<leader>P", 'o<esc>"+p')
map("n", "<leader>p", '"+p')

-- Switch between the last two files
map("n", "<Leader><Leader>",  "<C-^>")

-- Keymaps to keep me from using arrow keys to navigate
map("n", "<Left>", "<cmd>echoe 'Use h'<CR>")
map("n", "<Right>", "<cmd>echoe 'Use l'<CR>")
map("n", "<Up>", "<cmd>echoe 'Use k'<CR>")
map("n", "<Down>", "<cmd>echoe 'Use j'<CR>")

-- go back to insert mode when warning not to use arrow keys in insert mode
map("i", "<Left>", "<esc>l:echo 'Use h' <bar> star<CR>")
map("i", "<Right>", "<esc>l:echo 'Use l' <bar> star<CR>")
map("i", "<Up>", "<esc>l:echo 'Use k' <bar> star<CR>")
map("i", "<Down>", "<esc>l:echo 'Use j' <bar> star<CR>")

-- Quicker window movement
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")

-- Exit terminal
map("t", "ii", [[<C-\><C-n>]])
if string.find(vim.o.shell, "zsh") then
    map("n", "<leader>t", "<cmd>split term://export THIS=%; unset ZDOTDIR; zsh<CR><cmd>resize12<cr>")
else
    map("n", "<leader>t", "<cmd>split term://export THIS=%; bash<CR><cmd>resize12<cr>")
end

vim.cmd([[filetype plugin indent on]])

vim.api.nvim_create_augroup("vimrcEx", { clear = true })

local set_autocmd = function(event, pattern, cmd)
    if type(cmd) == "string" then
        vim.api.nvim_create_autocmd(event, {group="vimrcEx", pattern=pattern, command=cmd})
    else
        vim.api.nvim_create_autocmd(event, {group="vimrcEx", pattern=pattern, callback=cmd})
    end
end

--autocmd!
-- Set syntax highlighting for specific file types
set_autocmd({ "BufRead", "BufNewFile" }, "*.md", "set filetype=markdown")
set_autocmd({ "BufRead", "BufNewFile" }, ".{jscs,jshint,eslint}rc", "set filetype=json")
set_autocmd({ "BufRead", "BufNewFile" }, { "aliases.local", "zshrc.local", "*/zsh/configs/*" }, "set filetype=sh")
set_autocmd({ "BufRead", "BufNewFile" }, "gitconfig.local", "set filetype=gitconfig")
set_autocmd({ "BufRead", "BufNewFile" }, "tmux.conf.local", "set filetype=tmux")
set_autocmd({ "BufRead", "BufNewFile" }, "vimrc.local", "set filetype=vim")
set_autocmd({ "BufRead", "BufNewFile" }, "*bashrc", "set filetype=sh")

-- remove trailing whitespace on saving
set_autocmd("BufWritePre", "*", Remove_trailing_spaces)

local langs_with_4_spaces = { "python", "sh", "zsh", "Rust", "cpp", "lua", "snakemake", "javascript", "haskell" }
local langs_with_2_spaces = { "vim", "html" }
set_autocmd("FileType", langs_with_4_spaces, "setlocal shiftwidth=4 tabstop=4 softtabstop=4")
set_autocmd("FileType", langs_with_2_spaces, "setlocal sw=2 ts=2 sts=2")

set_autocmd({ "BufRead", "BufNewFile" }, { "Snakefile", "*.smk" }, "set filetype=snakemake")
