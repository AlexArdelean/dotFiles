-- local custom_sorter = require("top-result-sorter")
local builtin = require('telescope.builtin')

require "telescope".setup {
  defaults = {
    preview = false,
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top" -- search bar at the top
    }
  },
  extensions = {
    frecency = {
      ignore_patterns = { "node_modules/*" }
    }
  }
}

require("telescope").load_extension("live_grep_args")

--vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
--vim.keymap.set('n', '<C-p>', builtin.git_files, {})

--vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader><leader>', "<Cmd>Telescope frecency workspace=CWD<CR>", {})
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- vim.api.nvim_set_keymap("n", "<Leader>fr",
--   [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
--   { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>fo",
--     function()
--       builtin.find_files({
--           sorter = custom_sorter.sorter(),
--           find_command = { "bash", "-c",
--             "PATH=$PATH:~/.cargo/bin rg --files --one-file-system --color never --sort modified" }
--         })
--     end)
