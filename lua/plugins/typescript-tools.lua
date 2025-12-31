-- typescript-tools.nvim: TypeScript専用の機能強化プラグイン
-- 注意: このプラグインを使用する場合は、lspconfig.luaのts_ls設定をコメントアウトしてください
-- このプラグインは既存のts_ls設定と競合する可能性があります
return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  -- デフォルトでは無効化（必要に応じて有効化）
  enabled = false, -- 有効化する場合は true に変更し、lspconfig.luaのts_ls設定をコメントアウト
  config = function()
    local lsp_defaults = require('lsp.init')
    
    require("typescript-tools").setup({
      -- LSP設定
      on_attach = lsp_defaults.on_attach,
      capabilities = lsp_defaults.get_capabilities(),
      
      -- TypeScript固有の設定
      settings = {
        -- 型情報の表示設定
        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
        -- インポートの自動整理
        organize_imports_on_save = true,
        -- 未使用のインポートを削除
        remove_unused_imports_on_save = true,
        -- 型チェックの設定
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    })
  end,
}
