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
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { 'echasnovski/mini.pairs', version = '*', opts = {} },
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
  { 'akinsho/toggleterm.nvim',                  version = '*',                              opts = { --[[ things you want to change go here]] } },
  { 'folke/todo-comments.nvim',                 dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
  { 'nvim-pack/nvim-spectre',                   opts = {} },
  { 'keith/swift.vim' },
  { 'MeanderingProgrammer/render-markdown.nvim' }
}
