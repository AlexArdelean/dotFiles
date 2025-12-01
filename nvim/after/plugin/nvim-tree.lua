vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
	sync_root_with_cwd = true,
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
		adaptive_size = true,
		float = {
			enable = false,
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
		exclude = { "logs", ".env" },
	},
	update_focused_file = {
		enable = true,
		update_root = false,
		ignore_list = {},
	},
	diagnostics = {
		enable = true,
	},
})

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")
