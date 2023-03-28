local mason_installed = {
    "lua_ls",
    "ltex",
    "bashls",
    "clangd",
    "pyright",
    "rust_analyzer",
    "tsserver",
    "emmet_ls"
}

require("mason").setup {}
require("mason-lspconfig").setup {
    ensure_installed = mason_installed
}


require("neodev").setup({})

local nvim_lsp = require('lspconfig')
local F = require "akriese.functions"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('v', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    if client.server_capabilities.documentFormattingProvider or client.server_capabilities.document_formatting then
        F.set_autocmd("BufWritePre", function() vim.lsp.buf.format() end, { buffer = bufnr })
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
        }
    },
    filetypes = { "bib", "markdown", "plaintex", "rst", "tex" }
})

local setup_latex = function(lang, settings)
    settings.settings.ltex.language = lang
    vim.lsp.stop_client(vim.lsp.get_active_clients())
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

F.map("n", "<leader>lc", function() choose_ltex_lang(ltex_settings) end)

-- Lua setup
nvim_lsp.lua_ls.setup(vim.tbl_extend("force", opts, {
    settings = {
        Lua = {
            completion = {
                callSnippets = "Replace"
            }
        }
    }
}))
table.insert(non_default_servers, "lua_ls")

local default_config_servers = vim.tbl_filter(function(x)
    return not vim.tbl_contains(non_default_servers, x)
end, mason_installed)

-- Use a loop to conveniently call 'setup' on multiple servers and
for _, server in ipairs(default_config_servers) do
    nvim_lsp[server].setup(opts)
end

F.map("n", "<leader>lr", "<cmd>LspRestart<cr>")

-- flutter setup
require("flutter-tools").setup {
    debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
        run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
        -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
        -- see |:help dap.set_exception_breakpoints()| for more info
        exception_breakpoints = {},
    },
    lsp = {
        on_attach = on_attach,
        capabilities = capabilities
    }
}
