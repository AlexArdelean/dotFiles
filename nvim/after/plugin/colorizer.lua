vim.o.termguicolors = true

-- Neovim 0.12 enables native LSP document-color highlighting by default, but it
-- crashes (document_color.lua:225 assertion) when on_lines fires a request for a
-- stale client id after the server restarts. We use colorizer for swatches anyway,
-- so disable the redundant native feature.
if vim.lsp.document_color and vim.lsp.document_color.enable then
  pcall(vim.lsp.document_color.enable, false)
end

require('colorizer').setup({
  -- 'css';
  -- 'javascript';
  -- 'typescript';
  -- 'html';
  -- 'typescriptreact';
})
