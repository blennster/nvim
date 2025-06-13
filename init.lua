--[[ - https://learnxinyminutes.com/docs/lua/ ]]
--
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.augroup = vim.api.nvim_create_augroup('blennster', { clear = true })
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.diagnostic.config {
  float = {
    source = true,
  }
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 99

vim.api.nvim_create_user_command('LspLogClear', function ()
  os.remove(require('vim.lsp.log').get_filename())
  print('Cleaned lsp logs')
end, {})

require 'blennster.settings'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function ()
      -- vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },
  {
    'Shatur/neovim-ayu',
    priority = 1000,
    init = function ()
      vim.cmd.colorscheme 'ayu-mirage'
      -- gray deprecated
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#e678ef' })
    end,
  },

  require 'blennster.git',
  -- require 'blennster.telescope',
  require 'blennster.fzf-lua',

  require 'blennster.completions_blink',
  -- require 'blennster.completions',
  require 'blennster.editor',
  require 'blennster.ui',

  require 'blennster.neotree',
  require 'blennster.treesitter',
  require 'blennster.dap',
  require 'blennster.remote',
  -- require 'blennster.ai'
  require 'blennster.ai'
}, {})

require 'blennster.keymaps'
require 'blennster.autocmds'
require 'blennster.autoformat'

-- Turn of LSP logging by default
vim.lsp.set_log_level('off')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 et:
