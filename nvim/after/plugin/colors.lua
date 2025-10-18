-- require("vscode_modern").setup({
-- 	cursorline = true,
-- 	transparent_background = false,
-- 	nvim_tree_darker = true,
-- })

-- require('material').setup({})
-- vim.g.material_style = "deep ocean"

-- require('onedark').setup {
-- 	style = 'deep'
-- }
-- require('onedark').load()

function ColorMyPencils(color)
  color = color or "tokyonight-moon"
  vim.cmd.colorscheme(color)

  --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, 'LineNr', { fg = '#82aaff' })       -- Tokyo blue
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#82aaff' }) -- Light purple/white
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#82aaff' })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#82aaff' })
end

ColorMyPencils()
