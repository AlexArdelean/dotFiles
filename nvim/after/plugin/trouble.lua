require("trouble").setup {
  filter = { severity = vim.diagnostic.severity.ERROR },
  auto_preview = false,
  use_diagnostic_signs = false,
}

vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",
  { noremap = true, silent = true, desc = "Symbols (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { noremap = true, silent = true, desc = "LSP Definitions / references / ... (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
  { noremap = true, silent = true, desc = "Location List (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",
  { noremap = true, silent = true, desc = "Quickfix List (Trouble)" })
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })

-- vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
-- vim.keymap.set("n", "<leader>t", function() require("trouble").toggle("workspace_diagnostics") end)
-- vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
-- vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
-- vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
-- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
