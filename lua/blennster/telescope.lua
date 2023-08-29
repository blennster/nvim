local M = {}

M.lazy = {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
}


M.configure = function()
  local telescope = require('telescope')
  local telescopeConfig = require("telescope.config")
  -- Clone the default Telescope configuration
  local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

  -- I want to search in hidden/dot files.
  table.insert(vimgrep_arguments, "--hidden")
  -- I don't want to search in the `.git` directory.
  table.insert(vimgrep_arguments, "--glob")
  table.insert(vimgrep_arguments, "!**/.git/*")
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-f>'] = require('telescope.actions').preview_scrolling_down,
          ['<C-d>'] = require('telescope.actions').preview_scrolling_up,
        }
      },
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
        },
      },
    }
  }

  require 'which-key'.register({
    s = {
      name = 'search',
    }
  }, { prefix = '<leader>' })

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
  local builtin = require('telescope.builtin')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
  vim.keymap.set('n', '<leader>st', builtin.live_grep, { desc = '[s]earch [t]ext' })
  vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = '[s]earch [g]it Files' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
  vim.keymap.set('n', '<leader>sT', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      previewer = true,
    })
  end, { desc = '[s]earch [T]ext in current buffer' })

  require("telescope").load_extension("noice")
  vim.keymap.set('n', '<leader>sn', ":Telescope noice<cr>", { desc = '[s]earch [n]oice' })
end

return M
