return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("rose-pine").setup({
      -- バリエーション: "main" (デフォルト), "moon" (暗め), "dawn" (明るめ)
      variant = "main", -- "main", "moon", "dawn" から選択
      
      -- 透過設定
      transparent = true,
      
      -- スタイル設定（コメント、キーワード、関数などの見た目）
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
      
      -- カラーのカスタマイズ（色を直接変更）
      -- highlight_groups = {
      --   -- 例: 背景色を変更
      --   -- ColorColumn = { bg = "overlay" },
      --   -- 例: キーワード色を変更
      --   -- ["@keyword"] = { fg = "pine" },
      -- },
    })

    -- カラースキーマを確実に適用
    vim.cmd("colorscheme rose-pine")
    
    -- カラースキーマが適用されたことを確認
    vim.schedule(function()
      if vim.g.colors_name ~= "rose-pine" then
        vim.cmd("colorscheme rose-pine")
      end
    end)
    
    -- treesitterのハイライトグループを明示的に設定
    -- TypeScriptの予約語（const, let, var, function, classなど）のハイライトを確実に適用
    local function setup_highlight()
      -- treesitterがロードされているか確認
      local treesitter_ok = pcall(require, "nvim-treesitter.configs")
      if not treesitter_ok then
        -- treesitterがロードされていない場合は、後で再試行
        return
      end
      
      -- Keyword ハイライトグループの色を確認し、必要に応じて明示的に設定
      local keyword_hl = vim.api.nvim_get_hl(0, { name = "Keyword" })
      -- rose-pineテーマのデフォルトキーワード色を取得
      local keyword_color = keyword_hl.fg
      if not keyword_color then
        -- rose-pineのデフォルトキーワード色を設定（#ebbcba または #c4a7e7）
        keyword_color = "#ebbcba" -- rose-pineのキーワード色（ローズ）
      end
      
      -- 基本のキーワードハイライト（const, let, var など）
      vim.api.nvim_set_hl(0, "@keyword", { 
        fg = keyword_color,
        bold = true,
        default = false 
      })
      -- const, let, var などの修飾子キーワード（明示的に色を指定）
      vim.api.nvim_set_hl(0, "@keyword.modifier", { 
        fg = keyword_color,
        bold = true,
        default = false 
      })
      -- const, let, var を直接指定（念のため）
      vim.api.nvim_set_hl(0, "@keyword.storage", { 
        fg = keyword_color,
        bold = true,
        default = false 
      })
      -- 関数関連のキーワード
      vim.api.nvim_set_hl(0, "@keyword.function", { link = "Function", default = true })
      -- 演算子キーワード
      vim.api.nvim_set_hl(0, "@keyword.operator", { link = "Operator", default = true })
      -- return キーワード
      vim.api.nvim_set_hl(0, "@keyword.return", { 
        fg = keyword_hl.fg or "#c9d1d9",
        bold = true,
        default = true 
      })
      -- 条件分岐キーワード（if, else, switch など）
      vim.api.nvim_set_hl(0, "@keyword.conditional", { link = "Conditional", default = true })
      -- 繰り返しキーワード（for, while など）
      vim.api.nvim_set_hl(0, "@keyword.repeat", { link = "Repeat", default = true })
      -- インポートキーワード（import, export など）
      vim.api.nvim_set_hl(0, "@keyword.import", { link = "Include", default = true })
      -- TypeScript/JavaScript固有のキーワード
      vim.api.nvim_set_hl(0, "@keyword.type", { link = "Type", default = true })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "rose-pine*",
      callback = setup_highlight,
    })
    
    -- テーマ読み込み後にも設定を適用（treesitterがロードされるまで待つ）
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- treesitterがロードされるまで待つ
        vim.defer_fn(function()
          setup_highlight()
        end, 500)
      end,
    })
    
    -- treesitterがロードされた後に設定を適用
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSConfigLoaded",
      callback = setup_highlight,
      once = true,
    })
    
    -- 即座に設定を適用（treesitterが既にロードされている場合）
    vim.schedule(function()
      setup_highlight()
    end)
  end,
}
