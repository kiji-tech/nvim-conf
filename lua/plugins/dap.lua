return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- DAP UIの設定
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    })

    -- 仮想テキストの設定（変数の値をインライン表示）
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = "<module",
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    })

    -- TypeScript/JavaScript用のデバッガー設定
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    dap.configurations.javascript = {
      {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    dap.configurations.typescript = {
      {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        runtimeExecutable = "node",
        runtimeArgs = { "--loader", "ts-node/esm" },
      },
      {
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    -- キーマップの設定
    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end, { desc = "Debug: Start/Continue" })
    
    vim.keymap.set("n", "<F1>", function()
      dap.step_into()
    end, { desc = "Debug: Step Into" })
    
    vim.keymap.set("n", "<F2>", function()
      dap.step_over()
    end, { desc = "Debug: Step Over" })
    
    vim.keymap.set("n", "<F3>", function()
      dap.step_out()
    end, { desc = "Debug: Step Out" })
    
    -- ブレークポイントのトグル（treeの<leader>bと競合しないように別のキーを使用）
    vim.keymap.set("n", "<leader>db", function()
      dap.toggle_breakpoint()
    end, { desc = "Debug: Toggle Breakpoint" })
    
    vim.keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })
    
    vim.keymap.set("n", "<leader>dr", function()
      dap.repl.open()
    end, { desc = "Debug: Open REPL" })
    
    vim.keymap.set("n", "<leader>dl", function()
      dap.run_last()
    end, { desc = "Debug: Run Last" })

    -- DAP UIの自動表示
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
