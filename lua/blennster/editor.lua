local M = {}

M.lazy = {
  -- Detect tabstop and shiftwidth automatically
  { 'nmac427/guess-indent.nvim' },
  { 'echasnovski/mini.pairs',   version = '*', opts = {} },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',    opts = {} },
  { 'mbbill/undotree' },
  {
    "j-morano/buffer_manager.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      select_menu_item_commands = {
        v = {
          key = "<C-v>",
          command = "vsplit"
        },
        h = {
          key = "<C-h>",
          command = "split"
        }
      },
      focus_alternate_buffer = true,
    }
  },
  "lambdalisue/suda.vim",
  "terrastruct/d2-vim"
}

M.configure = function()
  require('guess-indent').setup {}

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
      vim.cmd [[Format]]
    end,
  })


  vim.keymap.set("n", "<leader>u", function()
    vim.cmd [[UndotreeToggle]]
    vim.cmd [[UndotreeFocus]]
  end, { desc = "[u]ndotree" })
end

return M
