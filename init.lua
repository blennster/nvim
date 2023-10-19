--[[
If you don't know anything about Lua, I recommend taking some time to read through
a guide. One possible example:
- https://learnxinyminutes.com/docs/lua/
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'blennster.settings'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  },

  require 'blennster.git'.lazy,
  require 'blennster.telescope'.lazy,

  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
      }
    end,
  },

  require 'blennster.completions'.lazy,
  require 'blennster.editor'.lazy,
  require 'blennster.ui'.lazy,

  require 'blennster.neotree',
  require 'blennster.treesitter',
}, {})

require 'blennster.completions'.configure()
require 'blennster.telescope'.configure()
require 'blennster.editor'.configure()
require 'blennster.git'.configure()

require 'autocmds'
require 'keymaps'

-- Open netrw on startup if no filename has been supplied
local ts_group = vim.api.nvim_create_augroup("DoOnEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    if #(vim.v.argv) > 4 then
      return
    end
    vim.cmd(":bd 1")
    -- require("telescope.builtin").find_files()
    vim.cmd(":Ex .")
  end,
  group = ts_group,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
