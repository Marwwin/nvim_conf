local vim = vim
local set = vim.opt

set.clipboard = "unnamedplus"
set.expandtab = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.number = true
set.relativenumber = true
set.autoread = true
set.swapfile = false

vim.g.leader = ","

vim.o.swapfiles = false
vim.g.mapleader = ","
vim.cmd("colorscheme gruvbox")

-- 2 space tabs for .tpl files
vim.cmd([[autocmd BufNewFile,BufRead *.tpl setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab=true ]])
vim.cmd([[autocmd BufNewFile,BufRead *.lua setlocal tabstop=2 softtabstop=2 shiftwidth=2 ]])
