-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
-- vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

require("telekasten").setup({

  -- Main paths
  home                        = vim.fn.expand("~/Documents/notes"),
  dailies                     = vim.fn.expand("~/Documents/notes/dailies"),
  weeklies                    = vim.fn.expand("~/Documents/notes/weeklies"),
  templates                   = vim.fn.expand("~/Documents/notes/templates"),

  extension                   = ".md",

  -- Generate note filenames. One of:
  -- "title" (default) - Use title if supplied, uuid otherwise
  -- "uuid" - Use uuid
  -- "uuid-title" - Prefix title by uuid
  -- "title-uuid" - Suffix title with uuid
  new_note_filename           = "title",
  uuid_type                   = "%Y%m%d%H%M",
  uuid_sep                    = "-",

  follow_creates_nonexisting  = true,
  dailies_create_nonexisting  = true,
  weeklies_create_nonexisting = true,

  journal_auto_open           = false,
  image_link_style            = "wiki",

  -- Default sort option: 'filename', 'modified'
  sort                        = "modified",
  install_syntax              = true,
  tag_notation                = "#tag",

  -- When linking to a note in subdir/, create a [[subdir/title]] link
  -- instead of a [[title only]] link
  subdirs_in_links            = true,
  command_palette_theme       = "ivy",

  -- Tag list theme:
  -- get_cursor (small tag list at cursor)
  -- dropdown (window)
  -- ivy (bottom panel)
  show_tags_theme             = "ivy",

  -- Previewer for media files (images mostly)
  -- "telescope-media-files" if you have telescope-media-files.nvim installed
  -- "catimg-previewer" if you have catimg installed
  -- "viu-previewer" if you have viu installed
  media_previewer             = "telescope-media-files",

  -- Customize insert image and preview image files list. This is useful
  -- to add optional filetypes into filtered list (for example
  -- telescope-media-files optionally supporting svg preview)
  media_extensions            = {
    ".png",
    ".jpg",
    ".bmp",
    ".gif",
    ".pdf",
    ".mp4",
    ".webm",
    ".webp",
  },

  plug_into_calendar          = true,
  calendar_opts               = {
    weeknm = 4,
    calendar_monday = 0,
    calendar_mark = 'left-fit',
  },

  vaults                      = {
    personal = { }
  },

  clipboard_program           = "", -- xsel, xclip, wl-paste, osascript
})

local function open_today_note()
  local today = os.date("%Y-%m-%d")
  local note_path = vim.fn.expand("~/Documents/notes/dailies/" .. today .. ".md")

  -- Check if the note exists, if not create it
  if vim.fn.filereadable(note_path) == 0 then
    -- Create a new note using a template if necessary
    vim.fn.writefile({"# " .. today}, note_path)
  end

  -- Open the note
  vim.cmd("edit " .. note_path)
end

vim.keymap.set("n", "<leader>zd", open_today_note, { noremap = true, silent = true })
