function Remove_trailing_spaces()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local ok, _ = pcall(vim.cmd, "keeppatterns %s/\\s\\+$//gn")
    -- only remove, if trailing spaces were found
    -- also jump back to where the cursor was before
    if ok then
        vim.cmd("keeppatterns %s/\\s\\+$//g")
        vim.api.nvim_win_set_cursor(0, cursor)
    end
end

function Source_local_config()
    vim.cmd("source $MYVIMRC")
    require("plenary.reload").reload_module("akriese")
end
