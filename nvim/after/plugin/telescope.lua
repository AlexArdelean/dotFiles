local builtin = require('telescope.builtin')

require "telescope".setup {
  defaults = {
    preview = false,
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top"  -- search bar at the top
    }
  },
  extensions = {
    frecency = {
      ignore_patterns = { "node_modules/*" }
    }
  }
}

--vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
--vim.keymap.set('n', '<C-p>', builtin.git_files, {})

--vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader><leader>', "<Cmd>Telescope frecency workspace=CWD<CR>", {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
