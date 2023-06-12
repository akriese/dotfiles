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
        if name:match("^akriese") then
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

function _M.enter_number(prompt)
    local result = vim.fn.input({ prompt = prompt, default = "", cancelreturn = "q" })
    if result == "q" or result == "" then
        print("Nothing chosen")
        return nil
    end
    local num = tonumber(result)
    if num == nil then
        print("Invalid input! Choose a number!")
        return nil
    end

    return num
end

function _M.set_tab_width(width)
    if width == nil then
        local prompt = "Enter the number of spaces to represent a tab: "
        local result = _M.enter_number(prompt)
        if result == nil then
            return
        end
        width = result
    end
    vim.o.tabstop = width
    vim.o.shiftwidth = width
    print("Tab width set to " .. width .. "!")
end

return _M
