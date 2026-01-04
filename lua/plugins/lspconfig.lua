return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- lsp/init.lua から共通設定を取得します
    local lsp_defaults = require('lsp.init')

    -- erg を無効化（実行可能ファイルが見つからないため）
    -- Neovim 0.11以降の新しいLSP設定方法で無効化
    pcall(function()
      vim.lsp.disable('erg_language_server')
    end)

    -- TypeScript Language Server (ts_ls) の設定
    -- tsserver は非推奨のため ts_ls を使用
    -- React/React Native対応を含む
    vim.lsp.config('ts_ls', {
      -- lsp/init.lua で定義した共通の on_attach 関数を使用します
      on_attach = lsp_defaults.on_attach,
      -- capabilitiesを安全に取得（lsp/init.luaから取得）
      capabilities = lsp_defaults.get_capabilities(),
      -- TypeScript/JavaScriptファイルで確実にLSPが動作するようにfiletypesを明示的に指定
      filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },

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
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsForModuleExports = true,
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
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsForModuleExports = true,
          },
        },
      },
      -- ルートディレクトリの検出（package.json、tsconfig.json、jsconfig.json、.gitを検出）
      root_dir = function(fname)
        -- fnameが数値の場合は、バッファ番号からファイル名を取得
        if type(fname) == "number" then
          fname = vim.api.nvim_buf_get_name(fname)
        end
        -- fnameが空の場合は、現在のディレクトリを使用
        if not fname or fname == "" then
          return vim.fn.getcwd()
        end
        local root_files = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }
        local root = vim.fs.find(root_files, { path = fname, upward = true })[1]
        return root and vim.fs.dirname(root) or vim.fn.getcwd()
      end,
      -- 単一ファイルモードを有効化（ファイル単体でもLSPが動作するように）
      single_file_support = true,
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

    -- LSPサーバーを有効化（Masonでインストールされたサーバーを使用）
    -- 注意: vim.lsp.enable()は設定を登録した後に呼ぶ必要があります
    vim.schedule(function()
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('html')
    end)
  end,
}
