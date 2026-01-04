-- Lua標準のテーブルモジュールをロード（キーマップ設定用）
local map = vim.keymap.set

-- LSP capabilitiesの設定（補完機能を有効化）
-- cmp_nvim_lspが利用可能な場合は拡張、そうでない場合は基本capabilitiesを使用
local function get_capabilities()
    local caps = vim.lsp.protocol.make_client_capabilities()
    -- cmp_nvim_lspが利用可能かチェック（安全に読み込む）
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if ok and cmp_nvim_lsp then
        caps = vim.tbl_deep_extend('force', caps, cmp_nvim_lsp.default_capabilities())
    end
    return caps
end

-- LSPサーバーに共通でアタッチする関数
local on_attach = function(client, bufnr)
    -- キーマップの設定
    map('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to Declaration' })
    map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
    map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
    map('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to Implementation' })
    map('n', 'grr', vim.lsp.buf.references, { buffer = bufnr, desc = 'List References' })
    map('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename Symbol' })
    map({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code Action' })
    map('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = 'Format Buffer' })
    
    -- より覚えやすいキーマッピング（定義にジャンプ）
    -- 注: <leader>g は Telescope の live_grep で使用されているため、<leader>jd (jump definition) を使用
    map('n', '<leader>jd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
    map('n', '<C-]>', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
    
    -- Telescopeで定義を選択（複数の定義がある場合や、プレビューしたい場合）
    map('n', '<leader>jD', function()
        local ok, telescope = pcall(require, 'telescope.builtin')
        if ok then
            telescope.lsp_definitions()
        else
            vim.lsp.buf.definition()
        end
    end, { buffer = bufnr, desc = 'Telescope: Go to Definition' })
    
    -- 戻るキー（ジャンプ履歴）
    map('n', '<C-t>', '<C-o>', { buffer = bufnr, desc = 'Go Back (Jump List)' })
    map('n', '<leader><C-o>', '<C-o>', { buffer = bufnr, desc = 'Go Back (Jump List)' })
    
    -- 進むキー（ジャンプ履歴）
    map('n', '<leader><C-i>', '<C-i>', { buffer = bufnr, desc = 'Go Forward (Jump List)' })
end

-- モジュールとしてエクスポート
return {
    on_attach = on_attach,
    get_capabilities = get_capabilities,  -- 関数としてエクスポート
}
