return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  config = function()
    require("conform").setup({
      -- フォーマッターの設定
      formatters_by_ft = {
        -- TypeScript/JavaScript用のフォーマッター
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        -- その他の言語
        lua = { "stylua" },
        markdown = { "prettier" },
        yaml = { "prettier" },
      },
      -- 保存時に自動フォーマット
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      -- フォーマッターの設定
      formatters = {
        prettier = {
          -- .prettierrcを自動的に読み込むようにする
          -- prepend_argsを削除することで、Prettierがプロジェクトの.prettierrcを自動検出
        },
      },
    })
  end,
}
