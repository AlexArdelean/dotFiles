leap = require("leap")

leap.opts.case_sensitive = false
leap.opts.vim_opts["go.ignorecase"] = true

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
