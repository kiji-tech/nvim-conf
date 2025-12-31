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
          prepend_args = {
            "--print-width",
            "100",
            "--tab-width",
            "2",
            "--single-quote",
            "true",
            "--trailing-comma",
            "es5",
          },
        },
      },
    })
  end,
}
