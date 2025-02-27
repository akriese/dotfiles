local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    "nvim-lua/plenary.nvim", -- General utility

    -- Comments
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        },
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    },

    -- Miscellaneous plugins
    {
        "max397574/better-escape.nvim", -- Escape with ii without delay
        event = { "InsertEnter", "TermEnter" },
        config = function()
            require("better_escape").setup({
                mappings = {
                    i = {
                        i = {
                            i = "<Esc>",
                        },
                    },
                    t = {
                        i = {
                            i = "<C-\\><C-n>",
                        },
                    },
                }, -- a table with mappings to use
                timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim", -- status line
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = not vim.g.started_by_firenvim,
        config = true,
    },
    "mg979/vim-visual-multi", -- Multiple Cursors
    "karb94/neoscroll.nvim", -- Smooth scrolling
    {
        "ahmedkhalf/project.nvim", -- project root cd
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern" }, --, "lsp" },
                patterns = { ".git", "Makefile", "package.json", "lazy-lock.json" },
            })
        end,
    },

    -- Git plugins
    { "lewis6991/gitsigns.nvim", config = true },
    "tpope/vim-fugitive",

    -- Bracket / pair plugins
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}, -- this is equalent to setup({}) function
    },
    "tpope/vim-surround",
    "AndrewRadev/sideways.vim", -- Swap function arguments

    -- Color scheme
    "rebelot/kanagawa.nvim",

    -- Language specifics
    "pprovost/vim-ps1",
    {
        "snakemake/snakemake",
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/misc/vim/")
        end,
    },
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
        config = true,
    },
    "Nash0x7E2/awesome-flutter-snippets",
    "Shirk/vim-gas",

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = { "mfussenegger/nvim-dap-python" },
        lazy = true,
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

    -- Startup panel
    "mhinz/vim-startify",

    -- Syntax plugins
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    "HiPhish/rainbow-delimiters.nvim",

    { "nvim-treesitter/playground", lazy = true },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup()
        end,
    },

    -- LSP plugins
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },

    -- Completion plugins
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp", -- if you're on windows remove this line
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
            end,
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" } },
        version = "*",
        opts = {
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                ghost_text = { enabled = true },
                list = {
                    selection = {
                        preselect = function(ctx)
                            return ctx.mode ~= "cmdline"
                        end,
                    },
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
                kind_icons = {
                    Text = "󰉿",
                    Method = "m",
                    Function = "󰊕",
                    Constructor = "󰒓",

                    Field = "󰜢",
                    Variable = "󰆦",
                    Property = "󰖷",

                    Class = "",
                    Interface = "",
                    Struct = "",
                    Module = "",

                    Unit = "󰪚",
                    Value = "",
                    Enum = "",
                    EnumMember = "",

                    Keyword = "",
                    Constant = "󰏿",

                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈔",
                    Reference = "",
                    Folder = "󰉋",
                    Event = "",
                    Operator = "",
                    TypeParameter = "",
                },
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "cmdline" },
            },
            keymap = {
                preset = "default",
                ["<C-s>"] = { "snippet_forward", "fallback" },
                ["<C-a>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-y>"] = {
                    function(cmp)
                        cmp.show({ providers = { "snippets" } })
                    end,
                },
                ["<C-l>"] = {
                    function(cmp)
                        cmp.show({ providers = { "lsp" } })
                    end,
                },

                ["<CR>"] = { "accept", "fallback" },

                ["<C-space>"] = { "show", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
            },
        },
        opts_extend = { "sources.default" },
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
                languages = {
                    python = { template = { annotation_convention = "numpydoc" } },
                },
            })
        end,
        lazy = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            -- vim.o.timeout = true
            -- vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    -- file tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = true,
    },

    -- buffer plugins
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        version = "v4.*",
        cond = not vim.g.started_by_firenvim,
    },
    { "ThePrimeagen/harpoon", lazy = true },

    -- Indentation marker and guessing
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = true,
    },
    {
        "nmac427/guess-indent.nvim",
        config = true,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = true,
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "junegunn/fzf",
        build = function()
            vim.cmd([[call fzf#install()]])
        end,
        dependencies = { "junegunn/fzf.vim" },
        lazy = true,
    },

    -- UI sugar
    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = false,
                    },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    }, --
    {
        "nvim-zh/colorful-winsep.nvim",
        config = function()
            require("colorful-winsep").setup({
                highlight = {
                    fg = "#957fb8",
                },
            })
        end,
        event = { "WinNew" },
    },
    "stevearc/dressing.nvim",

    -- github integration
    {
        "pwntester/octo.nvim",
        config = function()
            require("octo").setup({
                suppress_missing_scope = {
                    projects_v2 = true,
                },
            })
        end,
    },

    -- Browser integration
    {
        "glacambre/firenvim",
        cond = not not vim.g.started_by_firenvim,
        build = function()
            require("lazy").load({ plugins = { "firenvim" }, wait = true })
            vim.fn["firenvim#install"](0)
        end,
        config = function()
            vim.opt.guifont = [[JetBrainsMono Nerd Font:h8,CaskaydiaCove Nerd Font:h8]]
            vim.opt.laststatus = 0
            vim.g.firenvim_config = {
                localSettings = {
                    [".*"] = {
                        takeover = "never", -- by default never takeover a text field
                        cmdline = "none", -- to avoid problems with noice.nvim
                    },
                },
            }
        end,
    },
}

require("lazy").setup(plugins)
