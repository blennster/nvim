return {
  -- Detect tabstop and shiftwidth automatically
  { 'nmac427/guess-indent.nvim', opts = {}, lazy = false },
  {
    'echasnovski/mini.pairs',
    enabled = false,
    version = '*',
    opts = {}
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',     opts = {}, lazy = false },
  { 'mbbill/undotree' },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  "lambdalisue/suda.vim",
  "terrastruct/d2-vim"
}
