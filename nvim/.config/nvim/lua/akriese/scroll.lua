local ts_ctx = require("treesitter-context")
require('neoscroll').setup {
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
        '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = "cubic", -- Default easing function
    pre_hook = function() -- Function to run before the scrolling animation starts
        ts_ctx.disable()
        vim.cmd [[TSBufToggle highlight]]
    end,
    post_hook = function() -- Function to run after the scrolling animation ends
        ts_ctx.enable()
        vim.cmd [[TSBufToggle highlight]]
    end,
    performance_mode = false, -- Disable "Performance Mode" on all buffers.
}
