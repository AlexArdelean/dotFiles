require("tsc").setup({
  run_as_monorepo = true,
  auto_focus_qflist = true,
  auto_close_qflist = true,
  use_trouble_qflist = true,
})


vim.api.nvim_set_keymap("n", "<leader>to", "<cmd>TSC<cr>",
  { noremap = true, silent = true, desc = "Quickfix List (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>TSCClose<cr>",
  { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
