local globals = require("custom.globals")
local dir_history = globals.dir_history

-- Function to add directory to history
local function add_to_history(dir)
  -- Remove any entries after current position (when going back then changing dir)
  for i = dir_history.current_index + 1, #dir_history.stack do
    dir_history.stack[i] = nil
  end

  -- Add new directory
  table.insert(dir_history.stack, dir)
  dir_history.current_index = #dir_history.stack

  -- Limit history size
  if #dir_history.stack > dir_history.max_size then
    table.remove(dir_history.stack, 1)
    dir_history.current_index = dir_history.current_index - 1
  end
end

-- Function to go back in directory history
local function go_back()
  if dir_history.current_index > 1 then
    dir_history.current_index = dir_history.current_index - 1
    local prev_dir = dir_history.stack[dir_history.current_index]
    vim.cmd('cd ' .. vim.fn.fnameescape(prev_dir))
    print("Back to: " .. prev_dir)
  else
    print("No previous directory")
  end
end

-- Function to go forward in directory history
local function go_forward()
  if dir_history.current_index < #dir_history.stack then
    dir_history.current_index = dir_history.current_index + 1
    local next_dir = dir_history.stack[dir_history.current_index]
    vim.cmd('cd ' .. vim.fn.fnameescape(next_dir))
    print("Forward to: " .. next_dir)
  else
    print("No forward directory")
  end
end

-- Track directory changes
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    local current_dir = vim.fn.getcwd()
    -- Only add if it's different from the current position in history
    if dir_history.stack[dir_history.current_index] ~= current_dir then
      add_to_history(current_dir)
    end
  end
})

-- Initialize with current directory
add_to_history(vim.fn.getcwd())

-- Set up keymaps
vim.keymap.set("n", "<leader>o", go_back, { desc = "Go to previous directory" })
vim.keymap.set("n", "<leader>i", go_forward, { desc = "Go to forward directory" })
