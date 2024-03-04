require('leetcode').setup({
  arg = "leetcode.nvim",

  lang = "cpp",

  storage = {
    home = vim.fn.stdpath("data") .. "/leetcode",
    cache = vim.fn.stdpath("cache") .. "/leetcode",
  },

  logging = true,

  injector = {
    ["cpp"] = {
      before = { "#include <bits/stdc++.h>", "#include <vector>", "using namespace std;" },
      after = "int main() {}",
    },
  },

  cache = {
    update_interval = 60 * 60 * 24 * 7,
  },

  console = {
    open_on_runcode = true,

    dir = "row",

    size = {
      width = "90%",
      height = "75%",
    },

    result = {
      size = "60%",
    },

    testcase = {
      virt_text = true,

      size = "40%",
    },
  },

  description = {
    position = "left",

    width = "40%",

    show_stats = true,
  },

  hooks = {
    LeetEnter = {},
    LeetQuestionNew = {},
  },

  keys = {
    toggle = { "q", "<Esc>" },
    confirm = { "<CR>" },

    reset_testcases = "r",
    use_testcase = "U",
    focus_testcases = "H",
    focus_result = "L",
  },

  image_support = false,
}
)

vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>")
vim.keymap.set("n", "<leader>li", "<cmd>Leet info<CR>")
vim.keymap.set("n", "<leader>ld", "<cmd>Leet desc<CR>")
vim.keymap.set("n", "<leader>lo", "<cmd>Leet open<CR>")
vim.keymap.set("n", "<leader>lt", "<cmd>Leet tabs<CR>")
vim.keymap.set("n", "<leader>ll", "<cmd>Leet list<CR>")
vim.keymap.set("n", "<leader>lc", "<cmd>Leet console<CR>")
