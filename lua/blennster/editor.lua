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

  -- [[ Autoformatting ]]
  -- Switch for controlling whether you want autoformatting.
  --  Use :FormatToggle to toggle autoformatting on or off
  local format_is_enabled = true
  vim.api.nvim_create_user_command('FormatToggle', function()
    format_is_enabled = not format_is_enabled
    print('Setting autoformatting to: ' .. tostring(format_is_enabled))
  end, {})

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true }),
    callback = function()
      if not format_is_enabled then
        return
      end

      -- Lsp config will setup formatting via :Format command and
      -- formatter.nvim will also format via :Format
      vim.cmd [[Format]]
    end,
  })
end

return M
