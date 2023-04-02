vim.opt.encoding = "utf-8"
vim.g.mapleader = " "
-- vim.opt.nocompatible = true
vim.cmd("filetype off")
vim.cmd([[filetype plugin indent on]])

require("akriese.options")

-- load most of the general config (keymaps, globals, Plug, etc)
require("akriese.plugins")
vim.cmd("colorscheme kanagawa")

require("akriese.mappings")
require("akriese.autocmds")
