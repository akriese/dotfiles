local F = require("akriese.functions")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
})

F.map("n", "<leader>ha", mark.add_file, { desc = "Add current file" })
F.map("n", "<leader>ht", ui.toggle_quick_menu, { desc = "Toggle menu" })
F.map("n", "<leader>hh", ui.nav_prev, { desc = "Navigate to previous" })
F.map("n", "<leader>hl", ui.nav_next, { desc = "Navigate to next" })
for i = 0, 9, 1 do
    F.map("n", "<leader>h" .. i, function()
        ui.nav_file(i)
    end, { desc = "Navigate to file " .. i })
end
