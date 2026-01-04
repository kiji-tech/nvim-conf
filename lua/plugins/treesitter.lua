return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- treesitterを優先的にロード
  priority = 100,
  -- lazy = false を設定して起動時に確実にロード
  lazy = false,
  config = function()
    -- treesitterプラグインが正しくインストールされているか確認
    -- まず、メインモジュールがロードできるか確認
    local ok, ts = pcall(require, "nvim-treesitter")
    if not ok then
      -- プラグインがロードできない場合は、後で再試行
      vim.defer_fn(function()
        local retry_ok, retry_ts = pcall(require, "nvim-treesitter")
        if retry_ok then
          -- メインモジュールから設定を試行
          retry_ts.setup({
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = { "typescript", "javascript", "tsx", "jsx" },
          })
        end
      end, 500)
      return
    end

    -- configsモジュールを安全に読み込む
    local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not configs_ok or not configs then
      -- configsモジュールが見つからない場合は、メインモジュールから設定
      ts.setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = { "typescript", "javascript", "tsx", "jsx" },
      })
      return
    end

    -- 標準的な設定方法（configsモジュールを使用）
    configs.setup({
      -- パーサーの自動インストールを有効化
      auto_install = true,
      -- シンタックスハイライトを有効化
      highlight = {
        enable = true,
        -- Vimの正規表現ベースのハイライトを無効化してtreesitterのハイライトを優先
        additional_vim_regex_highlighting = false,
        -- 大きなファイルでも動作するように設定
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      -- TypeScript/JavaScriptのパーサーを確実にインストール
      ensure_installed = { "typescript", "javascript", "tsx", "jsx" },
      -- インデント設定
      indent = {
        enable = true,
      },
      -- インクリメンタル選択を有効化
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
