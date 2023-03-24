local _M = {}

function _M.set_autocmd(event, cmd, opts)
    local options = opts or {}
    if type(cmd) == "string" then
        options.command = cmd
    else
        options.callback = cmd
    end
    vim.api.nvim_create_autocmd(event, options)
end

function _M.remove_trailing_spaces()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local ok, _ = pcall(vim.cmd, "silent keeppatterns %s/\\s\\+$//gn")
    -- only remove, if trailing spaces were found
    -- also jump back to where the cursor was before
    if ok then
        vim.cmd("silent keeppatterns %s/\\s\\+$//g")
        vim.api.nvim_win_set_cursor(0, cursor)
    end
end

function _M.source_local_config()
    vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
    for name, _ in pairs(package.loaded) do
        if name:match('^akriese') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
end

function _M.has(option)
    return vim.fn.has(option) == 1
end

function _M.plug(plugin)
    vim.cmd("Plug " .. plugin)
end

-- Functional wrapper for mapping custom keybindings
function _M.map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

function _M.current_branch()
    local output = vim.fn.system("git branch --show-current"):gsub("\n", "")
    if output ~= "" then
        return output
    else
        return ""
    end
end

return _M
