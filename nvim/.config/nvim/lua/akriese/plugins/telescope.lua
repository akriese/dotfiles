local F = require("akriese.functions")

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- rebase interactive, <C-r> already taken by reset default
local git_rebase_interactive = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git rebase --interactive " .. selection.value .. "~")
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

-- create fixup commit for the selected commit
local git_fixup = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git commit --fixup=" .. selection.value)
end

-- rebase from selected commit with autosquash, useful for quick application of fixup commits
local git_rebase_autosquash = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd("Git rebase " .. selection.value .. "~ --autosquash")
end

local git_yank_hash = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.fn.setreg("*", selection.value)
end

-- view diff between two selected commits
-- the diff is from the first selected to the second
-- exactly two commits have to be selected to perform the diff
local git_diff_between = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local selection = current_picker:get_multi_selection()
    if #selection ~= 2 then
        print("Select exactly two commits, please!")
        return
    end
    local first, second = selection[1], selection[2]
    actions.close(prompt_bufnr)
    vim.cmd("Git diff " .. first.value .. ".." .. second.value)
end

telescope.setup({
    defaults = {
        i = {
            -- ["C-k"] = "which_key",
            -- ["C-s"] = "send_to_qflist",
        },
        file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "%.ipynb_checkpoints",
            "%__pycache__",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
    pickers = {
        git_commits = {
            mappings = {
                i = {
                    ["<C-b>i"] = git_rebase_interactive,
                    ["<C-b>a"] = git_rebase_autosquash,
                    ["<C-d>s"] = git_diff_since,
                    ["<C-d>o"] = git_diff_single,
                    ["<C-d>b"] = git_diff_between,
                    ["<C-y>"] = git_yank_hash,
                    ["<C-f>"] = git_fixup,
                },
            },
        },
    },
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("fzf")
telescope.load_extension("flutter")
telescope.load_extension("projects")
telescope.load_extension("noice")
