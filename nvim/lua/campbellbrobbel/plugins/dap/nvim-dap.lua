return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local keymap = vim.keymap -- for conciseness
    local dap = require("dap")
    local opts = { noremap = true, silent = true }

    opts.desc = "Toggle Debugger Breakpoint"
    keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", opts) -- show definition, references

    opts.desc = "DAP Continue"
    keymap.set("n", "<leader>dc", ":DapContinue<CR>", opts) -- show definition, references

    opts.desc = "DAP Step Over"
    vim.keymap.set("n", "<leader>do", function()
      require("dap").step_over()
    end, opts)

    opts.desc = "DAP Step Into"
    vim.keymap.set("n", "<leader>di", function()
      require("dap").step_into()
    end, opts)

    opts.desc = "DAP Step Out"
    vim.keymap.set("n", "<leader>du", function()
      require("dap").step_out()
    end, opts)

    -- Configure debug adapter
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter", -- Installed via Mason
        args = { "${port}" },
      },
    }

    dap.adapters["node-terminal"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter", -- Installed via Mason
        args = { "${port}" },
      },
    }

    dap.adapters["node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter", -- Installed via Mason
        args = { "${port}" },
      },
    }
    -- DAP configurations
    for _, language in ipairs({ "javascript", "typescript" }) do
      dap.configurations[language] = {
        -- {
        --   name = "Attach Next.js: debug full stack 2",
        --   type = "pwa-node",
        --   request = "attach",
        --   port = 9230,
        --   skipFiles = { "<node_internals>/**" },
        --   resolveSourceMapLocations = {
        --     "${workspaceFolder}/**",
        --     "!**/node_modules/**",
        --     "!**/.next/**",
        --     "**/$KNOWN_TOOLS$/**",
        --   },
        --   webRoot = vim.fn.getcwd(),
        --   protocol = "inspector",
        --   sourceMaps = true,
        --   userDataDir = false,
        -- },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Next.js",
          port = 9230,
          skipFiles = { "<node_internals>/**" },
          outFiles = { "${workspaceFolder}/.next/**/*.js" },
          -- sourceMapPathOverrides = {
          --   ["/turbopack/[project]/*"] = "${webRoot}/*",
          -- },
          sourceMaps = true,
          remoteRoot = "/usr/src/app",
          restart = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach Select",
          processId = require("dap.utils").pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          port = 9230,
        },
        {
          address = "127.0.0.1",
          localRoot = "${workspaceFolder}/app/mediaos",
          name = "Attach to MOS 2",
          port = 9230,
          remoteRoot = "/usr/src/app",
          request = "attach",
          trace = true,
          sourceMaps = true,
          skipFiles = {
            "<node_internals>/**",
          },
          type = "pwa-node",
        },
        -- {
        --   name = "Regular attach",
        --   type = "pwa-node",
        --   request = "attach",
        --   processId = require("dap.utils").pick_process,
        --   port = 9230,
        --   skipFiles = { "<node_internals>/**" },
        --   outFiles = { "${workspaceFolder}/.next/**/*.js" },
        --   sourceMaps = true,
        -- },
        {
          name = "Next.js: debug full stack test launch",
          type = "node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/.bin/next",
          runtimeArgs = { "--inspect" },
          skipFiles = { "<node_internals>/**" },
          serverReadyAction = {
            action = "debugWithEdge",
            killOnServerStop = true,
            pattern = "- Local:.+(https?://.+)",
            uriFormat = "%s",
            webRoot = "${workspaceFolder}",
          },
        },
        -- {
        --   type = "pwa-node",
        --   request = "launch",
        --   name = "Launch file",
        --   program = "${file}",
        --   cwd = "${workspaceFolder}",
        -- },
        -- {
        --   name = "Takehome Test Attach 9229 2",
        --   request = "attach",
        --   type = "pwa-node",
        --   port = 9229,
        --   restart = true,
        --   localRoot = "${workspaceFolder}",
        --   trace = true,
        -- },
        -- {
        --   name = "Takehome Test Attach",
        --   request = "attach",
        --   type = "pwa-node",
        --   port = 9230,
        --   restart = true,
        --   localRoot = "${workspaceFolder}",
        --   remoteRoot = "/usr/src/app",
        --   trace = true,
        -- },
        -- {
        --   name = "Takehome Test Attach 2",
        --   request = "attach",
        --   type = "pwa-node",
        --   port = 9230,
        --   restart = true,
        --   localRoot = "${workspaceFolder}",
        --   skipFiles = { "<node_internals>/**" },
        --   trace = true,
        -- resolveSourceMapLocations = {
        --   "${workspaceFolder}/**",
        --   "!**/node_modules/**",
        --   "!**/.next/**",
        -- },
        --   -- sourceMapPathOverrides = {
        --   --   ["webpack://_N_E/*"] = "${workspaceFolder}/*",
        --   --   ["webpack:///*"] = "${workspaceFolder}/*",
        --   -- },
        --   -- resolveSourceMapLocations = {
        --   --   "${workspaceFolder}/**",
        --   --   "!**/node_modules/**",
        --   -- },
        -- },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach",
        --   processId = require("dap.utils").pick_process,
        --   port = 9230,
        --   cwd = "${workspaceFolder}",
        -- },
        -- {
        --   type = "pwa-node",
        --   request = "attach",
        --   name = "Attach 9229",
        --   processId = require("dap.utils").pick_process,
        --   port = 9229,
        --   cwd = "${workspaceFolder}",
        -- },
        -- {
        --   type = "node-terminal",
        --   name = "Attach to Remote Next.js",
        --   request = "attach",
        --   address = "127.0.0.1",
        --   port = 9229,
        --   localRoot = "${workspaceFolder}",
        --   remoteRoot = "${workspaceFolder}",
        --   skipFiles = { "<node_internals>/**" },
        -- },
        -- {
        --   type = "pwa-node", -- Uses the Node.js debug adapter
        --   request = "launch", -- Launch new instance (vs 'attach')
        --   name = "Launch Next.js", -- Name in debug menu
        --   runtimeExecutable = "npm", -- Use npm to run
        --   runtimeArgs = { "run", "dev" }, -- Command to execute
        --   port = 9229, -- Debug port
        --   cwd = "${workspaceFolder}", -- Run in project root
        --   console = "integratedTerminal", -- Use Neovim's terminal
        -- },
        -- {
        --   name = "Next.js: debug server-side",
        --   type = "node-terminal",
        --   request = "launch",
        --   command = "npm run dev",
        -- },
        -- {
        --   name = "Next.js: debug client-side",
        --   type = "chrome",
        --   request = "launch",
        --   url = "http://localhost:3000",
        -- },
        -- {
        --   name = "Next.js: debug client-side (Firefox)",
        --   type = "firefox",
        --   request = "launch",
        --   url = "http://localhost:3000",
        --   reAttach = true,
        --   pathMappings = {
        --     {
        --       url = "webpack://_N_E",
        --       path = "${workspaceFolder}",
        --     },
        --   },
        -- },
        -- {
        --   name = "Next.js: debug full stack",
        --   type = "node",
        --   request = "launch",
        --   program = "${workspaceFolder}/node_modules/.bin/next",
        --   -- runtimeArgs = { "--inspect" },
        --   skipFiles = { "<node_internals>/**" },
        --   serverReadyAction = {
        --     action = "debugWithEdge",
        --     killOnServerStop = true,
        --     pattern = "- Local:.+(https?://.+)",
        --     uriFormat = "%s",
        --     webRoot = "${workspaceFolder}",
        --   },
        -- },
        -- {
        --   type = "node-terminal",
        --   name = "Attach with Reconnect",
        --   request = "attach",
        --   port = 9230,
        --   restart = true,
        --   continueOnAttach = true,
        --   cwd = "${workspaceFolder}",
        --   skipFiles = { "<node_internals>/**" },
        -- },
      }
    end
  end,
}
