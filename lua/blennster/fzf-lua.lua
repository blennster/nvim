return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  },
  event = 'VimEnter',
  config = function ()
    local fzflua = require('fzf-lua')
    fzflua.setup {
      'telescope',
      keymap = {
        -- Below are the default binds, setting any value in these tables will override
        -- the defaults, to inherit from the defaults change [1] from `false` to `true`
        builtin = {
          true, -- inherit from defaults
          -- neovim `:tmap` mappings for the fzf win
          ['<C-d>']      = 'preview-page-down',
          ['<C-u>']      = 'preview-page-up',
          ['<M-S-down>'] = 'preview-down',
          ['<M-S-up>']   = 'preview-up',
        },
      },
      fzf_colors = true,
    }
    fzflua.register_ui_select()

    vim.cmd([[ FzfBind ]])
  end
}
