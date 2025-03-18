local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

vim.api.nvim_set_keymap('n', '<leader>t', "<cmd>lua colors(require('telescope.themes').get_dropdown{})<CR>", { noremap = true, silent = true })

local colors_table = {
  "material",
  "onedark",
  "tokyonight",
  "tokyonight-night",
  "tokyonight-storm",
  "tokyonight-day",
  "tokyonight-moon",
  "rose-pine",
  "kanagawa-wave",
  "kanagawa-dragon",
  "kanagawa-lotus",
  "gruvbox",
  "vscode_modern",
}

local function set_color(color)
  if string.sub(color, 1, 7) == "onedark" then
    local style = string.sub(color, 8)
    color = 'onedark'
  end

  if string.sub(color, 1, 8) == "material" then
    require('material.functions').find_style()
  end

  ColorMyPencils(color)
end

function colors(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = colors_table
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection_index = action_state.get_selected_entry().index
        local selected_color = colors_table[selection_index]
        actions.close(prompt_bufnr)
        set_color(selected_color)
      end)
      return true
    end,
  }):find()
end

