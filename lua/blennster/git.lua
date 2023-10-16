-- Git related plugins
local M = {}

M.lazy = {
  'tpope/vim-fugitive',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[g]it goto [p]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
          { buffer = bufnr, desc = '[g]it goto [n]ext Hunk' })
        vim.keymap.set('n', '<leader>gk', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[g]it preview hun[k]' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line,
          { buffer = bufnr, desc = '[g]it [b]lame' })
        vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis,
          { buffer = bufnr, desc = '[g]it [d]iff' })
        vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk,
          { buffer = bufnr, desc = '[g]it [r]eset hunk' })
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
