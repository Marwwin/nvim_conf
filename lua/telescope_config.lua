local set = vim.keymap.set

local builtin = require("telescope.builtin")

set("n", "<leader>ff", builtin.find_files, {})
set("n", "<leader>fg", builtin.live_grep, {})
set("n", "<leader>fs", builtin.grep_string, {})
set("n", "<leader>fb", builtin.buffers, {})
set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", {buffer=0})
set("n", "<leader>fr>", "<cmd>Telescope lsp_references<cr>", {buffer=0})
