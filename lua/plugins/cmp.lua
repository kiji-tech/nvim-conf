return {
    "hrsh7th/nvim-cmp",
    priority = 1000, -- 高い優先度で読み込む（cmp-nvim-lspより先に）
    dependencies = {
        "L3MON4D3/LuaSnip",       -- スニペットエンジン
        "saadparwaiz1/cmp_luasnip", -- nvim-cmp と LuaSnip の連携（アンダースコア）
        "hrsh7th/cmp-buffer",     -- バッファからの候補
        "hrsh7th/cmp-path",       -- パスからの候補
    },
    config = function()
        -- nvim-cmpを初期化
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        
        -- LuaSnipの設定
        require('luasnip.loaders.from_vscode').lazy_load()

        -- nvim-cmpの初期化を先に行う
        cmp.setup({
            -- 補完を有効化
            enabled = true,
            -- 補完の自動表示設定
            completion = {
                keyword_length = 1, -- 1文字入力で補完を開始
            },
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
            -- 補完ウィンドウの見た目を改善
            formatting = {
                format = function(entry, vim_item)
                    -- 補完ソースの種類を表示
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            -- 補完ウィンドウの見た目
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            -- 補完の動作設定
            experimental = {
                ghost_text = true, -- プレビューテキストを表示
            },
        })
    end
}
