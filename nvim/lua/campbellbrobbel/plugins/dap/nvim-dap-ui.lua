return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    local dapui = require("dapui")
    dapui.setup()

    -- Automatically open upon attach or launch and close when session terminated
    local dap = require("dap")
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end
    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle DAP UI"
    keymap.set("n", "<leader>du", function()
      dapui.toggle()
    end, opts) -- show definition, references

    opts.desc = "Reset DAP UI"
    keymap.set("n", "<leader>dr", function()
      dapui.open({ reset = true })
    end, opts) -- show definition, references
  end,
}
