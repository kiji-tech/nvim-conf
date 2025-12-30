return {
  "hrsh7th/cmp-nvim-lsp",
  dependencies = { "hrsh7th/nvim-cmp" },
  -- nvim-cmpの初期化後に確実に読み込まれるようにする
  after = "nvim-cmp",
  -- 確実に読み込まれるようにする
  event = "InsertEnter",
  -- cmp-nvim-lspは自動的にnvim-cmpに登録されるため、特別な設定は不要
}
