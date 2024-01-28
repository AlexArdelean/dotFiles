-- Define the command to insert a component
vim.cmd([[command! -nargs=1 ReactComponent lua ReactComponent(<f-args>)]])
vim.cmd([[command! -nargs=1 ReactStyledComponent lua ReactStyledComponent(<f-args>)]])

vim.api.nvim_set_keymap('n', '<leader>rc', ':ReactComponent<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rs', ':ReactStyledComponent<Space>', { noremap = true, silent = true })

function ReactComponent(name)
  local component_code = string.format([[
const %s = () => {
  return (
    <>
    </>
  );
}
    ]], name)
  InsertComponentCode(component_code)
end

function ReactStyledComponent(name)
  local component_code = string.format([[
const %s = styled.div`
`
    ]], name)
  InsertComponentCode(component_code)
end

function InsertComponentCode(component_code)
  -- Get the current cursor position
  local line_number = vim.fn.line('.')
  local col_number = vim.fn.col('.')

  -- Insert the component code at the current cursor position
  vim.fn.append(line_number, vim.split(component_code, "\n"))

  -- Restore the cursor position
  vim.fn.cursor(line_number + #vim.split(component_code, "\n") - 1, col_number)
end

