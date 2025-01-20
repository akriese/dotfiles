local lsps = {
    "asm_lsp",
    "bashls",
    "clangd",
    -- "emmet_ls",
    "kotlin_language_server",
    "ltex",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    -- "ts_ls",
}

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = lsps,
})

require("neodev").setup({})

local nvim_lsp = require("lspconfig")
local F = require("akriese.functions")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    require("akriese.mappings").set_lsp_mappings(bufnr)

    if client.server_capabilities.documentFormattingProvider or client.server_capabilities.document_formatting then
        F.set_autocmd("BufWritePre", function()
            vim.lsp.buf.format({
                filter = function(client)
                    return client.name ~= "ts_ls"
                end,
            })
        end, { buffer = bufnr })
    end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local non_default_servers = {}

-- map buffer local keybindings when the language server attaches
local opts = {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}

-- Latex setup
local ltex_settings = vim.tbl_extend("force", opts, {
    settings = {
        ltex = {
            -- language = 'en-US'
        },
    },
    filetypes = { "bib", "markdown", "plaintex", "rst", "tex" },
})

local setup_latex = function(lang, settings)
    settings.settings.ltex.language = lang
    vim.lsp.stop_client(vim.lsp.get_clients())
    nvim_lsp.ltex.setup(settings)
end

local choose_ltex_lang = function(settings)
    local languages = { "en-US", "de-DE" }
    local prompt = "Choose a language for the Latex LSP. Enter the corresponding number (q for quit):\n"
    for index, lang in ipairs(languages) do
        prompt = prompt .. index .. ": " .. lang .. "\n"
    end
    local result = F.enter_number(prompt)
    if result == nil then
        return
    end
    local idx = result
    if idx > #languages or idx < 1 then
        print("Number out of range!")
        return
    end
    print("Starting latex LSP with " .. languages[idx] .. " as language...")
    setup_latex(languages[idx], settings)
end

setup_latex("en-US", ltex_settings)
table.insert(non_default_servers, "ltex")

F.map("n", "<leader>lc", function()
    choose_ltex_lang(ltex_settings)
end, { desc = "Switch latex language" })

local server_settings = {
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippets = "Replace",
                },
                format = {
                    enable = false,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                    },
                },
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}

local default_config_servers = vim.tbl_filter(function(x)
    return not vim.tbl_contains(non_default_servers, x)
end, lsps)

-- Use a loop to conveniently call 'setup' on multiple servers and
for _, server in ipairs(default_config_servers) do
    local settings = server_settings[server]
    if settings == nil then
        nvim_lsp[server].setup(opts)
    else
        nvim_lsp[server].setup(vim.tbl_deep_extend("force", opts, server_settings[server]))
    end
end

-- flutter setup
require("flutter-tools").setup({
    debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
        run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
        -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
        -- see |:help dap.set_exception_breakpoints()| for more info
        exception_breakpoints = {},
        register_configurations = function(_)
            require("dap").configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
        end,
    },
    lsp = {
        on_attach = on_attach,
        capabilities = capabilities,
    },
})

-- e.g. for null ls formatters that Mason offers
local non_ls_mason_installed = {
    "black",
    "flake8",
    "isort",
    "ktlint",
    "prettier",
    "stylua",
}
-- TODO: put this into a command
-- require("mason.api.command").MasonInstall(non_ls_mason_installed)

-- null-ls
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.flake8.with({
            extra_args = { "--max-line-length", "88" }, -- set to black's length
        }),
        -- null_ls.builtins.formatting.isort.with({
        --     args = {
        --         "--format",
        --         "black",
        --         "--stdout",
        --         "--filename",
        --         "$FILENAME",
        --         "-",
        --     },
        -- }),
        null_ls.builtins.formatting.black.with({
            extra_args = { "--fast" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.code_actions.refactoring, -- install plugin
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.ktlint,
    },
    on_attach = on_attach,
})

require("typescript-tools").setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        expose_as_code_action = "all",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
        },
        tsserver_plugins = {
            -- install with `npm i -g @styled/typescript-styled-plugin typescript-styled-plugin`
            "@styled/typescript-styled-plugin",
        },
    },
})
