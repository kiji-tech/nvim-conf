-- vim config
require("config.options")
require("config.keymaps")
require("config.lazy")
require('lsp')
-- TypeScript LSP設定は lua/plugins/lspconfig.lua で読み込まれます
-- cmp設定は lua/plugins/cmp.lua で読み込まれます（lazy.nvimが自動管理）

-- プロジェクト固有の設定を読み込む
local function load_project_config()
  local cwd = vim.fn.getcwd()
  local project_config = cwd .. "/.nvim.lua"
  
  if vim.fn.filereadable(project_config) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(project_config))
  end
end

-- ディレクトリ変更時にプロジェクト設定を再読み込み
vim.api.nvim_create_autocmd("DirChanged", {
  callback = load_project_config,
})

-- 起動時にも読み込み
load_project_config()
