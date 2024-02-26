require("chatgpt").setup({
  openai_params = {
    model = "gpt-4-0125-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 4096,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
})
vim.keymap.set("n", "<leader>c", "<cmd>ChatGPT<CR>")
