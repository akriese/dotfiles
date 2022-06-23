function Remove_trailing_spaces()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local ok, _ = pcall(vim.api.nvim_command, "keeppatterns %s/\\s\\+$//gn")
    -- only remove, if trailing spaces were found
    -- also jump back to where the cursor was before
    if ok then
        vim.cmd("keeppatterns %s/\\s\\+$//g")
        vim.api.nvim_win_set_cursor(0, cursor)
    end
end
