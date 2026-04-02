-- Enable treesitter highlighting for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

function set_treesitter_cwd()
  local current_buffer_path = vim.fn.expand(":TSBufName")
  if current_buffer_path ~= '' then
    local current_directory = vim.fn.fnamemodify(current_buffer_path, ":h")
    vim.cmd('cd ' .. vim.fn.fnameescape(current_directory))
  end
end

vim.api.nvim_exec([[
  augroup SetTreeSitterCWD
      autocmd!
      autocmd FileType * lua set_treesitter_cwd()
  augroup END
]], false)
