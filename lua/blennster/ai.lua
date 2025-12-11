return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function ()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = 'snacks'
      }
    }

    -- Required for automatic buffer reload when opencode edits files
    vim.o.autoread = true

    -- Keymaps with <leader>o prefix
    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function () require('opencode').ask('@this: ', { submit = true }) end,
      { desc = 'Ask opencode' })
    vim.keymap.set({ 'n', 'x' }, '<leader>os', function () require('opencode').select() end,
      { desc = 'Select opencode action…' })
    vim.keymap.set({ 'n', 'x' }, '<leader>op', function () require('opencode').prompt('@this') end,
      { desc = 'Add to opencode prompt' })
    local function toggle_and_focus()
      local opencode = require('opencode')
      opencode.toggle()
      vim.schedule(function ()
        -- Find the opencode terminal buffer and focus its window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:match('opencode') then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end)
    end
    vim.keymap.set({ 'n', 't' }, '<leader>oo', toggle_and_focus, { desc = 'Toggle opencode' })
    vim.keymap.set({ 'n', 't' }, '<C-l>', toggle_and_focus, { desc = 'Toggle opencode' })
  end,
}
