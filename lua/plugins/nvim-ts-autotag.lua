return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown", "astro", "glimmer", "handlebars", "hbs" },
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        -- 有効にするファイルタイプ
        enable_close = true,      -- 終了タグの自動補完を有効化
        enable_rename = true,     -- タグ名変更時の自動更新を有効化
        enable_close_on_slash = false, -- </ で終了タグを補完
      },
      -- ファイルタイプごとの設定
      filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "astro",
        "glimmer",
        "handlebars",
        "hbs",
      },
    })
  end,
}
