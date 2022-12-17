local F = require("akriese.functions")
local map = F.map

local telescope = require('telescope')
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- rebase interactive, <C-r> already taken by reset default
local git_rebase_interactive = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git rebase --interactive " .. selection.value)
end

-- view diff since selected commit
local git_diff_since = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git diff " .. selection.value)
end

-- view diff of selected commit
local git_diff_single = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git show " .. selection.value)
end

-- view diff between two selected commits
-- the diff is from the first selected to the second
-- exactly two commits have to be selected to perform the diff
local git_diff_between = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local selection = current_picker:get_multi_selection()
    if #selection ~= 2 then
        print('Select exactly two commits, please!')
        return
    end
    local first, second = selection[1], selection[2]
    actions.close(prompt_bufnr)
    vim.cmd("Git diff " .. first.value .. ".." .. second.value)
end

telescope.setup {
    defaults = {
        i = {
            -- ["C-k"] = "which_key",
            -- ["C-s"] = "send_to_qflist",
        },
        file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "%.ipynb_checkpoints",
            "%__pycache__"
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    },
    pickers = {
        git_commits = {
            mappings = {
                i = {
                    ["<C-b>i"] = git_rebase_interactive,
                    ["<C-d>s"] = git_diff_since,
                    ["<C-d>o"] = git_diff_single,
                    ["<C-d>b"] = git_diff_between
                },
            }
        }
    }
}

local live_grep_with_hidden_ignored = function()
    require("telescope.builtin").live_grep({ additional_args = function(_)
        return { "-uu" } -- pass flag to search in hidden and ignored files too
    end })
end

local grep_string_with_hidden_ignored = function()
    require("telescope.builtin").grep_string({ additional_args = function(_)
        return { "-uu" } -- pass flag to search in hidden and ignored files too
    end })
end

map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")
map("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>")
map("n", "<leader>fF", "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files prompt_prefix=🔍<cr>")
map("n", "<leader>fg", "<cmd>Telescope git_files<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>")
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
map("n", "<leader>ft", "<cmd>Telescope live_grep<cr>") -- live grep with respect to gitignore and hidden files
map("n", "<leader>fT", live_grep_with_hidden_ignored) -- same but includes search in hidden and ignored files
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>")
map("n", "<leader>fW", grep_string_with_hidden_ignored)

map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>gL", "<cmd>Telescope git_bcommits<CR>")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
map("n", "<leader>fl", "<cmd>Telescope flutter commands<cr>")
map("n", "<leader>fp", "<cmd>Telescope projects<cr>")


-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension('flutter')
telescope.load_extension('projects')
