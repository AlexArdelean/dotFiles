require("typescript-tools").setup {
  debug = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.codeActionProvider = false
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "<leader>vrf", function()
      vim.cmd("TSToolsRenameFile")
    end, opts)
    vim.keymap.set("n", "<leader>ff", function()
      vim.cmd("TSToolsAddMissingImports")
      vim.lsp.buf.format()
    end, opts)
  end,
  settings = {
    tsserver_file_preferences = {
      module = "esnext",
      moduleResolution = "bundler",
    },
    tsserver_format_options = {},
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    tsserver_max_memory = "auto",
    disable_member_code_lens = true,
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
}
