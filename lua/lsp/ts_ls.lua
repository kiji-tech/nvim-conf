-- TypeScript Language Server (ts_ls) の設定

-- lsp/init.lua から共通設定を取得します
local lsp_defaults = require('lsp.init')

-- vim.lsp.start() の代わりに、nvim-lspconfig プラグインのヘルパーを使用します
-- Neovim 0.11以降でも、ほとんどのユーザーは 'nvim-lspconfig' プラグインを併用しています。
-- プラグインをインストールしていない場合は、先にインストールしてください。

local lspconfig = require('lspconfig')

lspconfig.ts_ls.setup({
  -- lsp/init.lua で定義した共通の on_attach 関数を使用します
  on_attach = lsp_defaults.on_attach,
  -- lsp/init.lua で定義した共通の capabilities を使用します
  capabilities = lsp_defaults.capabilities,

  -- ts_ls 固有の設定があればここに記述します
  settings = {
    typescript = {
      disableSemanticValidation = true,
    },
    javascript = {
      disableSemanticValidation = true,
    }
  },
})

lspconfig.enable('ts_ls')
