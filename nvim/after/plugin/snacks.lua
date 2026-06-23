local Snacks = require("snacks").setup({
  rename = { enabled = true },
  bigfile = { enabled = true }, -- disables expensive features on huge files
  quickfile = { enabled = true }, -- render file before plugins load on direct open
  words = { enabled = true }, -- auto-highlight LSP references under cursor
  indent = { enabled = true }, -- indent guides (replaces indent-blankline)
  scope = { enabled = true }, -- scope text objects + current-scope highlight
  scroll = { enabled = true }, -- smooth scrolling (replaces neoscroll)
  notifier = { enabled = true }, -- vim.notify UI (replaces nvim-notify)
  dashboard = { enabled = true }, -- start screen
  -- explorer = { enabled = true },
  -- input = { enabled = true },
  -- picker = { enabled = true },
  -- statuscolumn = { enabled = true },
})

local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})
