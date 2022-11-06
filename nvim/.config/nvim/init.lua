-- some functions for general use
require("akriese.functions")
-- load most of the general config (keymaps, globals, Plug, etc)
require("akriese.nvimrc")

-- Plugin setups
require("akriese.nvim-cmp")
require("akriese.treesitter")
require("akriese.nvim-tree")
require("akriese.indent")
require("akriese.lspconfig")
require("akriese.telescope")
require("akriese.symbols")
require("akriese.comment")
require("akriese.better-escape")
require("akriese.filetype")
require("akriese.bufferline")
require("akriese.lualine")
require("akriese.dap")
require("akriese.scroll")
require("akriese.harpoon")

require('gitsigns').setup {}
