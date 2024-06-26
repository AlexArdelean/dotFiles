vim.cmd([[command! -nargs=1 ReactComponent lua ReactComponent(<f-args>)]])
vim.cmd([[command! -nargs=1 ReactStyledComponent lua ReactStyledComponent(<f-args>)]])
vim.cmd([[command! -nargs=1 ReactStyledTag lua ReactStyledTag(<f-args>)]])
vim.cmd([[command! -nargs=1 ReactUseState lua ReactUseState(<f-args>)]])
vim.cmd([[command! -nargs=1 ReactFunctionProp lua ReactFunctionProp(<f-args>)]])

vim.api.nvim_set_keymap('n', '<leader>rc', ':ReactComponent<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rsc', ':ReactStyledComponent<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rst', ':ReactStyledTag<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rus', ':ReactUseState<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rfp', ':ReactFunctionProp<Space>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>rcl', ':lua ConsoleLog()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rue', ':lua InsertUseEffect()<CR>', { noremap = true, silent = true })

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
  local capitalized_name = name:gsub("^%l", string.upper)
  local component_code = string.format([[
const Styled%s = styled(%s)`
`
    ]], capitalized_name, capitalized_name)
  InsertComponentCode(component_code)
end

function ReactStyledTag(name)
  local component_code = string.format([[
const %s = styled.div`
`
    ]], name)
  InsertComponentCode(component_code)
end

function ReactUseState(name)
  local capitalized_name = name:gsub("^%l", string.upper)
  local component_code = string.format([[
const [%s, set%s] = useState()
]], name, capitalized_name)
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

function ReactFunctionProp(name)
  local component_code = string.format([[{ %s, }: { %s: any, }]], name)
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

function ConsoleLog()
  -- Get current line number and column number
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Insert console.log() at the current cursor position
  vim.api.nvim_buf_set_text(0, line - 1, col, line - 1, col, { 'console.log()' })

  -- Move cursor inside the parentheses
  vim.api.nvim_win_set_cursor(0, { line, col + 12 })
end

function InsertUseEffect()
  -- Define the useEffect statement
  local useEffect_statement = string.format([[
useEffect(() => {
}, [])
]])

  InsertComponentCode(useEffect_statement)

  -- Get current line number and column number
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- Move cursor to the appropriate position
  vim.api.nvim_win_set_cursor(0, { line - 1, 13 })
end
