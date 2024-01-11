return {
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '┊', },
      scope = { enabled = true },
    },
  },
  { 'RRethy/vim-illuminate' },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
}
