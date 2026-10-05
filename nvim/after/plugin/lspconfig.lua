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
	cmd_env = { JAVA_OPTS = "-Xmx512m" },
	filetypes = { "tex", "plaintex", "bib", "markdown" },
	root_markers = { ".git" },
})

-- LaTeX - texlab
vim.lsp.config("texlab", {
	root_markers = { ".latexmkrc", ".git" },
})

-- Tailwind CSS
vim.lsp.config("tailwindcss", {
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/tailwindcss-language-server", "--stdio" },
	capabilities = capabilities,
	-- lspconfig's root_dir falls back to .git, which starts a second server at the repo root for non-tailwind files
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_files = require("lspconfig.util").insert_package_json(
			{ "tailwind.config.js", "tailwind.config.ts", "postcss.config.js" },
			"tailwindcss",
			fname
		)
		local found = vim.fs.find(root_files, { path = fname, upward = true })[1]
		if found then
			on_dir(vim.fs.dirname(found))
		end
	end,
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
