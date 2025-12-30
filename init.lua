-- vim config
require("config.options")
require("config.keymaps")
require("config.lazy")
require('lsp')
-- TypeScript LSP設定は lua/plugins/lspconfig.lua で読み込まれます
-- cmp設定は lua/plugins/cmp.lua で読み込まれます（lazy.nvimが自動管理）
