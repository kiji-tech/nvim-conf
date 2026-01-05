return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- 0 = ファイル名のみ, 1 = 相対パス, 2 = 絶対パス
                    },
                },
            },
        })
    end,
}
