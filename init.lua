local vim = vim
local key_set = vim.keymap.set

-- FLAGS
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


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
    }
}
local opts = {}

require("lazy").setup(plugins, opts)

-- Treesitter

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "html", "javascript", "python" },
    sync_install = false,
    auto_install = true,
    highlight = true,
    autotag = {
        enable = true
    }
}

-- MASON

require("mason").setup()
require("mason-lspconfig").setup()



vim.cmd("colorscheme gruvbox")


-- LSP

local default_keymaps = function()
    key_set("n", "K", vim.lsp.buf.hover, { noremap = true })
    key_set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true })
    key_set("n", "gd", vim.lsp.buf.definition, { noremap = true })
end

require("lspconfig").lua_ls.setup({
    capabilities = capabilities,
    on_attach = function(client)
        default_keymaps()
        key_set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
    end
})

require("lspconfig").marksman.setup({
    capabilities = capabilities,
    on_attach = function(client)
        default_keymaps()
        key_set("n", "<C-i>", ":w<cr><cmd>execute 'silent !prettier % --write '<cr>", { noremap = true, silent = true })
    end
})

require("lspconfig").sqlls.setup({
    capabilities = capabilities,
    on_attach = function(client)
        default_keymaps()
        print("attaching" .. client.name)
        key_set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
    end
})

require("lspconfig").lemminx.setup({
    capabilities = capabilities,
    on_attach = function(client)
        print("attaching" .. client.name)
        default_keymaps()
        key_set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
    end
})

require("lspconfig").gleam.setup({
    capabilities = capabilities,
    --   on_init = function(client)
    --     client.config.settings("gleam").checkOnSave.overrideCommand = {"gleam", "lsp"}
    --   client.notify("workspace/didChangeConfiguration", {settings = client.config.settings})
    --  end,
    on_attach = function(client)
        print("attaching " .. client.name)
        default_keymaps()
        key_set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
    end
})
-- COMPARE


local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Setup nvim-vmp
local cmp = require 'cmp'

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
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- TELESCOPE

local builtin = require("telescope.builtin")

key_set("n", "<leader>ff", function()
    builtin.find_files({
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
            "-g", "!build/*"
        }
    })
end)
key_set("n", "<leader>fg", builtin.live_grep, { noremap = true })
key_set("n", "<leader>fs", builtin.grep_string, { noremap = true })

-- Clipboard Image

require('clipboard-image').setup({
    default = {
        img_dir = "/home/mka/Pictures/Screenshots",
        img_dir_txt = "/home/mka/Pictures/Screenshots"
    }
})

-- Paste image from clipboard
key_set("n", "<C-p>", ":PasteImg<CR>", { noremap = true })

-- Open image link under the cursor in a markdown file using feh
vim.api.nvim_set_keymap('n', '<Leader>o', ':lua open_image_link_under_cursor()<CR>', { noremap = true, silent = true })

function open_image_link_under_cursor()
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
