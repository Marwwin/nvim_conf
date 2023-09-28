local vim = vim 
local set = vim.keymap.set

local builtin = require("telescope.builtin")
set("n", "<leader>ff", builtin.find_files, {})
set("n", "<leader>fg", builtin.live_grep, {})
set("n", "<leader>fs", builtin.grep_string, {})
set("n", "<leader>fb", builtin.buffers, {})
set("n", "<leader>fd", function () vim.cmd("Telescope diagnostics") end, {})
set("n", "<leader>fr", function () vim.cmd("Telescope lsp_references") end, {})
