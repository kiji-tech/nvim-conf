-- Lua標準のテーブルモジュールをロード（キーマップ設定用）
local map = vim.keymap.set

-- LSPサーバーに共通でアタッチする関数
local on_attach = function(client, bufnr)
    -- キーマップの設定
    map('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to Declaration' })
    map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
    map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
    map('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename Symbol' })
    map({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code Action' })
end
