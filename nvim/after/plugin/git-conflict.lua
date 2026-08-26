require('git-conflict').setup({
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = false, -- handled below; the plugin still calls the removed vim.diagnostic.disable()
  list_opener = 'copen', -- command or function to open the conflicts list
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffAdd',
    current = 'DiffText',
  }
})

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('AlexGitConflictDiagnostics', { clear = true }),
  pattern = { 'GitConflictDetected', 'GitConflictResolved' },
  callback = function(args)
    vim.diagnostic.enable(args.match == 'GitConflictResolved', { bufnr = vim.api.nvim_get_current_buf() })
  end,
})

vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)')
vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)')
vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)')
vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)')
vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')
vim.keymap.set("n", "<leader>cl", "<cmd>:GitConflictRefresh<CR><cmd>:GitConflictListQf<CR>")
