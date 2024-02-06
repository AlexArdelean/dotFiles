require("vscode_modern").setup({
	cursorline = true,
	transparent_background = false,
	nvim_tree_darker = true,
})

require('material').setup({})
vim.g.material_style = "deep ocean"
vim.keymap.set("n", "<leader>m", "<cmd>lua require('material.functions').find_style()<CR>")

require('onedark').setup {
	style = 'deep'
}
require('onedark').load()

function ColorMyPencils(color)
	color = color or "tokyonight-moon"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
