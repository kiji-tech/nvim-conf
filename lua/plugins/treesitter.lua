return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- プラグインが正しくロードされているか確認
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter not loaded. Please run :Lazy sync", vim.log.levels.WARN)
      return
    end

    configs.setup({
      -- パーサーの自動インストールを有効化
      auto_install = true,
      -- シンタックスハイライトを有効化
      highlight = {
        enable = true,
        -- 大きなファイルでも動作するように設定
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
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
