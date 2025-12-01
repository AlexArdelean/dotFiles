local capabilities = require("blink.cmp").get_lsp_capabilities()

-- CSS Variables
vim.lsp.enable("css_variables")

-- Go
vim.lsp.config("gopls", {
	capabilities = capabilities,
	root_markers = { "go.mod", "go.work", ".git" },
})

-- LaTeX - ltex
vim.lsp.config("ltex", {
	root_markers = { ".git" },
})

-- LaTeX - texlab
vim.lsp.config("texlab", {
	root_markers = { ".latexmkrc", ".git" },
})

-- Tailwind CSS
vim.lsp.config("tailwindcss", {
	capabilities = capabilities,
	root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", ".git" },
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", '["`]([^"\'`]*).*?["\'`]' },
					{ "cx\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"`)([^']*)(?:'|\"|`)" },
					{ "tv\\(([^)]*)\\)", '["`]([^"\'`]*).*?["\'`]' },
					{ "tv\\(.*?\\).*`([^`]*)`", "([a-zA-Z0-9\\-:]+)" },
				},
			},
		},
	},
})

-- Enable all configured servers
vim.lsp.enable({ "gopls", "ltex", "texlab", "tailwindcss" })

-- LaTeX filetype settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.opt.wrap = true
		vim.opt.linebreak = true
	end,
})
