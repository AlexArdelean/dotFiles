require("typescript-tools").setup {
  debug = true,
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
