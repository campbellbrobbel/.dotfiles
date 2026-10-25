local on_attach = function(client, bufnr)
  local keymap = vim.keymap -- for conciseness
  local opts = { noremap = true, silent = true }
  opts.buffer = bufnr
  vim.diagnostic.config({
    float = {
      width = 120, -- Larger width
      max_width = 120, -- Maximum width
      max_height = 120, -- Maximum height
      border = "rounded",
      source = "always", -- Show source
      header = "", -- Remove header
      prefix = "", -- Remove prefix
      focusable = true,
      -- Center on screen
      anchor = "SW",
      relative = "editor",
      row = math.floor(vim.o.lines * 0.3), -- 30% from top
      col = math.floor(vim.o.columns * 0.5), -- Centered
      style = "minimal",
    },
  })
  local hover_options = {
    -- Dimensions
    width = 120,
    border = "rounded",
    -- Positioning
    relative = "editor",
    row = math.floor(vim.o.lines * 0.3), -- 30% from top
    col = math.floor(vim.o.columns * 0.5), -- Centered
    -- Style
    focusable = true,
    style = "minimal",
  }

  opts.desc = "Show LSP references"
  keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

  opts.desc = "Go to declaration"
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

  opts.desc = "Show LSP definitions"
  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

  opts.desc = "Show LSP implementations"
  keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

  opts.desc = "Show LSP type definitions"
  keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

  opts.desc = "See available code actions"
  keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

  opts.desc = "Smart rename"
  keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

  opts.desc = "Show buffer diagnostics"
  keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

  opts.desc = "Show project dianostics"
  keymap.set("n", "<leader>pd", "<cmd>Telescope diagnostics<CR>", opts) -- show diagnostics for project

  opts.desc = "Show line diagnostics"
  keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

  opts.desc = "Go to previous diagnostic"
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

  opts.desc = "Go to next diagnostic"
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

  opts.desc = "Show documentation for what is under cursor"
  keymap.set("n", "K", function()
    vim.lsp.buf.hover(hover_options)
  end, opts) -- show documentation for what is under cursor

  opts.desc = "Restart LSP"
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end

local venv = os.getenv("VIRTUAL_ENV")
if venv then
  vim.g.python3_host_prog = venv .. "/bin/python"
end

local servers = {
  { name = "ts_ls", config = { on_attach = on_attach } },
  { name = "html", config = { on_attach = on_attach } },
  { name = "cssls", config = { on_attach = on_attach } },
  { name = "tailwindcss", config = { on_attach = on_attach } },
  { name = "svelte", config = { on_attach = on_attach } },
  {
    name = "lua_ls",
    config = {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    },
  },
  { name = "graphql", config = { on_attach = on_attach } },
  { name = "emmet_ls", config = { on_attach = on_attach } },
  { name = "prismals", config = { on_attach = on_attach } },
  {
    name = "pyright",
    config = {
      on_attach = on_attach,
      settings = {
        python = {
          pythonPath = venv and (venv .. "/bin/python") or "python3",
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
  },
  { name = "clangd", config = { on_attach = on_attach } },
  { name = "terraformls", config = { on_attach = on_attach } },
  { name = "eslint", config = { on_attach = on_attach } },
}

return {
  "williamboman/mason.nvim",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local lspconfig = require("lspconfig")
    local blinkcmp = require("blink.cmp")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local capabilities = blinkcmp.get_lsp_capabilities()
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = vim.tbl_map(function(s)
        return s.name
      end, servers),
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
      handlers = {

        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,
      },
    })

    for _, s in ipairs(servers) do
      vim.lsp.config(s.name, s.config)
      vim.lsp.enable(s.name)
    end

    vim.diagnostic.config({
      virtual_text = true, -- shows message at end of line
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "ruff", -- python linter
        "eslint_d", -- js linter
        "clang-format", -- c and c++ formatter
      },
    })
  end,
}
