local F = require("akriese.functions")
local map = F.map

-- ALL PLUGIN RELATED mappings
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
map("n", "<leader>k", require('neogen').generate)

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
