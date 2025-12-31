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
      git = {
        enable = true,
        ignore = false,
      },
    }
    
    -- プロジェクト固有の設定があればマージ
    if vim.g.project_tree_config then
      default_config = vim.tbl_deep_extend("force", default_config, vim.g.project_tree_config)
    end
    
    require("nvim-tree").setup(default_config)
    
    -- <leader>b でトグル（設定内でも設定）
    vim.keymap.set('n', '<leader>b', function()
      -- nvim-treeのAPIを使用してトグル
      local api = require("nvim-tree.api")
      api.tree.toggle({ focus = false })
    end, { desc = "Toggle nvim-tree", silent = true, noremap = true })
  end,
}
