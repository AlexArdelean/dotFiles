local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local globals = require("custom.globals")
local dir_history = globals.dir_history

-- Function to show directory history in telescope
local function show_directory_history()
  if #dir_history.stack == 0 then
    print("No directory history available")
    return
  end

  -- Create a copy of the stack with current directory indicator
  local history_entries = {}
  for i, dir in ipairs(dir_history.stack) do
    local display = dir
    if i == dir_history.current_index then
      display = "* " .. dir .. " (current)"
    end
    table.insert(history_entries, {
      display = display,
      path = dir,
      index = i
    })
  end

  pickers.new({}, {
    prompt_title = "Directory History",
    finder = finders.new_table({
      results = history_entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.path,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local selected_dir = selection.value.path
          local selected_index = selection.value.index

          -- Update current index and change directory
          dir_history.current_index = selected_index
          vim.cmd('cd ' .. vim.fn.fnameescape(selected_dir))
          print("Changed to: " .. selected_dir)
        end
      end)

      -- Optional: Add a mapping to remove entries from history
      map("i", "<C-d>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          local index_to_remove = selection.value.index
          table.remove(dir_history.stack, index_to_remove)

          -- Adjust current_index if necessary
          if index_to_remove <= dir_history.current_index then
            dir_history.current_index = math.max(1, dir_history.current_index - 1)
          end

          -- Refresh the picker
          show_directory_history()
        end
      end)

      return true
    end,
  }):find()
end

-- Add keymap for directory history telescope
vim.keymap.set("n", "<leader>fz", show_directory_history, { desc = "Show directory history" })
