local F = require("akriese.functions")

require("nvim-treesitter.install").compilers = { "clang", "gcc", "cc" }
require("nvim-treesitter.configs").setup({
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dart",
        "haskell",
        "html",
        "javascript",
        "json",
        "json5",
        "kotlin",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "styled",
        "r",
        "regex",
        "rust",
        "typescript",
        "tsx",
        "yaml",
    },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- List of parsers to ignore installing
    -- ignore_install = { "javascript" },

    highlight = {
        enable = true,
        disable = { "html" },
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { "python", "dart" },
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },

    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
})
