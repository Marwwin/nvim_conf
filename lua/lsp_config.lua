local vim = vim
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local set = vim.keymap.set
local builtin = require("telescope.builtin")

-- Util Functions

function ToggleComment(comment, n)
  for i = 0, n do
    local line = vim.fn.getline('.')
    if string.match(line, '^' .. comment) then
      vim.fn.setline('.', string.sub(line, #comment + 1))
    else
      vim.fn.setline('.', comment .. line)
    end
    if i ~= n then
      vim.cmd("normal j")
    end
  end
end

-- LSP

local default_keymaps = function()
  set("n", "K", vim.lsp.buf.hover, { noremap = true })
  set("n", "<leader>sa", vim.lsp.buf.definition, { noremap = true })
  set("n", "<leader>i", vim.lsp.buf.implementation, { noremap = true })
  set("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true })
  set("n", "<leader>j", vim.diagnostic.goto_next, { noremap = true })
  set("n", "<leader>k", vim.diagnostic.goto_prev, { noremap = true })
  set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true })
  set("n", "<leader>dd", vim.diagnostic.open_float, { noremap = true })
  set({ "n", "v" }, "<M-d>", vim.lsp.buf.code_action, { noremap = true })
  set("n", "<leader>ff", builtin.find_files, { noremap = true })
  set("n", "<leader>fg", builtin.live_grep, { noremap = true })
  set("n", "<leader>fs", builtin.grep_string, { noremap = true })
  set("n", "<leader>fb", builtin.buffers, { noremap = true })
  set("n", "<leader>fd", function() vim.cmd("Telescope diagnostics") end, { noremap = true })
  set("n", "<leader>fr", function() vim.cmd("Telescope lsp_references") end, { noremap = true })
end
default_keymaps()

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = function(client)
    set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
  end
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(client)
    print('Attaching to ' .. client.name)
    set('n', "<leader>cc", [[:lua ToggleComment("// ", vim.v.count)<CR>]], { noremap = true })
    set("n", "<C-i>", ":w<cr><cmd>!prettier % --write <cr>", { noremap = true, silent = true })
  end
}

lspconfig.html.setup {
  capabilities = capabilities,
  on_attach = function(client)
    set("n", "<C-i>", ":w<cr><cmd>!prettier % --write <cr>", { noremap = true, silent = true })
  end,
}


lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = function(client)
    print('Attaching to ' .. client.name)
    set('n', "<leader>cc", [[:lua ToggleComment("# ", vim.v.count)<CR>]], { noremap = true })
    set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
  end,
  settings = {
    black = { enabled = true },
    autopep8 = { enabled = false },
    yapf = { enabled = false },
    pylint = { enabled = true, executable = "pylint" },
    pyflakes = { enabled = false },
    pylsp_mypy = { enabled = true },
    pycodestyle = { enabled = false },
    jedi_completion = { fuzzy = true },
    pyls_isort = { fuzzy = true },
  }
}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = function(client)
    print('Attaching to ' .. client.name)
    set('n', "<leader>cc", [[:lua ToggleComment("-- ", vim.v.count)<CR>]], { noremap = true })
    set("n", "<C-i>", vim.lsp.buf.format, { noremap = true })
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
}

-- setup language servers here

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
