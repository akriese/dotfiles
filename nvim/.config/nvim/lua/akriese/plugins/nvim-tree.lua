require 'nvim-tree'.setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = false,
    respect_buf_cwd     = true,
    sync_root_with_cwd  = true,
    hijack_directories  = {
        enable = true,
        auto_open = true
    },
    diagnostics         = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },
    update_focused_file = {
        enable      = true,
        update_cwd  = true,
        ignore_list = { "octo", "git", "fugitive*", "help" }
    },
    system_open         = {
        cmd  = nil,
        args = {}
    },
    filters             = {
        dotfiles = false,
        custom = {}
    },
    git                 = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view                = {
        width = 30,
        hide_root_folder = false,
        side = 'left',
        mappings = {
            custom_only = false,
            list = {
                { key = "+", action = "cd" },
            },
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        preserve_window_proportions = true
    },
    trash               = {
        cmd = "trash",
        require_confirm = true
    }
}
