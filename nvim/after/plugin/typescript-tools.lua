require("typescript-tools").setup {
  debug = true,
  on_attach = function(client, bufnr)
    -- client.server_capabilities.codeActionProvider = false
    local opts = { buffer = bufnr, noremap = true, silent = true }
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>vrf", function()
      vim.cmd("TSToolsRenameFile")
    end, opts)
    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format({ async = true })
      vim.defer_fn(function()
        vim.cmd("TSToolsAddMissingImports")
        vim.cmd("TSToolsOrganizeImports")
      end, 100)
    end, opts)
  end,
  settings = {
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    expose_as_code_action = {},
    tsserver_path = nil,
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    -- (see 💅 `styled-components` support section)
    tsserver_plugins = {},
    tsserver_max_memory = "auto",
    tsserver_format_options = {},
    tsserver_file_preferences = {},
    tsserver_locale = "en",
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    code_lens = "off",
    disable_member_code_lens = true,
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    }
  },
}
