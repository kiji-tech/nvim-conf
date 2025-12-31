return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
      -- 自動インストールするツールのリスト
      ensure_installed = {
        -- フォーマッター
        "prettier", -- TypeScript/JavaScript用
        "stylua",   -- Lua用
        -- デバッガー
        "node-debug2-adapter", -- Node.jsデバッガー
      },
      -- 自動更新を有効化
      auto_update = false,
      -- 起動時に自動インストール
      run_on_start = true,
    })
  end,
}
