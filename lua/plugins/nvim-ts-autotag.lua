return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown", "astro", "glimmer", "handlebars", "hbs" },
  config = function()
    -- treesitterがロードされているか確認
    local treesitter_ok = pcall(require, "nvim-treesitter.configs")
    if not treesitter_ok then
      -- treesitterがロードされていない場合は、後で再試行
      vim.defer_fn(function()
        local retry_ok = pcall(require, "nvim-treesitter.configs")
        if retry_ok then
          require("nvim-ts-autotag").setup({
            opts = {
              enable_close = true,
              enable_rename = true,
              enable_close_on_slash = false,
            },
            filetypes = {
              "html", "javascript", "javascriptreact", "typescript", "typescriptreact",
              "svelte", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown",
              "astro", "glimmer", "handlebars", "hbs",
            },
          })
        end
      end, 500)
      return
    end
    
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
