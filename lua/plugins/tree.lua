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
        update_cwd = false,
      },
      actions = {
        open_file = {
          quit_on_open = false,
        },
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
      local tree_win = api.tree.winid()
      if tree_win and vim.api.nvim_win_is_valid(tree_win) then
        local current_width = vim.api.nvim_win_get_width(tree_win)
        local new_width = math.max(10, math.min(100, current_width + delta))
        vim.api.nvim_win_set_width(tree_win, new_width)
      end
    end
    
    -- nvim-treeバッファ内でのみ有効なキーマッピング
    local function setup_tree_keymaps(buf)
      -- バッファが有効かどうかを確認
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      
      -- 即座に設定（最初の設定）
      local function set_keymaps_immediately()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        
        -- 既存のキーマッピングを削除
        pcall(vim.api.nvim_buf_del_keymap, buf, "n", "-")
        pcall(vim.api.nvim_buf_del_keymap, buf, "n", ">")
        pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<gt>")
        pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<lt>")
        pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<")
        
        -- - で幅を狭くする（-5）
        pcall(vim.keymap.set, "n", "-", function()
          resize_tree(-5)
        end, { buffer = buf, desc = "Resize tree narrower", silent = true, noremap = true, nowait = true })
        
        -- + で幅を広くする（+5）
        pcall(vim.keymap.set, "n", "+", function()
          resize_tree(5)
        end, { buffer = buf, desc = "Resize tree wider", silent = true, noremap = true, nowait = true })
        
        -- < で幅を狭くする（-5）
        local resize_narrow_script = string.format(
          [[<Cmd>lua local api = require('nvim-tree.api'); local win = api.tree.winid(); if win and vim.api.nvim_win_is_valid(win) then local w = vim.api.nvim_win_get_width(win); vim.api.nvim_win_set_width(win, math.max(10, math.min(100, w - 5))) end<CR>]]
        )
        -- 直接<を設定
        pcall(vim.api.nvim_buf_set_keymap, buf, "n", "<", resize_narrow_script, {
          noremap = true,
          silent = true,
          nowait = true,
        })
        -- <lt>でも設定（念のため）
        pcall(vim.api.nvim_buf_set_keymap, buf, "n", "<lt>", resize_narrow_script, {
          noremap = true,
          silent = true,
          nowait = true,
        })
        
        -- > で幅を広くする（+5）
        local resize_wide_script = string.format(
          [[<Cmd>lua local api = require('nvim-tree.api'); local win = api.tree.winid(); if win and vim.api.nvim_win_is_valid(win) then local w = vim.api.nvim_win_get_width(win); vim.api.nvim_win_set_width(win, math.max(10, math.min(100, w + 5))) end<CR>]]
        )
        -- 直接>を設定
        pcall(vim.api.nvim_buf_set_keymap, buf, "n", ">", resize_wide_script, {
          noremap = true,
          silent = true,
          nowait = true,
        })
        
        -- <gt>でも設定（念のため）
        pcall(vim.keymap.set, "n", "<gt>", function()
          resize_tree(5)
        end, { buffer = buf, desc = "Resize tree wider", silent = true, noremap = true, nowait = true })
        
        -- または <C-w>< と <C-w>> でもリサイズ可能（ウィンドウリサイズの標準キー）
        pcall(vim.keymap.set, "n", "<C-w><lt>", function()
          resize_tree(-5)
        end, { buffer = buf, desc = "Resize tree narrower", silent = true, noremap = true })
        
        pcall(vim.keymap.set, "n", "<C-w><gt>", function()
          resize_tree(5)
        end, { buffer = buf, desc = "Resize tree wider", silent = true, noremap = true })
      end
      
      -- 即座に設定
      set_keymaps_immediately()
      
      -- 少し待ってから再設定（nvim-treeのキーマッピングが後から設定される場合に対応）
      vim.defer_fn(function()
        set_keymaps_immediately()
      end, 100)
      
      -- さらに少し待ってから再設定
      vim.defer_fn(function()
        set_keymaps_immediately()
      end, 300)
    end
    
    -- nvim-treeが開かれたときにキーマッピングを設定
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      pattern = "NvimTree",
      callback = function(args)
        local buf = args.buf
        vim.schedule(function()
          setup_tree_keymaps(buf)
          -- さらに少し待ってから再設定（nvim-treeのキーマッピングが後から設定される場合に対応）
          vim.defer_fn(function()
            setup_tree_keymaps(buf)
          end, 100)
        end)
      end,
    })
    
    -- nvim-treeバッファがフォーカスされたときにもキーマッピングを再設定
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "NvimTree_*",
      callback = function(args)
        local buf = args.buf
        if vim.bo[buf].filetype == "NvimTree" then
          vim.schedule(function()
            setup_tree_keymaps(buf)
          end)
        end
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
    
    -- ファイルを開いたときにツリーを展開する
    local function expand_to_file(filepath)
      if not filepath or filepath == "" then
        return
      end
      
      -- nvim-treeが開いているか確認
      local tree_win = api.tree.winid()
      if not tree_win or not vim.api.nvim_win_is_valid(tree_win) then
        return
      end
      
      -- ファイルパスを正規化
      local normalized_file = vim.fs.normalize(filepath)
      
      -- api.tree.find_fileを使ってファイルを検索して展開
      local success, node = pcall(function()
        return api.tree.find_file(normalized_file)
      end)
      
      if success and node then
        -- 親ディレクトリを再帰的に展開
        local function expand_parents(n)
          if n and n.parent then
            expand_parents(n.parent)
            if n.parent.type == "directory" then
              api.node.expand(n.parent)
            end
          end
        end
        expand_parents(node)
      end
    end
    
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      callback = function(args)
        local buf = args.buf
        local file = vim.api.nvim_buf_get_name(buf)
        if file == "" or vim.bo[buf].filetype == "NvimTree" then
          return
        end
        
        -- nvim-treeが完全に初期化されるまで待つ
        vim.schedule(function()
          expand_to_file(file)
        end)
      end,
    })
  end,
}
