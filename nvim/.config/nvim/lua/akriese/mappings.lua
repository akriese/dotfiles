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
    map("n", "<leader>k", function()
        require("neogen").generate()
    end, { desc = "Generate doc string" })

    -- TELESCOPE
    wk.add({
        { "<leader>f", group = "Find" },
        {
            "<leader>fB",
            function()
                t_builtins.live_grep({ grep_open_files = true })
            end,
            desc = "Text in open buffers",
        },
        {
            "<leader>fF",
            "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files prompt_prefix=🔍<cr>",
            desc = "Files w/ ignored",
        },
        { "<leader>fM", "<cmd>Telescope noice<cr>", desc = "Messages" },
        {
            "<leader>fT",
            function()
                t_builtins.live_grep({ additional_args = { "-uu" } })
            end,
            desc = "Text including in ignored files",
        },
        {
            "<leader>fW",
            function()
                t_builtins.grep_string({ additional_args = { "-uu" } })
            end,
            desc = "String under cursor (also ignored)",
        },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Open buffers" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        {
            "<leader>ff",
            "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>",
            desc = "Files",
        },
        { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        { "<leader>fl", "<cmd>Telescope flutter commands<cr>", desc = "Flutter commands" },
        { "<leader>fm", "<cmd>Telescope keymaps<cr>", desc = "Mappings" },
        { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
        { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
        { "<leader>ft", "<cmd>Telescope live_grep<cr>", desc = "Text" },
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "String under cursor" },
    })

    -- Buffers
    local buffers_table = {
        { "<leader>b", group = "Buffers" },
    }
    for buffer = 1, 9 do
        table.insert(buffers_table, {
            "<leader>b" .. buffer,
            "<cmd>BufferLineGoToBuffer " .. buffer .. "<cr>",
            desc = "Go to buffer " .. buffer,
        })
    end

    local extra_buffer_cmds = {
        {
            "<leader>bC",
            function()
                local current_buf = vim.api.nvim_get_current_buf()
                vim.cmd([[BufferLineCycleNext]])
                vim.cmd("bdelete! " .. current_buf)
            end,

            desc = "Close buffer and next",
        },
        { "<leader>bc", group = "Close" },
        { "<leader>bch", "<cmd>BufferLineCloseLeft<cr>", desc = "to the left (bufferline)" },
        { "<leader>bcl", "<cmd>BufferLineCloseRight<cr>", desc = "to the right (bufferline)" },
        { "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", desc = "Go buffer to left" },
        { "<leader>bl", "<cmd>BufferLineCycleNext<cr>", desc = "Go buffer to right" },
    }

    for _, v in ipairs(extra_buffer_cmds) do
        table.insert(buffers_table, v)
    end

    wk.add(buffers_table)

    -- DAP
    local dap, widgets = require("dap"), require("dap.ui.widgets")
    map("n", "<F5>", dap.continue, { silent = true })
    map("n", "<F10>", dap.step_over, { silent = true })
    map("n", "<F11>", dap.step_into, { silent = true })
    map("n", "<F12>", dap.step_out, { silent = true })
    wk.add({
        { "<leader>d", group = "Debugging" },
        { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
        { "<leader>di", dap.step_into, desc = "Step into" },
        { "<leader>do", dap.step_over, desc = "Step over" },
        { "<leader>dc", dap.continue, desc = "Continue" },
        { "<leader>dt", dap.terminate, desc = "Terminate" },
        { "<leader>dr", dap.repl.open, desc = "Open REPL" },
        { "<leader>dv", widgets.sidebar(widgets.scopes).open, desc = "Open variables sidebar" },
    })
    map("n", "<leader>K", widgets.hover, { silent = true, desc = "Hover info" })

    -- Git stuff
    wk.add({
        { "<leader>g", group = "Git" },
        { "<leader>gB", "<cmd>Git blame<CR>", desc = "Open blame" },
        { "<leader>gL", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer commits" },
        { "<leader>gP", "<cmd>Git push<CR>", desc = "Push" },
        { "<leader>gF", "<cmd>Git push --force-with-lease<CR>", desc = "Push force with check" },
        { "<leader>g<space>", ":Git ", desc = "Type git command" },
        {
            "<leader>gU",
            function()
                vim.cmd("Git push --set-upstream origin " .. F.current_branch())
            end,
            desc = "Push to new upstream branch",
        },
        { "<leader>ga", "<cmd>Git commit --amend<CR>", desc = "Amend" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
        { "<leader>gc", ":Git cherry-pick", desc = "Cherry-pick" },
        { "<leader>gg", "<cmd>Git<CR>", desc = "Open fugitive" },
        { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Commits (log)" },
        { "<leader>gp", "<cmd>Git pull<CR>", desc = "Pull" },
        { "<leader>gs", "<cmd>Git switch -<CR>", desc = "Switch to previous branch" },
    })
    map("n", "<leader><", "<cmd>diffget //3<CR>", { desc = "Choose change from right" })
    map("n", "<leader>>", "<cmd>diffget //2<CR>", { desc = "Choose change from left" })

    -- Octo (GitHub integration) commands
    wk.add({
        { "<leader>G", group = "Github" },
        { "<leader>Gp", group = "PR" },
        { "<leader>Gpc", ":Octo pr checkout", desc = "Checkout" },
        { "<leader>Gpl", "<cmd>Octo pr list<cr>", desc = "List" },
        { "<leader>Gr", "<cmd>Octo repo list<cr>", desc = "List repos" },
    })

    -- Sideways stuff
    map("n", "<leader>,", "<cmd>SidewaysLeft<cr>", { desc = "Switch arguments to left" })
    map("n", "<leader>.", "<cmd>SidewaysRight<cr>", { desc = "Switch arguments to right" })

    -- Info commands
    wk.add({
        { "<leader>i", group = "Info" },
        { "<leader>iL", "<cmd>LspInfo<cr>", desc = "LSP Info" },
        { "<leader>iN", "<cmd>NullLsLog<cr>", desc = "null-ls Log" },
        { "<leader>ih", "<cmd>checkhealth<cr>", desc = "Health check" },
        { "<leader>il", "<cmd>Lazy<cr>", desc = "Lazy" },
        { "<leader>im", "<cmd>Mason<cr>", desc = "Mason" },
        { "<leader>in", "<cmd>NullLsInfo<cr>", desc = "null-ls Info" },
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

    wk.add({
        { "<leader>s", group = "Set" },
        {
            "<leader>ss",
            function()
                vim.ui.input({ prompt = "Enter a syntax:" }, function(input)
                    if input ~= nil then
                        vim.opt_local.syntax = input
                    end
                end)
            end,
            desc = "Syntax",
        },
        {
            "<leader>st",
            function()
                F.set_tab_width()
            end,
            desc = "Tab width",
        },
    })

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
    wk.add({
        { "<leader>v", group = "Config" },
        { "<leader>ve", "<cmd>vsplit $MYVIMRC<CR>", desc = "Open init.lua" },
        {
            "<leader>vf",
            function()
                require("telescope.builtin").find_files({
                    cwd = vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":p:h"),
                })
            end,
            desc = "Find config files",
        },
        { "<leader>vs", F.source_local_config, desc = "Reload" },
    })
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
    map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
    map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
    map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
    map("t", "<C-l>", [[<C-\><C-n><C-w>l]])

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

    -- TOGGLE stuff
    wk.add({
        { "<leader>tH", "<cmd>TSBufToggle highlight<cr>", desc = "Toggle TS highlight" },
        { "<leader>td", require("dapui").toggle, desc = "DAP UI" },
        { "<leader>th", "<cmd>set hlsearch!<CR>", desc = "Toggle search highlight" },
        { "<leader>tt", "<cmd>split term://" .. term_cmd .. "<CR><cmd>resize12<cr>", desc = "Open terminal" },
        {
            "<leader>tl",
            function()
                if not vim.diagnostic.config().virtual_lines then
                    vim.diagnostic.config({ virtual_lines = { current_line = true } })
                else
                    vim.diagnostic.config({ virtual_lines = false })
                end
            end,
            desc = "Toggle virtual lines for diagnostics",
        },
    })

    wk.add({
        { "<leader>c", group = "Change cwd" },
        { "<leader>cc", "<cmd>cd %:p:h<CR><cmd>pwd<CR>", desc = "Change cwd to current files' directory" },
        { "<leader>cr", "<cmd>ProjectRoot<cr>", desc = "Change cwd to current projects' root" },
        { "<leader>cp", "<cmd>pwd<cr>", desc = "Print current working directory" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>l", group = "LSP" },
        { "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart" },
        { "<leader>lc", desc = "Latex language select" },
        { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename variable" },
    })
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
