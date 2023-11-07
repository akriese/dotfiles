local F = require("akriese.functions")
local has = F.has
local set_autocmd = F.set_autocmd

vim.opt.encoding = "utf-8"
vim.g.mapleader = " "

if has("win32") then
    vim.cmd([[
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
        let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
    ]])
end

vim.opt.hlsearch = true
vim.opt.backspace = "2" -- Backspace deletes like most programs in insert mode
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.showmode = false
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false -- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.opt.history = 50
vim.opt.ruler = true -- show the cursor position all the time
vim.opt.showcmd = true -- display incomplete commands
vim.opt.incsearch = true -- do incremental searching
vim.opt.autowrite = true -- Automatically :write before running commands
vim.opt.laststatus = 3 -- Always display the status line

vim.opt.mouse = "a"
if not has("nvim") then
    vim.opt.ttymouse = "xterm2"
end
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"

vim.cmd("highlight ColorColumn ctermbg=52")
vim.opt.colorcolumn = "88"
set_autocmd("BufEnter", function()
    vim.opt_local.colorcolumn = "72"
end, { pattern = "COMMIT_EDITMSG" })

vim.opt.wildmode = "list:longest,list:full"
vim.opt.updatetime = 100 -- update time for git gutter
vim.opt.timeout = true
vim.opt.ttimeoutlen = 50
vim.opt.inccommand = "nosplit"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.termguicolors = true
vim.opt.cursorline = true

if has("wsl") then
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

if has("win32") then
    vim.opt.shada = "'100,n~/AppData/Local/nvim-data/shada/main.shada"
else
    vim.opt.shada = "'100,n~/.local/share/nvim/shada/main.shada"
end
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
