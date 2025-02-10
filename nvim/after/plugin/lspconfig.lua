local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({})
lspconfig.gopls.setup({})

-- lspconfig["tailwindcss"].setup({
-- on_attach = function(client, bufnr)
--   require("tailwindcss-colors").buf_attach(bufnr)
-- end
-- })

lspconfig["tailwindcss"].setup({
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

-- Trying to always do absolute imports
lspconfig.ts_ls.setup({
  settings = {
    typescript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifier = "non-relative",
      },
    },
  }
})
