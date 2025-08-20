require("luasnip.loaders.from_vscode").lazy_load()

require('blink.cmp').setup({
  keymap = {
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
    ['<C-l>'] = { 'select_and_accept' },

    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
    -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

    -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lsp = { fallbacks = {}, },
    },
  },
  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
        blocked_filetypes = { 'javascriptreact', 'typescriptreact' }
      }
    }
  }
})
