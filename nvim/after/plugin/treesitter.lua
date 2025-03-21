require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "vimdoc", "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "css" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
}

function set_treesitter_cwd()
  local current_buffer_path = vim.fn.expand(":TSBufName")
  if current_buffer_path ~= '' then
    local current_directory = vim.fn.fnamemodify(current_buffer_path, ":h")
    vim.cmd('cd ' .. vim.fn.fnameescape(current_directory))
    -- print('CWD changed to: ' .. current_directory)
  else
    -- print('Error: Unable to determine current buffer path.')
  end
end

-- Add an autocmd to call the function when TreeSitter is loaded
vim.api.nvim_exec([[
  augroup SetTreeSitterCWD
      autocmd!
      autocmd FileType * lua set_treesitter_cwd()
  augroup END
]], false)
