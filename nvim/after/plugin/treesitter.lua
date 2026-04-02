local ensure_installed = {
	"vimdoc",
	"c",
	"lua",
	"vim",
	"query",
	"javascript",
	"typescript",
	"tsx",
	"css",
	"html",
	"json",
	"yaml",
	"markdown",
	"markdown_inline",
}

local installed = require("nvim-treesitter").get_installed()
local to_install = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(installed, lang)
end, ensure_installed)

if #to_install > 0 then
	require("nvim-treesitter").install(to_install)
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
		if ok then
			vim.bo[args.buf].syntax = ""
		end
	end,
})
