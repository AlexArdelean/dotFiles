local lspconfig = require("lspconfig")
local capabilities = require('blink.cmp').get_lsp_capabilities()

lspconfig.gopls.setup({
  capabilities = capabilities
})

-- Latex
lspconfig.ltex.setup({})
lspconfig.texlab.setup {}
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt.wrap = true
    vim.opt.linebreak = true
  end
})

lspconfig["tailwindcss"].setup({
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(((?:[^()]|\\([^()]*\\))*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" }
        },
      },
    }
  }
})
