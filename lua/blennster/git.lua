-- Git related plugins
local M = {}

M.lazy = {
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[g]it goto [p]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
          { buffer = bufnr, desc = '[g]it goto [n]ext Hunk' })
        vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[g]it preview [h]unk' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line,
          { buffer = bufnr, desc = '[g]it [b]lame' })
        vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis,
          { buffer = bufnr, desc = '[g]it [d]iff' })
      end,
    },
  },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}

M.configure = function()
  require 'which-key'.register({
    g = {
      name = 'git',
    }
  }, { prefix = '<leader>' })
  vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Lazy [g]it' })
end

return M
