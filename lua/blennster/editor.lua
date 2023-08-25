local M = {}

M.lazy = {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    'mhartington/formatter.nvim',
    config = function()
      require("formatter").setup {
        filetype = {
          yaml = {
            require('formatter.filetypes.yaml').yamlfmt
          }
        }
      }
    end
  },

  { 'echasnovski/mini.pairs', version = '*', opts = {} },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',  opts = {} },
}

M.configure = function()
  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
end

return M
