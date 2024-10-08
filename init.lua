local vim = vim
local key_set = vim.keymap.set

-- FLAGS
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.have_nerd_font = true

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
-- vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.hlsearch = true

-- PLUGINS

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'morhetz/gruvbox',
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "dfendr/clipboard-image.nvim",
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'BurntSushi/ripgrep',
    {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install')
                .update({ with_sync = true })
            ts_update()
        end,
    },
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = { "icon" },
                keymaps = { ["<C-h>"] = false, ["<M-h>"] = "actions.select_split", },
                view_options = {
                    show_hidden = true,
                }
            })
            key_set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            key_set("n", "<leader>-", require("oil").toggle_float, { desc = "Open parent directory" })
        end
    },
    {
        "Olical/conjure"
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
vim.cmd("colorscheme tokyonight-moon")


-- Treesitter

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "html", "javascript", "python", "gleam", "java", "fennel", "clojure" },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    autotag = {
        enable = true
    }
}

-- MASON

require("mason").setup()
require("mason-lspconfig").setup()


-- TELESCOPE

require("telescope").setup({
    defaults = {
        path_display = { "filename_first" },
        layout_strategy = "vertical",
        layout_config = { width = 0.95 }
    }
})

local builtin = require("telescope.builtin")

local format_shortcut_keys = "<leader>i"

local default_keymaps = function()
    -- Select All
    key_set('n', "<C-a>", "ggVG<CR>", { noremap = true })
    -- Add Control Chars
    key_set('n', "<leader>acc", [[:lua InsertControlChar(tonumber(vim.fn.input("Enter ASCII value: ")))<CR>]],
        { noremap = true })
    -- Basic movement etc.
    key_set('n', '<Esc>', '<cmd>nohlsearch<CR>')
    key_set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
    key_set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
    key_set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
    key_set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
    key_set("n", "<leader>m", vim.cmd(":messages"), { noremap = true })
    -- General LSP Shortcuts
    key_set("n", format_shortcut_keys, vim.lsp.buf.format, { noremap = true })
    key_set("n", "K", vim.lsp.buf.hover, { noremap = true })
    key_set({ "n", "v" }, "<M-d>", vim.lsp.buf.code_action, { noremap = true })
    key_set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true })
    key_set("n", "gd", vim.lsp.buf.definition, { noremap = true })
    key_set("n", "gi", vim.lsp.buf.implementation, { noremap = true })
    key_set("n", "gt", vim.lsp.buf.type_definition, { noremap = true })
    key_set("n", "<leader>dj", vim.diagnostic.goto_next, { noremap = true })
    key_set("n", "<leader>dk", vim.diagnostic.goto_prev, { noremap = true })
    -- Telescope things
    key_set("n", "<leader>dd", function() vim.cmd("Telescope diagnostics") end, { noremap = true })
    key_set("n", "gr", function() vim.cmd("Telescope lsp_references") end, { noremap = true })
    key_set("n", "<leader>fb", builtin.buffers, { noremap = true })
    key_set("n", "<leader>fg", builtin.live_grep, { noremap = true })
    key_set("n", "<leader>gf", function()
        vim.ui.input({ prompt = "Enter folder to search (leave empty for all): " }, function(input)
            if input then
                if input == "" then
                    require('telescope.builtin').live_grep()
                else
                    require('telescope.builtin').live_grep({ search_dirs = { input } })
                end
            end
        end)
    end, { noremap = true, desc = "Live grep with optional folder input" })
    key_set("n", "<leader>fs", builtin.grep_string, { noremap = true })
    key_set("n", "<leader>ff", function()
        builtin.find_files({
            -- Folders to ignore when doing find files
            find_command = {
                "rg", "--files",
                "--hidden", "--follow",
                "--no-ignore-vcs",
                -- Git folders to ignore
                "-g", "!.git/",
                -- JS folder to ignore
                "-g", "!node_modules/*",
                -- Python folders to ignore
                "-g", "!.mypy_cache/*",
                "-g", "!*/.mypy_cache/*",
                "-g", "!*/__pycache__/*",
                "-g", "!__pycache__/*",
                -- Gleam build folder
                "-g", "!build/*",
                -- Clojure stff
                "-g", "!.clj-kondo/",
                "-g", "!target/",
                "-g", "!.lsp/",
                "-g", "!.shadow-cljs",
            }
        })
    end)
    -- Trouble shortcuts
    key_set("n", "<leader>xx", function() require("trouble").toggle() end)
    key_set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
    key_set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
    key_set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
    key_set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
    key_set("n", "gR", function() require("trouble").toggle("lsp_references") end)
