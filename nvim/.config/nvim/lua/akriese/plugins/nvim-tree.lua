vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "+", api.tree.change_root_to_node, opts("CD"))
end

require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    diagnostics = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = false,
        -- update_root = true,
        ignore_list = { "octo", "git", "fugitive*", "help" },
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    filters = {
        dotfiles = false,
        custom = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 30,
        side = "left",
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        preserve_window_proportions = true,
    },
    renderer = {
        root_folder_label = false,
        indent_markers = { enable = true },
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    on_attach = on_attach,
})
