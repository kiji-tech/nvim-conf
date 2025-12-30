return { 
    "nvim-telescope/telescope.nvim", 
    dependencies = "tsakirist/telescope-lazy.nvim",
    keys = {
        { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Telescope find_files" },
        { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope live_grep" }
    }
}