end

default_keymaps()

-- LSP

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("lspconfig").lua_ls.setup({
    capabilities = capabilities,
    on_attach = function(_)
        key_set('n', "<leader>cc", [[:lua ToggleComment("-- ", vim.v.count)<CR>]], { noremap = true })
    end,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'describe', 'it', 'busted', 'assert.are'
                }
            }
        }
    }
})

require("lspconfig").clojure_lsp.setup({
    capabilities = capabilities,
    on_attach = function(_)
        key_set('n', "<leader>cc", [[:lua ToggleComment("; ", vim.v.count)<CR>]], { noremap = true })
    end,

})

require("lspconfig").marksman.setup({
    capabilities = capabilities,
    on_attach = function(client)
        key_set("n", format_shortcut_keys, ":w<cr><cmd>execute 'silent !prettier % --write '<cr>",
            { noremap = true, silent = true })
    end
})

require("lspconfig").jdtls.setup({
    capabilities = capabilities,
})

require("lspconfig").sqlls.setup({
    capabilities = capabilities,
    on_attach = function(client)
        print("attaching" .. client.name)
    end
})

require("lspconfig").lemminx.setup({
    capabilities = capabilities,
    on_attach = function(client)
        print("attaching" .. client.name)
    end
})


require("lspconfig").gleam.setup({
    capabilities = capabilities,
    cmd = { "gleam", "lsp" },
    on_attach = function(_)
        key_set('n', "<leader>cc", [[:lua ToggleComment("// ", vim.v.count)<CR>]], { noremap = true })
    end
})

require("lspconfig").groovyls.setup({
    capabilities = capabilities,
    on_attach = function(client)
        print("Attaching " .. client.name)
        key_set("n", format_shortcut_keys, ":silent w<cr>:silent !npm-groovy-lint --format % % <cr>",
            { noremap = true, silent = true })
    end
})

require("lspconfig").tsserver.setup {
    capabilities = capabilities,
    on_attach = function(_)
        key_set('n', "<leader>cc", [[:lua ToggleComment("// ", vim.v.count)<CR>]], { noremap = true })
        key_set("n", format_shortcut_keys, ":silent w<cr>:silent !prettier % --write <cr>", { noremap = true, silent = true })
    end
}

require("lspconfig").html.setup {
    capabilities = capabilities,
    on_attach = function(_)
        key_set("n", format_shortcut_keys, ":w<cr><cmd>!prettier % --write <cr>", { noremap = true, silent = true })
    end,
}

require("lspconfig").cssls.setup {
    capabilities = capabilities,
    on_attach = function(_)
        key_set("n", format_shortcut_keys, ":w<cr><cmd>!prettier % --write <cr>", { noremap = true, silent = true })
    end,
}

require("lspconfig").jsonls.setup {
    capabilities = capabilities,
    on_attach = function(_)
        key_set("n", format_shortcut_keys, ":w<cr><cmd>!prettier % --write <cr>", { noremap = true, silent = true })
    end
}

-- COMPARE
-- Setup nvim-cmp

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Clipboard Image

require('clipboard-image').setup({
    default = {
        img_dir = "/home/mka/Media/Screenshots",
        img_dir_txt = "/home/mka/Media/Screenshots"
    }
})

-- Functions and Autocommands

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


function ToggleComment(comment, n)
    for i = 0, n do
        local line = vim.fn.getline('.')
        local start_of_comment, end_of_comment = line:find(comment, 1, true)
        if start_of_comment then
            vim.fn.setline('.', line:sub(end_of_comment + 1))
        else
            vim.fn.setline('.', comment .. line)
        end
        if i ~= n then
            vim.cmd("normal j")
        end
    end
end

function InsertControlChar(char)
    local command = string.format(":put =nr2char(%d)", char)
    vim.cmd(command)
end

-- Paste image from clipboard
key_set("n", "<C-p>", ":PasteImg<CR>", { noremap = true })

-- Open image link under the cursor in a markdown file using feh
function Open_image_link_under_cursor()
    local line = vim.fn.getline('.')
    local image_path = string.match(line, "%((.-)%)")

    if image_path then
        local full_path = vim.fn.expand(image_path)
        if vim.fn.filereadable(full_path) == 1 then
            vim.fn.system(string.format('feh %s &', vim.fn.shellescape(full_path)))
        else
            print('Error: Image file not found!')
        end
    else
        print('Error: No image link under the cursor!')
    end
end

vim.api.nvim_set_keymap('n', '<Leader>o', ':lua Open_image_link_under_cursor()<CR>', { noremap = true, silent = true })
