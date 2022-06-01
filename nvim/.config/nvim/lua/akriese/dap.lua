local dap = require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='🐢', texthl='', linehl='', numhl=''})

require('dap-python').setup('~/anaconda3/envs/debugpy/bin/python')
