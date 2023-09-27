local vim = vim
local lspconfig = require 'lspconfig'
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local set = vim.keymap.set
--
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
	set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
	set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
	set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
	set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
	set("n", " dj", vim.diagnostic.goto_next, { buffer = 0 })
	set("n", " dk", vim.diagnostic.goto_prev, { buffer = 0 })
	set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
	set({ "n", "v" }, "<M-d>", vim.lsp.buf.code_action, { buffer = 0 })
end

lspconfig.gopls.setup {
	capabilities = capabilities,
	on_attach = function(client)
		default_keymaps()
		set("n", "<C-i>", vim.lsp.buf.format, { buffer = 0 })
	end
}

lspconfig.tsserver.setup {
	capabilities = capabilities,
	on_attach = function(client)
		print('Attaching to ' .. client.name)
		default_keymaps()
		set('n', "<leader>cc", [[:lua ToggleComment("// ", vim.v.count)<CR>]], { noremap = true })
		set("n", "<C-i>", ":w<cr><cmd>!prettier % --write <cr>", { buffer = 0 })
	end
}

lspconfig.html.setup {
	capabilities = capabilities,
	on_attach = function(client)
		default_keymaps()
		set("n", "<C-i>", ":w<cr><cmd>!prettier % --write <cr>", { buffer = 0 })
	end,
}


lspconfig.pylsp.setup {
	capabilities = capabilities,
	on_attach = function(client)
		print('Attaching to ' .. client.name)
		default_keymaps()
		set('n', "<leader>cc", [[:lua ToggleComment("# ", vim.v.count)<CR>]], { noremap = true })
		set("n", "<C-i>", vim.lsp.buf.format, { buffer = 0 })
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
		default_keymaps()
		set('n', "<leader>cc", [[:lua ToggleComment("-- ", vim.v.count)<CR>]], { noremap = true })
		set("n", "<C-i>", vim.lsp.buf.format, { buffer = 0 })
	end
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
