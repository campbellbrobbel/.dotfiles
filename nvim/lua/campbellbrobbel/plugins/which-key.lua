return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
    local keymap = vim.keymap -- for conciseness
    local opts = {}
    opts.desc = "Show Which Key"
    keymap.set("n", "<leader>wk", ":WhichKey<CR>", opts)
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
