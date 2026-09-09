-- ~/.config/nvim/lua/filecontext/init.lua

local M = {}

function M.setup()
  print("Setting up filecontext.nvim in the init.lua")
  vim.api.nvim_set_keymap(
    "n",
    "<leader>fc",
    "<cmd>lua require('filecontext').pick_and_copy()<cr>",
    { noremap = true, silent = true, desc = "Pick files and copy content to clipboard" }
  )
end

function M.pick_and_copy()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("filecontext requires telescope.nvim", vim.log.levels.ERROR)
    return
  end

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  telescope.find_files({
    prompt_title = "Select Files (<Tab> multi-select, <Enter> copy)",
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()

        -- If nothing multi-selected, use the highlighted entry
        if #selections == 0 then
          selections = { action_state.get_selected_entry() }
        end

        actions.close(prompt_bufnr)

        -- Build clipboard content
        local parts = {}
        for _, entry in ipairs(selections) do
          local path = entry.path or entry.filename
          local f = io.open(path, "r")

          if f then
            local content = f:read("*a")
            f:close()

            local ext = path:match("%.(%w+)$") or "text"
            local relative = path:gsub(vim.fn.getcwd() .. "/", "")

            table.insert(parts, string.format("// %s\n```%s\n%s\n```", relative, ext, content))
          else
            vim.notify("Could not read: " .. path, vim.log.levels.WARN)
          end
        end

        if #parts == 0 then
          vim.notify("No files copied", vim.log.levels.WARN)
          return
        end

        local clipboard_text = table.concat(parts, "\n\n")

        -- + register = system clipboard
        vim.fn.setreg("+", clipboard_text)

        vim.notify(string.format("Copied %d file(s) to clipboard", #parts), vim.log.levels.INFO)
      end)

      return true
    end,
  })
end

return M
