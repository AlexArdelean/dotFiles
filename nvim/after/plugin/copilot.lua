local copilot_enabled = true

local function toggle_copilot()
  if copilot_enabled then
    vim.cmd("Copilot disable")
    copilot_enabled = false
    print("Copilot disabled")
  else
    vim.cmd("Copilot enable")
    copilot_enabled = true
    print("Copilot enabled")
  end
end

vim.api.nvim_create_user_command("CopilotToggle", toggle_copilot, {})

vim.g.copilot_no_tab_map = true

vim.keymap.set("n", "<leader>cp", toggle_copilot, { desc = "Toggle Copilot" })
vim.keymap.set('i', '<C-m>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})

vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
