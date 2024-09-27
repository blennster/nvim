return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function ()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
  },
  event = 'VimEnter',
  config = function ()
    local telescope = require('telescope')
    local telescopeConfig = require('telescope.config')
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, '--hidden')
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, '--glob')
    table.insert(vimgrep_arguments, '!**/.git/*')
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
            ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
            ['<C-x>'] = require('telescope.actions').delete_buffer,
          }
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_cursor {}
        }
      },
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { 'rg', '--files', '--hidden', '--glob', '!.git' }
        },
        lsp_references = {
          include_current_line = false,
          include_declaration = false,
          show_line = false,
          theme = 'dropdown'
        },
        lsp_document_symbols = {
          symbol_width = 50,
          theme = 'dropdown',
          previewer = false,
        },
        current_buffer_fuzzy_find = {
          theme = 'dropdown',
          previewer = false,
        },
        lsp_incoming_calls = {
          theme = 'dropdown',
          previewer = true,
        }
      }
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    vim.cmd([[ TelescopeBind ]])
  end
}
