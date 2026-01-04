return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      -- 自動インストールするLSPサーバーのリスト
      -- 注: Masonでは ts_ls (typescript-language-server) という名前で管理されます
      -- しかし、lspconfigでは tsserver として設定します
      ensure_installed = {
        "ts_ls",  -- TypeScript/JavaScript LSP (typescript-language-server)
        "lua_ls", -- Lua LSP
        "html",   -- HTML LSP
      },
      -- 自動セットアップを有効化
      automatic_installation = true,
    })
  end,
}
