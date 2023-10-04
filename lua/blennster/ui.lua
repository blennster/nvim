local M = {}

local icons = require 'common'.icons

M.lazy = {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        { -- filter write messages "xxxL, xxxB"
          filter = {
            event = "msg_show",
            find = "%dL",
          },
          opts = { skip = true },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      { "stevearc/dressing.nvim", opts = {} },
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons'
    },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { "branch" },
        lualine_b = { "filetype" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filename", path = 1, symbols = { modified = icons.git.modified, readonly = "", unnamed = "" } },
          -- stylua: ignore
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          },
        },
        lualine_x = { "fileformat" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    opts = {
      symbol = "│",
      options = { try_as_border = true }
    }
  },
  { "folke/flash.nvim",     opts = {} },
  { 'RRethy/vim-illuminate' },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    'akinsho/bufferline.nvim',
    enabled = false,
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {}
  },
}


return M
