local lspconfig = require("lspconfig")
local capabilities = require('blink.cmp').get_lsp_capabilities()

lspconfig.ts_ls.setup({
  capabilities = capabilities
})
lspconfig.gopls.setup({
  capabilities = capabilities
})

-- lspconfig["tailwindcss"].setup({
-- on_attach = function(client, bufnr)
--   require("tailwindcss-colors").buf_attach(bufnr)
-- end
-- })

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
