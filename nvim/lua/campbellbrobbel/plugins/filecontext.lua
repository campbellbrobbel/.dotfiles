return {
  dir = vim.fn.stdpath("config") .. "/lua/campbellbrobbel/custom/filecontext",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>fz",
      function()
        require("filecontext").pick_and_copy()
      end,
      desc = "Copy files to clipboard",
    },
  },
}
