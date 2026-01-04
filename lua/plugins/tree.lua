return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>b",
      function()
        local api = require("nvim-tree.api")
        api.tree.toggle({ focus = false })
      end,
      desc = "Toggle nvim-tree",
    },
  },
  config = function()
    -- デフォルト設定
    local default_config = {
      view = {
        width = 30, -- 画面幅を設定（数値で変更可能）
        side = "left", -- "left" または "right"
      },
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        -- 透過設定を有効化
        highlight_opened_files = "name",
        -- ルートディレクトリラベルをカスタム関数で設定
        root_folder_label = function(path)
          if not path or path == "" then
            return "~"
          end
          -- パスからディレクトリ名を取得
          local normalized_path = vim.fs.normalize(path)
          local name = vim.fs.basename(normalized_path)
          -- ルートディレクトリ名を返す（見つからない場合は "~" を返す）
          if name and name ~= "" then
            return name
          end
          -- パスが "/" の場合は "root" を返す
          if normalized_path == "/" then
            return "root"
          end
          return "~"
        end,
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      -- ルートディレクトリの検出を改善
      respect_buf_cwd = true,
      update_cwd = true,
      hijack_cursor = false,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
    }
    
    -- プロジェクト固有の設定があればマージ
    if vim.g.project_tree_config then
      default_config = vim.tbl_deep_extend("force", default_config, vim.g.project_tree_config)
    end
    
    require("nvim-tree").setup(default_config)
    
    -- 幅を変更するキーマッピングを明示的に設定
    local api = require("nvim-tree.api")
    local function resize_tree(delta)
      local tree_win = api.tree.get_tree_win()
      if tree_win and vim.api.nvim_win_is_valid(tree_win) then
        local current_width = vim.api.nvim_win_get_width(tree_win)
        local new_width = math.max(10, math.min(100, current_width + delta))
        vim.api.nvim_win_set_width(tree_win, new_width)
      end
    end
    
    -- nvim-treeバッファ内でのみ有効なキーマッピング
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function(args)
        local buf = args.buf
        -- - で幅を狭くする（-5）
        vim.keymap.set("n", "-", function()
          resize_tree(-5)
        end, { buffer = buf, desc = "Resize tree narrower", silent = true, noremap = true, nowait = true })
        
        -- + で幅を広くする（+5）
        vim.keymap.set("n", "+", function()
          resize_tree(5)
        end, { buffer = buf, desc = "Resize tree wider", silent = true, noremap = true, nowait = true })
        
        -- または <C-w>< と <C-w>> でもリサイズ可能（ウィンドウリサイズの標準キー）
        vim.keymap.set("n", "<C-w><", function()
          resize_tree(-5)
        end, { buffer = buf, desc = "Resize tree narrower", silent = true, noremap = true })
        
        vim.keymap.set("n", "<C-w>>", function()
          resize_tree(5)
        end, { buffer = buf, desc = "Resize tree wider", silent = true, noremap = true })
      end,
    })
    
    -- <leader>b でトグル（設定内でも設定）
    -- 他のプラグインとの競合を避けるため、明示的に設定
    vim.keymap.set('n', '<leader>b', function()
      -- nvim-treeのAPIを使用してトグル
      api.tree.toggle({ focus = false })
    end, { desc = "Toggle nvim-tree", silent = true, noremap = true, nowait = true })
    
    -- treeウィンドウの透過設定
    local function setup_tree_transparency()
      -- treeウィンドウの背景を透過
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE", default = false })
      vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "NONE", default = false })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", default = false })
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", default = false })
    end
    
    -- FileTypeで透過設定を適用
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = setup_tree_transparency,
    })
    
    -- ColorScheme変更時にも透過設定を適用
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.schedule(setup_tree_transparency)
      end,
    })
    
    -- 起動時にも透過設定を適用
    vim.schedule(setup_tree_transparency)
  end,
}
