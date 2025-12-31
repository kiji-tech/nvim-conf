return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- lsp/init.lua から共通設定を取得します
    local lsp_defaults = require('lsp.init')

    -- Neovim 0.11以降の新しいLSP設定方法
    -- TypeScript Language Server (ts_ls) の設定
    -- React/React Native対応を含む
    -- vim.lsp.config() は第1引数にLSP名（文字列）、第2引数に設定テーブルを受け取ります
    vim.lsp.config('ts_ls', {
      -- lsp/init.lua で定義した共通の on_attach 関数を使用します
      on_attach = lsp_defaults.on_attach,
      -- capabilitiesを安全に取得（lsp/init.luaから取得）
      capabilities = lsp_defaults.get_capabilities(),

      -- TypeScript/JavaScript 固有の設定
      settings = {
        typescript = {
          -- 型チェックの設定
          check = {
            enable = true,
          },
          -- インポートの自動解決
          preferences = {
            importModuleSpecifier = 'relative',
            includePackageJsonAutoImports = 'on',
          },
          -- React/React Native用の設定
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          -- 完了候補の設定
          suggest = {
            completeFunctionCalls = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
          },
        },
        javascript = {
          -- JavaScript用の設定
          check = {
            enable = true,
          },
          preferences = {
            importModuleSpecifier = 'relative',
            includePackageJsonAutoImports = 'on',
          },
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            completeFunctionCalls = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
          },
        },
      },
      -- ルートディレクトリの検出（package.json、tsconfig.json、jsconfig.json、.gitを検出）
      root_dir = function(fname)
        local root_files = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }
        local root = vim.fs.find(root_files, { path = fname, upward = true })[1]
        return root and vim.fs.dirname(root) or vim.fn.getcwd()
      end,
    })

    -- HTML Language Server の設定
    vim.lsp.config('html', {
      on_attach = lsp_defaults.on_attach,
      capabilities = lsp_defaults.get_capabilities(),
      filetypes = { "html", "htm" },
      settings = {
        html = {
          format = {
            wrapLineLength = 120,
            wrapAttributes = "auto",
          },
          hover = {
            documentation = true,
            references = true,
          },
        },
      },
    })

    -- LSPサーバーを有効化
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('html')
  end,
}
