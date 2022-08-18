local F = require("akriese.functions")
local map = F.map

local telescope = require('telescope')
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
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

local live_grep_with_hidden_ignored = function()
    require("telescope.builtin").live_grep({ additional_args = function(_)
        return {"-uu"} -- pass flag to search in hidden and ignored files too
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

map("n", "<leader>gl", "<cmd>Telescope git_commits<CR>")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
