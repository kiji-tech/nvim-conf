return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      -- 診断情報の表示設定
      auto_open = false, -- 自動で開かない
      auto_close = false, -- 自動で閉じない
      auto_preview = true, -- プレビューを自動表示
      auto_fold = false, -- 自動で折りたたまない
      signs = {
        -- アイコンの設定
        error = "󰅚",
        warning = "󰀪",
        hint = "󰌶",
        information = "󰋼",
        other = "󰘓",
      },
    })

    -- キーマップの設定
    vim.keymap.set("n", "<leader>xx", function()
      require("trouble").toggle()
    end, { desc = "Toggle Trouble" })
    
    vim.keymap.set("n", "<leader>xw", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Workspace Diagnostics" })
    
    vim.keymap.set("n", "<leader>xd", function()
      require("trouble").toggle("document_diagnostics")
    end, { desc = "Document Diagnostics" })
    
    vim.keymap.set("n", "<leader>xq", function()
      require("trouble").toggle("quickfix")
    end, { desc = "Quickfix List" })
    
    vim.keymap.set("n", "<leader>xl", function()
      require("trouble").toggle("loclist")
    end, { desc = "Location List" })
    
    vim.keymap.set("n", "gR", function()
      require("trouble").toggle("lsp_references")
    end, { desc = "LSP References" })
  end,
}
