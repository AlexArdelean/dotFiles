local lspconfig = require("lspconfig")
local capabilities = require('blink.cmp').get_lsp_capabilities()

lspconfig.ts_ls.setup({
  capabilities = capabilities
})
lspconfig.gopls.setup({
  capabilities = capabilities
})

-- Latex
lspconfig.ltex.setup({})
lspconfig.texlab.setup {}

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
