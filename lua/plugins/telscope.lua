return { 
    "nvim-telescope/telescope.nvim", 
    dependencies = "tsakirist/telescope-lazy.nvim",
    keys = {
        { 
            "<leader>p", 
            function()
                require('telescope.builtin').find_files({
                    hidden = true,
                    no_ignore = true,
                })
            end,
            desc = "Telescope find_files" 
        },
        { 
            "<leader>g", 
            function()
                require('telescope.builtin').live_grep({
                    additional_args = { "--no-ignore", "--hidden" },
                })
            end,
            desc = "Telescope live_grep" 
        }
    },
    config = function()
        -- デフォルト設定
        local default_config = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules/",
                    ".git/",
                    ".next/",
                    ".cache/",
                    "dist/",
                    "build/",
                    ".DS_Store",
                    "%.lock",
                },
                hidden = true,
                no_ignore = true,
            },
            pickers = {
                find_files = {
                    hidden = true,
                    no_ignore = true,
                },
                live_grep = {
                    additional_args = { "--no-ignore", "--hidden" },
                },
            },
        }
        
        -- プロジェクト固有の設定があればマージ
        if vim.g.project_telescope_config then
            default_config = vim.tbl_deep_extend("force", default_config, vim.g.project_telescope_config)
        end
        
        require('telescope').setup(default_config)
        
        -- telescopeウィンドウの透過設定
        local function setup_telescope_transparency()
          -- telescopeウィンドウの背景を透過
          vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE", default = false })
          vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE", default = false })
        end
        
        -- ColorScheme変更時にも透過設定を適用
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            vim.schedule(setup_telescope_transparency)
          end,
        })
        
        -- 起動時にも透過設定を適用
        vim.schedule(setup_telescope_transparency)
    end,
}

