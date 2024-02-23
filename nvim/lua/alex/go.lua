function GoModTidy()
  -- Get the directory of the current buffer
  local current_dir = vim.fn.expand('%:p:h')
  print(current_dir)
  vim.cmd('lcd ' .. current_dir)
  vim.cmd([[ !go mod tidy ]])
  vim.cmd([[ LspRestart ]])
end

vim.api.nvim_set_keymap('n', '<leader>gmt', ':lua GoModTidy()<CR>', { noremap = true, silent = true })
