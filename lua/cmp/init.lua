return {
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            -- 補完ウィンドウの見た目や動作を設定
            snippet = {
                expand = function(args)
                    luasnip.expand(args.body) -- LuaSnip を使ってスニペットを展開
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- キーマップの設定
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(), -- 補完ウィンドウを手動で開く
                ['<C-e>'] = cmp.mapping.abort(),        -- 補完を閉じる
                -- Tab または Enter で候補を選択・確定
                ['<CR>'] = cmp.mapping.confirm({ select = true }), 
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            -- 補完ソースの優先順位を設定
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },  -- LSPからの候補 (最優先)
                { name = 'luasnip' },   -- スニペットからの候補
                { name = 'buffer' },    -- バッファ内の単語からの候補
                { name = 'path' },      -- ファイルパスからの候補
            }),
            -- その他、アイコン表示などの微調整
            formatting = {

            }
        })
    end
}
