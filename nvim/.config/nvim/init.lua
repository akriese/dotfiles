require("akriese.options")

-- load most of the general config (keymaps, globals, Plug, etc)
require("akriese.plugins")

vim.cmd("colorscheme kanagawa")
vim.opt.background = "dark"

require("akriese.mappings")
require("akriese.autocmds")
