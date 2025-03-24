local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implmentation() end, opts)
  vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- don't add this function in the `on_attach` callback.
-- `format_on_save` should run only once, before the language servers are active.
lsp_zero.format_on_save({
  format_opts = {
    async = true,
    timeout_ms = 10000,
  },
  servers = {
    ['rust_analyzer'] = { 'rust' },
    ['gopls'] = { 'go' },
  }
})


require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer',
    'clangd',
    'gopls',
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})
require('mason-tool-installer').setup({
  ensure_installed = {
    'eslint_d',
    'stylua',
    'tailwindcss-language-server',
    'lua-language-server',
    'prettierd'
  }
})

-- local cmp = require('cmp')
-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
--
-- cmp.setup({
--   sources = {
--     { name = 'path' },
--     { name = 'nvim_lsp' },
--     { name = 'nvim_lua' },
--     { name = 'luasnip', keyword_length = 2 },
--     { name = 'buffer',  keyword_length = 3 },
--   },
--   formatting = lsp_zero.cmp_format(),
--   mapping = cmp.mapping.preset.insert({
--     ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
--     ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
--     ['<C-l>'] = cmp.mapping.confirm({ select = true }),
--     --['<C-Space>'] = cmp.mapping.complete(),
--   }),
-- })
