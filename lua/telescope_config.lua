local set = vim.keymap.set

set("n", "?", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", {buffer=0})
