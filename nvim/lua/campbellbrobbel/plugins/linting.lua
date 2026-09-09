return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    -- detect venv
    local function get_venv()
      local paths = { "./venv", "./.venv" }
      for _, p in ipairs(paths) do
        if vim.fn.isdirectory(p) == 1 then
          return p
        end
      end
      return nil
    end

    local venv = os.getenv("VIRTUAL_ENV") or get_venv()
    local pylint_cmd = "pylint"
    if venv then
      pylint_cmd = venv .. "/bin/pylint"
    end
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "ruff" },
    }

    -- lint.linters.pylint = {
    --   name = "pylint",
    --   cmd = pylint_cmd, -- use venv pylint
    --   args = { "--output-format=text", "--score=n" },
    --   stdin = false,
    --   stream = "stdout",
    -- }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
