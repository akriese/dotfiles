local F = require('akriese.functions')
local dap, dapui = require('dap'), require('dapui')
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🐢', texthl = '', linehl = '', numhl = '' })

require('dap-python').setup('~/anaconda3/envs/debugpy/bin/python')

dapui.setup({
    layouts = {
        {
            elements = {
                'scopes',
                'breakpoints',
                'stacks',
                'watches',
            },
            size = 40,
            position = 'left',
        },
        {
            elements = {
                'repl',
                'console',
            },
            size = 10,
            position = 'bottom',
        },
    },
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7"),
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil, -- Can be integer or nil.
    }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local widgets = require 'dap.ui.widgets'
F.map("n", "<F5>", dap.continue, { silent = true })
F.map("n", "<F10>", dap.step_over, { silent = true })
F.map("n", "<F11>", dap.step_into, { silent = true })
F.map("n", "<F12>", dap.step_out, { silent = true })
F.map("n", "<leader>db", dap.toggle_breakpoint, { silent = true })
F.map("n", "<leader>di", dap.step_into, { silent = true })
F.map("n", "<leader>do", dap.step_over, { silent = true })
F.map("n", "<leader>dc", dap.continue, { silent = true })
F.map("n", "<leader>dt", dap.terminate, { silent = true })
F.map("n", "<leader>dr", dap.repl.open, { silent = true })
F.map("n", "<leader>dv", widgets.sidebar(widgets.scopes).open, { silent = true })
F.map("n", "<leader>K", widgets.hover, { silent = true })

vim.api.nvim_create_autocmd("FileType",
    { pattern = "dap-float", command = "nnoremap <buffer><silent> q <cmd>close!<CR>" })
vim.api.nvim_create_autocmd("FileType",
    { pattern = "dap-float", command = "nnoremap <buffer><silent> <esc> <cmd>close!<CR>" })
