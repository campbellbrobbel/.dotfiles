return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local ui = require("harpoon.ui")

    keymap.set(
      "n",
      "<leader>hm",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { desc = "Mark file with harpoon" }
    )
    keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Go to next harpoon mark" })
    keymap.set(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      { desc = "Go to previous harpoon mark" }
    )

    keymap.set("n", "<C-e>", ui.toggle_quick_menu)

    keymap.set("n", "<C-h>", function()
      ui.nav_file(1)
    end, { desc = "Go to first harpoon file" })
    keymap.set("n", "<C-t>", function()
      ui.nav_file(2)
    end, { desc = "Go to second harpoon file" })
    keymap.set("n", "<C-n>", function()
      ui.nav_file(3)
    end, { desc = "Go to third harpoon file" })
    keymap.set("n", "<C-s>", function()
      ui.nav_file(4)
    end, { desc = "Go to fourth harpoon file" })
  end,
}
