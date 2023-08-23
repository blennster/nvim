-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-f>'] = require('telescope.actions').preview_scrolling_down,
        ['<C-d>'] = require('telescope.actions').preview_scrolling_up,
      }
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sT', require('telescope.builtin').live_grep, { desc = '[s]earch [T]ext' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = '[s]earch [g]it Files' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[s]earch [k]eymaps' })
vim.keymap.set('n', '<leader>st', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = true,
  })
end, { desc = '[s]earch [t]ext in current buffer' })

require("telescope").load_extension("noice")
vim.keymap.set('n', '<leader>sn', ":Telescope noice<cr>", { desc = '[s]earch [n]oice' })
