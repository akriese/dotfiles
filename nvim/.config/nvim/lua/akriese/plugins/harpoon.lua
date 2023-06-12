local F = require("akriese.functions")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
})

F.map("n", "<leader>ha", mark.add_file)
F.map("n", "<leader>ht", ui.toggle_quick_menu)
