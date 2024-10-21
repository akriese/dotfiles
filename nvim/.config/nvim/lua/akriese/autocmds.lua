local F = require("akriese.functions")
local map = F.map
local set_autocmd = F.set_autocmd

vim.api.nvim_create_augroup("vimrcEx", { clear = true })

--autocmd!
-- Set syntax highlighting for specific file types
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=markdown", { pattern = "*.md" })
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=json", { pattern = ".{jscs,jshint,eslint}rc" })
set_autocmd(
    { "BufRead", "BufNewFile" },
    "set filetype=sh",
    { pattern = { "aliases.local", "zshrc.local", "*/zsh/configs/*" } }
)
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=gitconfig", { pattern = "gitconfig.local" })
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=tmux", { pattern = "tmux.conf.local" })
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=vim", { pattern = "vimrc.local" })
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=sh", { pattern = "*bashrc" })
set_autocmd({ "BufRead", "BufNewFile" }, "set syntax=gas", { pattern = "*.S" })
set_autocmd({ "BufRead", "BufNewFile" }, "set filetype=c", { pattern = "*.h" })

-- remove trailing whitespace on saving
set_autocmd("BufWritePre", F.remove_trailing_spaces)

set_autocmd("WinEnter", function()
    vim.o.cursorline = true
    if vim.o.number == true then
        vim.o.relativenumber = true
    end
end)
set_autocmd("WinLeave", function()
    vim.o.cursorline = false
    if vim.o.number then
        vim.o.relativenumber = false
    end
end)

set_autocmd(
    { "BufRead", "BufNewFile" },
    "set filetype=snakemake commentstring=#%s",
    { pattern = { "Snakefile", "*.smk", "*.smk.py" } }
)

set_autocmd({ "BufEnter" }, function()
    local opts = { buffer = true }
    map("n", "r", ":FlutterReload<cr>", opts)
    map("n", "R", ":FlutterRestart<cr>", opts)
    map("n", "q", ":FlutterQuit<cr>", opts)
    map("n", "c", ":FlutterLogClear<cr>", opts)
    map("n", "d", ":FlutterDetach<cr>", opts)
end, { pattern = "__FLUTTER_DEV_LOG__" })
