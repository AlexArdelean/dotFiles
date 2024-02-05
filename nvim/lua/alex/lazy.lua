local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
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

  'ggandor/leap.nvim',

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "prettier/vim-prettier",
  },

  { 'numToStr/Comment.nvim', opts = {} },

  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    "nvim-telescope/telescope-live-grep-args.nvim" ,
    tag = '0.1.5',
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  'nvim-tree/nvim-web-devicons',

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  { 'dstein64/nvim-scrollview' },

  -- Color schemes
  { 'rose-pine/neovim',        name = 'rose-pine' },
  { 'folke/tokyonight.nvim',   name = 'tokyonight-night' },
  { 'rebelot/kanagawa.nvim' },
  { 'navarasu/onedark.nvim' }, 
  {
    "gmr458/vscode_modern_theme.nvim",
    lazy = false,
    priority = 1000,
  },
  -- { 'ful1e5/onedark.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'marko-cerovac/material.nvim' },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" }
  },
  'mbbill/undotree',
  'tpope/vim-fugitive',
  'norcalli/nvim-colorizer.lua',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  'lewis6991/gitsigns.nvim',

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {}
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  -- Lazy
  {
    "jackMort/ChatGPT.nvim",
      event = "VeryLazy",
      config = function()
        require("chatgpt").setup()
        vim.keymap.set("n", "<leader>c", "<cmd>ChatGPT<CR>")
        
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        "nvim-telescope/telescope.nvim"
      }
  },

  -- Lsp and auto completions
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      lazy = true,
      config = false,
      init = function()
        -- Disable automatic setup, we are doing it manually
        vim.g.lsp_zero_extend_cmp = 0
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },
    {
      'neovim/nvim-lspconfig',
      cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
      event = { 'BufReadPre', 'BufNewFile' },
    },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter', },
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  }

}
)
