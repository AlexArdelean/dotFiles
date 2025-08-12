local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim",                  cmd = "Neoconf" },
  "folke/neodev.nvim",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",   opts = {} },
  "nvim-lua/plenary.nvim",

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
  },
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts_extend = { "sources.default" }
  },

  "ggandor/leap.nvim",
  "mg979/vim-visual-multi",

  {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",
  },

  {
    "leosmaia21/gcompilecommands.nvim",
    opts = {
      tmp_file_path = "$HOME/tmp/compilecommandsNEOVIM.json",
    },
    ft = { "c", "cpp" }, -- lazy load plugin only on C and C++ filetypes
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true },

  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- { 'numToStr/Comment.nvim',   opts = {} },
  { "echasnovski/mini.nvim",     version = "*" },
  "JoosepAlviste/nvim-ts-context-commentstring",

  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  "zane-/cder.nvim",

  {
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    tag = "0.1.5",
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- 'nvim-treesitter/nvim-treesitter-textobjects',
  },

  "nvim-tree/nvim-web-devicons",

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- { 'dstein64/nvim-scrollview' },

  -- Color schemes
  { "folke/tokyonight.nvim",           name = "tokyonight-night" },
  { "rose-pine/neovim",                name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },
  { "navarasu/onedark.nvim" },
  { "gmr458/vscode_modern_theme.nvim", },
  { "ellisonleao/gruvbox.nvim" },
  { "marko-cerovac/material.nvim" },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  },
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "norcalli/nvim-colorizer.lua",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  "lewis6991/gitsigns.nvim",

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({})
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- Lsp and auto completions
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      lazy = true,
      config = false,
      init = function()
        -- Disable automatic setup, we are doing it manually
        vim.g.lsp_zero_extend_cmp = 0
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },
    {
      "neovim/nvim-lspconfig",
      cmd = { "LspInfo", "LspInstall", "LspStart" },
      event = { "BufReadPre", "BufNewFile" },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- "hrsh7th/nvim-cmp",
    -- { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    -- "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-path",
    -- "saadparwaiz1/cmp_luasnip",
    -- "hrsh7th/cmp-nvim-lua",

    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
      },
    },
  },

  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'mattn/calendar-vim' }
  },

  {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'jvgrootveld/telescope-zoxide'
  },

  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      enabled = false,
      disable_mouse = false
    },
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

})
