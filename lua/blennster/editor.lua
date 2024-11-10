return {
  -- Detect tabstop and shiftwidth automatically
  {
    'nmac427/guess-indent.nvim',
    opts = {
      filetype_exclude = {
        'csv'
      },
    },
    lazy = false
  },
  {
    'echasnovski/mini.pairs',
    enabled = false,
    version = '*',
    opts = {}
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { 'mbbill/undotree' },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {}
  },
  'lambdalisue/suda.vim',
  'terrastruct/d2-vim',
  'bsuth/emacs-bindings.nvim',
  {
    enabled = false,
    'dccsillag/magma-nvim',
    -- init = function ()
    --   vim.cmd [[:UpdateRemotePlugins]]
    -- end,
    config = function ()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Move to window using the <ctrl> hjkl keys
      map('n', '<leader>r', ':MagmaEvaluateOperator<CR>')
      map('n', '<leader>rr', ':MagmaEvaluateLine<CR>')
      map('n', '<leader>rc', ':MagmaEvaluateCell<CR>')
      map('n', '<leader>rc', ':<C-u>MagmaEvaluateVisual<CR>')
      map('n', '<leader>rd', ':MagmaDelete<CR>')
      map('n', '<leader>ro', ':MagmaShowOutput<CR>')
    end
  },
  { 'akinsho/toggleterm.nvim', version = '*', opts = { --[[ things you want to change go here]] } },
}
