local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",      -- **これが補完プラグイン本体**
  "hrsh7th/cmp-nvim-lsp",  -- LSPからの候補を取得するソース
  "L3MON4D3/LuaSnip",      -- スニペット（コード片の自動挿入）エンジン
  "saadparwaiz1/cmp-luasnip", -- nvim-cmp と LuaSnip の連携
  "hrsh7th/cmp-buffer",    -- 現在のバッファからの補完ソース
  "hrsh7th/cmp-path",      -- ファイルパスの補完ソース
  spec = {
    --{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
  },
})

vim.lsp.enable("golangci_lint")
