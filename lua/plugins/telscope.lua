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
    end,
}

