local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
  local use = use
  -- add you plugins here like:
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'anott03/nvim-lspinstall'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'BurntSushi/ripgrep'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = {{ 'nvim-lua/plenary.nvim'}}}
  use { 'nvim-treesitter/nvim-treesitter', 
        run = function ()
            local ts_update = require('nvim-treesitter.install')
                                .update({ with_sync = true })
            ts_update()
        end,
    }
  use 'nvim-ts-autotag'
  use 'jiangmiao/auto-pairs'
  end
)

require'flags'
-- require'telescope_config'
require'treesitter_config'
require'lsp_config'
