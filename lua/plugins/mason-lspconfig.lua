return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      -- 自動インストールするLSPサーバーのリスト
      ensure_installed = {
        "ts_ls",  -- TypeScript/JavaScript LSP (tsserverから変更)
        "lua_ls", -- Lua LSP
      },
      -- 自動セットアップを有効化
      automatic_installation = true,
    })
  end,
}
