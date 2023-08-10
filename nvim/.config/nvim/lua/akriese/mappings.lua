local F = require("akriese.functions")
local map = F.map
local success, wk = pcall(require, "which-key")
if not success then
    return
end

local ok, t_builtins = pcall(require, "telescope.builtin")
if not ok then
    print("Telescope not installed! Mapping won't work!")
end

M = {}

M.setup = function()
    -- PLUGIN RELATED mappings
    map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    map("n", "<leader>T", "<cmd>TSBufToggle highlight<cr>", { desc = "Toggle TS highlight" })
    map("n", "<leader>k", function()
        require("neogen").generate()
    end, { desc = "Generate doc string" })

    -- TELESCOPE
    wk.register({
        f = {
            name = "Find",
            d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
            f = {
                "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>",
                "Files",
            },
            F = {
                "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files prompt_prefix=🔍<cr>",
                "Files w/ ignored",
            },
            g = { "<cmd>Telescope git_files<cr>", "Git files" },
            h = { "<cmd>Telescope help_tags<cr>", "Help" },
            m = { "<cmd>Telescope keymaps<cr>", "Mappings" },
            M = { "<cmd>Telescope noice<cr>", "Messages" },
            o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
            r = { "<cmd>Telescope lsp_references<cr>", "LSP references" },
            b = { "<cmd>Telescope buffers<cr>", "Open buffers" },
            B = {
                function()
                    t_builtins.live_grep({ grep_open_files = true })
                end,
                "Text in open buffers",
            },
            t = { "<cmd>Telescope live_grep<cr>", "Text" }, -- live grep with respect to gitignore and hidden files
            -- includes search in hidden and ignored files
            T = {
                function()
                    t_builtins.live_grep({ additional_args = { "-uu" } })
                end,
                "Text including in ignored files",
            },
            w = { "<cmd>Telescope grep_string<cr>", "String under cursor" },
            -- search in hidden and ignored files too
            W = {
                function()
                    t_builtins.grep_string({ additional_args = { "-uu" } })
                end,
                "String under cursor (also ignored)",
            },
            l = { "<cmd>Telescope flutter commands<cr>", "Flutter commands" },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
        },
    }, { prefix = "<leader>" })

    -- Buffers
    local goto_buffer = {}
    for buffer = 1, 9 do
        goto_buffer[tostring(buffer)] = { "<cmd>BufferLineGoToBuffer " .. buffer .. "<cr>", "Go to buffer " .. buffer }
    end

    wk.register({
        b = vim.tbl_extend("force", goto_buffer, {
            name = "Buffers",
            c = {
                name = "Close",
                l = { "<cmd>BufferLineCloseRight<cr>", "to the right (bufferline)" },
                h = { "<cmd>BufferLineCloseLeft<cr>", "to the left (bufferline)" },
            },
            C = {
                function()
                    local current_buf = vim.api.nvim_get_current_buf()
                    vim.cmd([[BufferLineCycleNext]])
                    vim.cmd("bdelete! " .. current_buf)
                end,

                -- "<cmd>bdelete! | bnext<cr>",
                "Close buffer and next",
            },
            l = { "<cmd>BufferLineCycleNext<cr>", "Go buffer to right" },
            h = { "<cmd>BufferLineCyclePrev<cr>", "Go buffer to left" },
        }),
    }, { prefix = "<leader>", silent = true })

    -- DAP
    local dap, widgets = require("dap"), require("dap.ui.widgets")
    map("n", "<F5>", dap.continue, { silent = true })
    map("n", "<F10>", dap.step_over, { silent = true })
    map("n", "<F11>", dap.step_into, { silent = true })
    map("n", "<F12>", dap.step_out, { silent = true })
    wk.register({
        d = {
            name = "Debugging",
            b = { dap.toggle_breakpoint, "Toggle breakpoint" },
            i = { dap.step_into, "Step into" },
            o = { dap.step_over, "Step over" },
            c = { dap.continue, "Continue" },
            t = { dap.terminate, "Terminate" },
            r = { dap.repl.open, "Open REPL" },
            v = { widgets.sidebar(widgets.scopes).open, "Open variables sidebar" },
        },
    }, { prefix = "<leader>", silent = true })
    map("n", "<leader>K", widgets.hover, { silent = true, desc = "Hover info" })

    -- Git stuff
    wk.register({
        g = {
            name = "Git",
            a = { "<cmd>Git commit --amend<CR>", "Amend" },
            B = { "<cmd>Git blame<CR>", "Open blame" },
            c = { ":Git cherry-pick", "Cherry-pick" },
            g = { "<cmd>Git<CR>", "Open fugitive" },
            -- L = { "<cmd>Gclog<CR>", "" },
            p = { "<cmd>Git pull<CR>", "Pull" },
            P = { "<cmd>Git push<CR>", "Push" },
            U = {
                function()
                    vim.cmd("Git push --set-upstream origin " .. F.current_branch())
                end,
                "Push to new upstream branch",
            },
            l = { "<cmd>Telescope git_commits<CR>", "Commits (log)" },
            L = { "<cmd>Telescope git_bcommits<CR>", "Buffer commits" },
            b = { "<cmd>Telescope git_branches<cr>", "Branches" },
        },
    }, { prefix = "<leader>" })
    map("n", "<leader><", "<cmd>diffget //3<CR>", { desc = "Choose change from right" })
    map("n", "<leader>>", "<cmd>diffget //2<CR>", { desc = "Choose change from left" })

    -- Octo (GitHub integration) commands
    wk.register({
        G = {
            name = "Github",
            p = {
                name = "PR",
                l = { "<cmd>Octo pr list<cr>", "List" },
                c = { ":Octo pr checkout", "Checkout" },
            },
            r = { "<cmd>Octo repo list<cr>", "List repos" },
        },
    }, { prefix = "<leader>" })

    -- Sideways stuff
    map("n", "<leader>,", "<cmd>SidewaysLeft<cr>", { desc = "Switch arguments to left" })
    map("n", "<leader>.", "<cmd>SidewaysRight<cr>", { desc = "Switch arguments to right" })

    -- Info commands
    wk.register({
        i = {
            name = "Info",
            m = { "<cmd>Mason<cr>", "Mason" },
            n = { "<cmd>NullLsInfo<cr>", "null-ls Info" },
            N = { "<cmd>NullLsLog<cr>", "null-ls Log" },
            l = { "<cmd>Lazy<cr>", "Lazy" },
            -- L = {"<cmd>Lazy profile<cr>", "Lazy profile"},
            L = { "<cmd>LspInfo<cr>", "LSP Info" },
            h = { "<cmd>checkhealth<cr>", "Health check" },
        },
    }, {
        prefix = "<leader>",
    })

    ----- NON-PLUGIN keybinds
    -- useful commands
    map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save w/ aucmds" })
    map("n", "<leader>W", "<cmd>noautocmd w<CR>", { desc = "Save w/o aucmds" })
    map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
    map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })
    map("n", "Q", "<Nop>")
    map("n", "Y", "y$")
    map("i", "<C-BS>", "<C-W>")
    map("i", "<C-h>", "<C-W>")

    wk.register({
        s = {
            name = "Set",
            ["hl"] = { "<cmd>set hlsearch!<CR>", "Toggle search highlight" },
            t = {
                function()
                    F.set_tab_width()
                end,
                "Tab width",
            },
            s = {
                function()
                    vim.ui.input({ prompt = "Enter a syntax:" }, function(input)
                        if input ~= nil then
                            vim.opt_local.syntax = input
                        end
                    end)
                end,
                "Syntax",
            },
        },
    }, { prefix = "<leader>" })

    -- recenter after search or jump
    map("n", "n", "nzz")
    map("n", "N", "Nzz")
    map("n", "*", "*zz")
    map("n", "#", "#zz")
    map("n", "J", "mzJ`z")
    map("n", "<C-o>", "<C-o>zz")
    map("n", "<C-i>", "<C-i>zz")
    map("n", "<leader>[", "<cmd>cprevious<cr>zz", { desc = "Go to next qlist entry" })
    map("n", "<leader>]", "<cmd>cnext<cr>zz", { desc = "Go to next qlist entry" })

    -- moving text
    map("v", "<", "<gv")
    map("v", ">", ">gv")
    map("n", "gp", "'[v']")
    map("n", "gP", "'[V']")

    -- vimrc loading and saving
    wk.register({
        v = {
            name = "Config",
            s = { F.source_local_config, "Reload" },
            e = { "<cmd>vsplit $MYVIMRC<CR>", "Open init.lua" },
            f = {
                function()
                    require("telescope.builtin").find_files({
                        cwd = vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":p:h"),
                    })
                end,
                "Find config files",
            },
        },
    }, { prefix = "<leader>" })
    map("n", "<leader>E", function()
        vim.cmd.edit()
    end, { desc = "Re-edit file" })

    -- clipboard shortcuts
    map("n", "<leader>Y", '"*y')
    map("n", "<leader>y", '"+y')
    map("v", "<leader>Y", '"*y')
    map("v", "<leader>y", '"+y')
    map("n", "<leader>P", 'o<esc>"+p', { desc = "Paste to next line" })
    map("n", "<leader>p", '"+p', { desc = "Paste form clipboard" })

    -- Switch between the last two files
    map("n", "<Leader><Leader>", "<C-^>", { desc = "Switch to last file" })

    -- pane resize commands; UP and RIGHT enlarge the pane, DOWN and LEFT decrease size
    map("n", "<M-Up>", "<cmd>resize +5<cr>")
    map("n", "<M-Down>", "<cmd>resize -5<cr>")
    map("n", "<M-Left>", "<cmd>vertical resize -5<cr>")
    map("n", "<M-Right>", "<cmd>vertical resize +5<cr>")

    -- Keymaps to keep me from using arrow keys to navigate
    map("n", "<Left>", "<cmd>echoe 'Use h'<CR>")
    map("n", "<Right>", "<cmd>echoe 'Use l'<CR>")
    map("n", "<Up>", "<cmd>echoe 'Use k'<CR>")
    map("n", "<Down>", "<cmd>echoe 'Use j'<CR>")

    -- go back to insert mode when warning not to use arrow keys in insert mode
    map("i", "<Left>", "<esc>l:echo 'Use h' <bar> star<CR>")
    map("i", "<Right>", "<esc>l:echo 'Use l' <bar> star<CR>")
    map("i", "<Up>", "<esc>l:echo 'Use k' <bar> star<CR>")
    map("i", "<Down>", "<esc>l:echo 'Use j' <bar> star<CR>")

    -- Quicker window movement
    map("n", "<C-j>", "<C-w>j")
    map("n", "<C-k>", "<C-w>k")
    map("n", "<C-h>", "<C-w>h")
    map("n", "<C-l>", "<C-w>l")

    -- Terminal
    map("t", "ii", [[<C-\><C-n>]])

    local term_cmd = ""
    if string.find(vim.o.shell, "zsh") then
        term_cmd = "export THIS='%'; unset ZDOTDIR; zsh"
    elseif string.find(vim.o.shell, "bash") then
        term_cmd = "export THIS='%'; bash"
    else
        -- we assume that this can only be powershell / pwsh
        -- If you want your shell to have access to $THIS, you have to set it explicitly
        -- in another case.
        -- $THIS is a reserved name in powershell / pwsh, thus we cannot use it here
        term_cmd = vim.o.shell
    end

    map("n", "<leader>t", "<cmd>split term://" .. term_cmd .. "<CR><cmd>resize12<cr>", { desc = "Open terminal" })

    wk.register({
        h = { name = "Harpoon" },
        c = { name = "Change cwd", cd = { "<cmd>cd %:p:h<CR><cmd>pwd<CR>", "Change cwd" } },
        l = {
            name = "LSP",
            R = { "<cmd>LspRestart<cr>", "Restart" },
            r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename variable" },
            c = "Latex language select",
        },
    }, { prefix = "<leader>" })
end

M.set_lsp_mappings = function(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    local function buf_set_keymap(...)
        vim.keymap.set(...)
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", vim.lsp.buf.declaration, opts)
    buf_set_keymap("n", "gd", vim.lsp.buf.definition, opts)
    buf_set_keymap("n", "gt", vim.lsp.buf.type_definition, opts)
    buf_set_keymap("n", "K", vim.lsp.buf.hover, opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- This is a weird fix for the visual selection not being used properly in the code_action() call
    buf_set_keymap("v", "<leader>ca", "<Esc>gv<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", vim.lsp.buf.references, opts)
    buf_set_keymap(
        "n",
        "<leader>D",
        vim.diagnostic.open_float,
        vim.tbl_extend("force", opts, { desc = "Hover diagnostics" })
    )
    buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    buf_set_keymap("n", "]d", vim.diagnostic.goto_next, opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

return M
