local F = require("akriese.functions")

local map = F.map
local has = F.has

vim.opt.encoding = "utf-8"
vim.g.mapleader = " "
-- vim.opt.nocompatible = true
vim.cmd("filetype off")

if has('win32') then
    vim.cmd([[
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
        let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
    ]])
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Miscellaneous plugins
    -- "tmhedberg/SimpylFold", -- Folds
    "nvim-lua/plenary.nvim", -- General utility
    "numToStr/Comment.nvim", -- comments
    {
        "max397574/better-escape.nvim", -- Escape with ii without delay
        config = function()
            require("better_escape").setup {
                mapping = { "ii" }, -- a table with mappings to use
                timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
                clear_empty_lines = false, -- clear line after escaping if there is only whitespace
                keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
            }
        end
    },
    {
        "nvim-lualine/lualine.nvim", -- status line
        config = true,
        dependencies = { "kyazdani42/nvim-web-devicons" }
    },
    "mg979/vim-visual-multi", -- Multiple Cursors
    "karb94/neoscroll.nvim", -- Smooth scrolling
    {
        "ahmedkhalf/project.nvim", -- project root cd
        config = function() require('project_nvim').setup {} end
    },

    -- Git plugins
    { "lewis6991/gitsigns.nvim", config = true },
    "tpope/vim-fugitive",

    -- Bracket / pair plugins
    "jiangmiao/auto-pairs",
    "tpope/vim-surround",
    "AndrewRadev/sideways.vim", -- Swap function arguments

    -- Color scheme
    "rebelot/kanagawa.nvim",

    -- Language specifics
    "pprovost/vim-ps1",
    {
        "snakemake/snakemake",
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. '/misc/vim/')
        end
    },
    {
        "akinsho/flutter-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- Debugging
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

    -- Startup panel
    "mhinz/vim-startify",

    -- Syntax plugins
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("akriese.treesitter")
        end
    },
    "p00f/nvim-ts-rainbow",
    "nvim-treesitter/playground",
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function() require('treesitter-context').setup() end,
    },
    {
        "nathom/filetype.nvim", -- for faster startup time
        config = function() require("filetype").setup({}) end
    },

    -- LSP plugins
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",

    -- Completion plugins
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function() require('neogen').setup { snippet_engine = "luasnip" } end
    },

    -- file tree
    { "kyazdani42/nvim-tree.lua", dependencies = { "kyazdani42/nvim-web-devicons" } },

    -- buffer plugins
    {
        "akinsho/bufferline.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        version = "v3.*"
    },
    "ThePrimeagen/harpoon",

    -- Indentation marker
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {
                -- for example, context is off by default, use this to turn it on
                show_current_context = true,
                show_current_context_start = false,
            }
        end
    },

    -- Telescope
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = 'make' },

    { "junegunn/fzf", build = './install --all' },
    "junegunn/fzf.vim",

    -- UI sugar
    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = false
                    },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
    },
    {
        "nvim-zh/colorful-winsep.nvim",
        config = function()
            require("colorful-winsep").setup({
                highlight = {
                    fg = "#957fb8"
                }
            })
        end,
        event = { "WinNew" }
    },

    -- github integration
    { "pwntester/octo.nvim", config = true },

    -- Browser integration
    {
        "glacambre/firenvim",
        setup = function()
            vim.cmd[[firenvim#install(0)]]
        end,
        config = function()
            if vim.g.started_by_firenvim then
                vim.opt.guifont = "JetBrainsMono Nerd Font:h8"
            end
        end
    },
}

require("lazy").setup(plugins)


vim.cmd("colorscheme kanagawa")
vim.opt.background = "dark"

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
vim.opt.laststatus = 3 -- Always display the status line
vim.opt.autowrite = true -- Automatically :write before running commands

vim.opt.mouse = "a"
if not has('nvim') then
    vim.opt.ttymouse = "xterm2"
end
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
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
vim.opt.cursorline = true

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
map("n", "<leader>k", require('neogen').generate)

-- Git stuff
map("n", "<leader>ga", "<cmd>Git commit --amend<CR>")
map("n", "<leader>gB", "<cmd>Git blame<CR>")
map("n", "<leader>gc", ":Git cherry-pick")
map("n", "<leader>gg", "<cmd>Git<CR>")
map("n", "<leader>gL", "<cmd>Gclog<CR>")
map("n", "<leader>gP", "<cmd>Git push<CR>")
map("n", "<leader>guP", function() vim.cmd("Git push --set-upstream origin " .. F.current_branch()) end)
map("n", "<leader>gp", "<cmd>Git pull<CR>")
map("n", "<leader><", "<cmd>diffget //3<CR>")
map("n", "<leader>>", "<cmd>diffget //2<CR>")

-- Octo (GitHub integration) commands
map("n", "<leader>opl", "<cmd>Octo pr list<cr>")
map("n", "<leader>opc", ":Octo pr checkout")
map("n", "<leader>orl", "<cmd>Octo repo list<cr>")

-- Sideways stuff
map("n", "<leader>,", "<cmd>SidewaysLeft<cr>")
map("n", "<leader>.", "<cmd>SidewaysRight<cr>")
map("n", "<leader>st", "<cmd>SymbolsOutline<cr>")

-- useful commands
map("n", "<leader>shl", "<cmd>set hlsearch!<CR>")
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>W", "<cmd>noautocmd w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>qa<CR>")
map("n", "Q", "<Nop>")
map("n", "Y", "y$")
map("i", "<C-BS>", '<C-W>')
map("i", "<C-h>", '<C-W>')

-- recenter after search or jump
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "J", "mzJ`z")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<leader>[", '<cmd>cprevious<cr>zz')
map("n", "<leader>]", '<cmd>cnext<cr>zz')

-- moving text
-- map("i", "<C-k>", "<ESC><cmd>m .-2<CR>==i")
-- map("i", "<C-j>", "<ESC><cmd>m .+1<CR>==i")
-- map("n", "<leader>k", "<cmd>m .-2<CR>==")
-- map("n", "<leader>j", "<cmd>m .+1<CR>==")
-- map("v", "J", "<cmd>m '>+1<CR>gv=gv")
-- map("v", "K", "<cmd>m '<-2<CR>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gp", "'[v']")
map("n", "gP", "'[V']")

-- vimrc loading and saving
map("n", "<leader>sv", F.source_local_config)
map("n", "<leader>ev", "<cmd>vsplit $MYVIMRC<CR>")

-- clipboard shortcuts
map("n", "<leader>Y", '"*y')
map("n", "<leader>y", '"+y')
map("v", "<leader>Y", '"*y')
map("v", "<leader>y", '"+y')
map("n", "<leader>P", 'o<esc>"+p')
map("n", "<leader>p", '"+p')

-- Switch between the last two files
map("n", "<Leader><Leader>", "<C-^>")

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

-- Terminal
map("t", "ii", [[<C-\><C-n>]])

local term_cmd = ""
if string.find(vim.o.shell, "zsh") then
    term_cmd = "export THIS='%'; unset ZDOTDIR; zsh"
elseif string.find(vim.o.shell, "bash") then
    term_cmd = "export THIS='%'; bash"
else
    -- we assume that this can only be powershell / pwsh
    -- If you want your shell to have access to $THIS, you have to set it explicitly
    -- in another case.
    -- $THIS is a reserved name in powershell / pwsh, thus we cannot use it here
    term_cmd = vim.o.shell
end

map("n", "<leader>t", "<cmd>split term://" .. term_cmd .. "<CR><cmd>resize12<cr>")

map("n", "<leader>cd", "<cmd>cd %:p:h<CR><cmd>pwd<CR>")

vim.cmd([[filetype plugin indent on]])

vim.api.nvim_create_augroup("vimrcEx", { clear = true })

local set_autocmd = function(event, pattern, cmd)
    if type(cmd) == "string" then
        vim.api.nvim_create_autocmd(event, { group = "vimrcEx", pattern = pattern, command = cmd })
    else
        vim.api.nvim_create_autocmd(event, { group = "vimrcEx", pattern = pattern, callback = cmd })
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
set_autocmd("BufWritePre", "*", F.remove_trailing_spaces)
set_autocmd("BufWritePre", "*", function() vim.lsp.buf.format() end)

set_autocmd("WinEnter", "*", function()
    vim.o.cursorline = true
    if vim.o.number == true then
        vim.o.relativenumber = true
    end
end)
set_autocmd("WinLeave", "*", function()
    vim.o.cursorline = false
    if vim.o.number then
        vim.o.relativenumber = false
    end
end)

local langs_with_4_spaces = { "python", "sh", "zsh", "Rust", "cpp", "lua", "snakemake", "javascript", "haskell" }
local langs_with_2_spaces = { "vim", "html", "dart" }
set_autocmd("FileType", langs_with_4_spaces, "setlocal shiftwidth=4 tabstop=4 softtabstop=4")
set_autocmd("FileType", langs_with_2_spaces, "setlocal sw=2 ts=2 sts=2")

set_autocmd({ "BufRead", "BufNewFile" }, { "Snakefile", "*.smk", "*.smk.py" }, "set filetype=snakemake commentstring=#%s")

set_autocmd({ "BufEnter" }, { "__FLUTTER_DEV_LOG__" }, function()
    local opts = { buffer = true }
    map("n", "r", ":FlutterReload<cr>", opts)
    map("n", "R", ":FlutterRestart<cr>", opts)
    map("n", "q", ":FlutterQuit<cr>", opts)
    map("n", "c", ":FlutterLogClear<cr>", opts)
    map("n", "d", ":FlutterDetach<cr>", opts)
end)
