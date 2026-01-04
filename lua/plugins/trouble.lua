return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble" },
    { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix List" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "gR", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References" },
  },
  config = function()
    require("trouble").setup({
      -- 診断情報の表示設定
      auto_open = true, -- 診断情報がある場合に自動で開く
      auto_close = false, -- 自動で閉じない
      auto_preview = true, -- プレビューを自動表示
      auto_fold = false, -- 自動で折りたたまない
      mode = "workspace_diagnostics", -- デフォルトのモード
      position = "bottom", -- ウィンドウの位置（bottom, top, left, right）
      height = 10, -- ウィンドウの高さ
      width = 50, -- ウィンドウの幅
      icons = true, -- アイコンを表示
      fold_open = "v", -- 折りたたみが開いている時のアイコン
      fold_closed = ">", -- 折りたたみが閉じている時のアイコン
      group = true, -- グループ化する
      padding = true, -- パディングを追加
      cycle_results = true, -- 結果を循環する
      action_keys = {
        -- キーマップの設定
        close = "q", -- 閉じる
        cancel = "<esc>", -- キャンセル
        refresh = "r", -- リフレッシュ
        jump = { "<cr>", "<tab>" }, -- ジャンプ
        jump_close = { "o" }, -- ジャンプして閉じる
        toggle_mode = "m", -- モードを切り替え
        switch_severity = "s", -- 重要度を切り替え
        toggle_preview = "P", -- プレビューを切り替え
        hover = "K", -- ホバー
        preview = "p", -- プレビュー
        close_folds = { "zM", "zm" }, -- 折りたたみを閉じる
        open_folds = { "zR", "zr" }, -- 折りたたみを開く
        toggle_fold = { "za", "zA" }, -- 折りたたみを切り替え
        previous = "k", -- 前へ
        next = "j", -- 次へ
      },
      multiline = true, -- 複数行を表示
      indent_lines = true, -- インデントラインを表示
      win_config = { border = "single" }, -- ウィンドウの境界線
      signs = {
        -- アイコンの設定
        error = "󰅚",
        warning = "󰀪",
        hint = "󰌶",
        information = "󰋼",
        other = "󰘓",
      },
    })

    -- キーマップをconfig内でも設定（確実に動作するように）
    vim.keymap.set("n", "<leader>xx", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Toggle Trouble", silent = true, noremap = true })
    
    vim.keymap.set("n", "<leader>xw", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Workspace Diagnostics", silent = true, noremap = true })
    
    vim.keymap.set("n", "<leader>xd", function()
      require("trouble").toggle("document_diagnostics")
    end, { desc = "Document Diagnostics", silent = true, noremap = true })
    
    vim.keymap.set("n", "<leader>xq", function()
      require("trouble").toggle("quickfix")
    end, { desc = "Quickfix List", silent = true, noremap = true })
    
    vim.keymap.set("n", "<leader>xl", function()
      require("trouble").toggle("loclist")
    end, { desc = "Location List", silent = true, noremap = true })
    
    vim.keymap.set("n", "gR", function()
      require("trouble").toggle("lsp_references")
    end, { desc = "LSP References", silent = true, noremap = true })

    -- 起動時に診断情報がある場合に自動で開く
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- すべてのバッファの診断情報をチェック
        local has_diagnostics = false
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local diagnostics = vim.diagnostic.get(bufnr)
          if #diagnostics > 0 then
            has_diagnostics = true
            break
          end
        end
        
        if has_diagnostics then
          vim.defer_fn(function()
            require("trouble").open("workspace_diagnostics")
          end, 200)
        end
      end,
    })

    -- 診断情報が更新されたときに自動で開く
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function()
        -- 診断情報がある場合、Troubleが閉じている場合は開く
        local diagnostics = vim.diagnostic.get(0)
        if #diagnostics > 0 then
          -- Troubleウィンドウが開いているかチェック
          local trouble_open = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match("Trouble") then
              trouble_open = true
              break
            end
          end
          
          -- Troubleが閉じている場合は開く
          if not trouble_open then
            require("trouble").open("workspace_diagnostics")
          end
        end
      end,
    })
  end,
}
