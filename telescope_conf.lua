local set = vim.keymap.set
local telescope = require('telescope')

set("n", "?", telescope.builtin.find_files(telescope.themes.get_dropdown{previewer = false}), {buffer=0})
