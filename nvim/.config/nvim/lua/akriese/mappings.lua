local F = require("akriese.functions")
local map = F.map

-- PLUGIN RELATED mappings
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
map("n", "<leader>T", "<cmd>TSBufToggle highlight<cr>")
map("n", "<leader>k", function() require('neogen').generate() end)
map("n", "<leader>lr", "<cmd>LspRestart<cr>")

-- TELESCOPE
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>")
map("n", "<leader>fF", "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files prompt_prefix=🔍<cr>")
map("n", "<leader>fg", "<cmd>Telescope git_files<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
map("n", "<leader>fM", "<cmd>Telescope noice<cr>")
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>")
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>ft", "<cmd>Telescope live_grep<cr>") -- live grep with respect to gitignore and hidden files
-- includes search in hidden and ignored files
map("n", "<leader>fT", function()
    require("telescope.builtin").live_grep({ additional_args = { "-uu" } })
end)
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>")
-- search in hidden and ignored files too
map("n", "<leader>fW", function()
    require("telescope.builtin").grep_string({ additional_args = { "-uu" } })
end)
map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>gL", "<cmd>Telescope git_bcommits<CR>")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
map("n", "<leader>fl", "<cmd>Telescope flutter commands<cr>")
map("n", "<leader>fp", "<cmd>Telescope projects<cr>")

-- DAP
local dap, widgets = require('dap'), require 'dap.ui.widgets'
map("n", "<F5>", dap.continue, { silent = true })
map("n", "<F10>", dap.step_over, { silent = true })
map("n", "<F11>", dap.step_into, { silent = true })
map("n", "<F12>", dap.step_out, { silent = true })
map("n", "<leader>db", dap.toggle_breakpoint, { silent = true })
map("n", "<leader>di", dap.step_into, { silent = true })
map("n", "<leader>do", dap.step_over, { silent = true })
map("n", "<leader>dc", dap.continue, { silent = true })
map("n", "<leader>dt", dap.terminate, { silent = true })
map("n", "<leader>dr", dap.repl.open, { silent = true })
map("n", "<leader>dv", widgets.sidebar(widgets.scopes).open, { silent = true })
map("n", "<leader>K", widgets.hover, { silent = true })

-- Git stuff
map("n", "<leader>ga", "<cmd>Git commit --amend<CR>")
map("n", "<leader>gB", "<cmd>Git blame<CR>")
map("n", "<leader>gc", ":Git cherry-pick")
map("n", "<leader>gg", "<cmd>Git<CR>")
map("n", "<leader>gL", "<cmd>Gclog<CR>")
map("n", "<leader>gP", "<cmd>Git push<CR>")
map("n", "<leader>guP", function() vim.cmd("Git push --set-upstream origin " .. F.current_branch()) end)
map("n", "<leader>gp", "<cmd>Git pull<CR>")
map("n", "<leader><", "<cmd>diffget //3<CR>")
map("n", "<leader>>", "<cmd>diffget //2<CR>")

-- Octo (GitHub integration) commands
map("n", "<leader>opl", "<cmd>Octo pr list<cr>")
map("n", "<leader>opc", ":Octo pr checkout")
map("n", "<leader>orl", "<cmd>Octo repo list<cr>")

-- Sideways stuff
map("n", "<leader>,", "<cmd>SidewaysLeft<cr>")
map("n", "<leader>.", "<cmd>SidewaysRight<cr>")

-- BUFFERLINE
map("n", "<leader>L", "<cmd>BufferLineCycleNext<cr>")
map("n", "<leader>H", "<cmd>BufferLineCyclePrev<cr>")

for buffer = 1, 9 do
    map("n", "<leader>" .. buffer, "<cmd>BufferLineGoToBuffer " .. buffer .. "<cr>", { silent = true })
end

----- NON-PLUGIN keybinds
-- useful commands
map("n", "<leader>shl", "<cmd>set hlsearch!<CR>")
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>W", "<cmd>noautocmd w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>qa<CR>")
map("n", "Q", "<Nop>")
map("n", "Y", "y$")
map("i", "<C-BS>", '<C-W>')
map("i", "<C-h>", '<C-W>')
map("n", "<leader>st", function() F.set_tab_width() end)

-- recenter after search or jump
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "J", "mzJ`z")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<leader>[", '<cmd>cprevious<cr>zz')
map("n", "<leader>]", '<cmd>cnext<cr>zz')

-- moving text
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "gp", "'[v']")
map("n", "gP", "'[V']")

-- vimrc loading and saving
map("n", "<leader>sv", F.source_local_config)
map("n", "<leader>ev", "<cmd>vsplit $MYVIMRC<CR>")

-- clipboard shortcuts
map("n", "<leader>Y", '"*y')
map("n", "<leader>y", '"+y')
map("v", "<leader>Y", '"*y')
map("v", "<leader>y", '"+y')
map("n", "<leader>P", 'o<esc>"+p')
map("n", "<leader>p", '"+p')

-- Switch between the last two files
map("n", "<Leader><Leader>", "<C-^>")

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

map("n", "<leader>t", "<cmd>split term://" .. term_cmd .. "<CR><cmd>resize12<cr>")

map("n", "<leader>cd", "<cmd>cd %:p:h<CR><cmd>pwd<CR>")
