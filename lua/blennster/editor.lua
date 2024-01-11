return {
  -- Detect tabstop and shiftwidth automatically
  { 'nmac427/guess-indent.nvim', opts = {}, lazy = false },
  {
    enabled = false,
    'echasnovski/mini.pairs',
    version = '*',
    opts = {}
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',     opts = {} },
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
      focus_alternate_buffer = false,
    }
  },
  "lambdalisue/suda.vim",
  "terrastruct/d2-vim"
}
