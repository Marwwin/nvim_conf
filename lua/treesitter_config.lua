require'nvim-treesitter.configs'.setup{
    ensure_installed = { "c", "lua", "vim", "vimdoc", "html", "javascript", "python"},
    sync_install = false,
    auto_install = true,
    highlight = true,
    autotag = {
        enable = true
    }
}
