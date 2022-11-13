local mason_installed = {
    "sumneko_lua",
    "ltex",
    "bashls",
    "clangd",
    "pyright",
    "rust_analyzer",
    "tsserver",
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
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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

nvim_lsp.ltex.setup(vim.tbl_extend("force", opts, {
    settings = {
        ltex = {
            language = 'de-DE'
            -- language = 'en-US'
        }
    },
    filetypes = { "bib", "markdown", "plaintex", "rst", "tex" }
}))
table.insert(non_default_servers, "ltex")

nvim_lsp.sumneko_lua.setup(vim.tbl_extend("force", opts, {
    settings = {
        Lua = {
            completion = {
                callSnippets = "Replace"
            }
        }
    }
}))
table.insert(non_default_servers, "sumneko_lua")

local default_config_servers = vim.tbl_filter(function(x)
    return vim.tbl_contains(non_default_servers, x)
end, mason_installed)

if vim.fn.executable("dart") then
    table.insert(default_config_servers, "dartls")
end

-- Use a loop to conveniently call 'setup' on multiple servers and
for _, server in ipairs(default_config_servers) do
    nvim_lsp[server].setup(opts)
end

F.map("n", "<leader>lr", "<cmd>LspRestart<cr>")

