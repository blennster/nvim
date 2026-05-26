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
  {
    'RRethy/vim-illuminate',
    config = function ()
      require('illuminate').configure({
        large_file_cutoff = 20000,
        large_file_overrides = nil,
      })
    end
  },
  -- Which-key: shows pending keybindings and groups
  { 'folke/which-key.nvim', opts = { icons = { mappings = false } } },
}
