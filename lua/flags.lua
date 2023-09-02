local set = vim.opt

set.clipboard = "unnamedplus"
set.expandtab = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.number = true

vim.cmd([[autocmd BufNewFile,BufRead *.tpl setlocal tabstop=2 softtabstop=2 shiftwidth=2 ]])
