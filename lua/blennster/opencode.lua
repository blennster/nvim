return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    { 'folke/snacks.nvim', opts = { terminal = {} } },
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

    -- Cache frequently used functions
    local set = vim.keymap.set
    local api = vim.api

    -- Lazy-load opencode module on first use
    local function oc()
      return require('opencode')
    end

    -- Keymaps with <leader>o prefix
    set({ 'n', 'x' }, '<leader>oa', function () oc().ask('@buffer: ', { submit = true }) end, { desc = 'Ask opencode' })
    set({ 'n', 'x' }, '<leader>oA', function () oc().ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
    set({ 'n', 'x' }, '<leader>oc', function () oc().prompt('@this: complete this code', { submit = true }) end,
      { desc = 'Complete code' })
    set({ 'n', 'x' }, '<leader>os', function () oc().select() end, { desc = 'Select opencode action' })
    set({ 'n', 'x' }, '<leader>op', function () oc().ask('', { submit = true }) end, { desc = 'Prompt' })

    local function toggle_and_focus()
      oc().toggle()

      -- Search all open windows to find the opencode window
      vim.schedule(function ()
        for _, win in ipairs(api.nvim_list_wins()) do
          local buf = api.nvim_win_get_buf(win)
          local name = api.nvim_buf_get_name(buf)
          if name:match('opencode') then
            api.nvim_set_current_win(win)
            return
          end
        end
      end)
    end

    set({ 'n', 't' }, '<leader>oo', toggle_and_focus, { desc = 'Toggle opencode' })
    set({ 'n', 't', 'i' }, '<C-l>', toggle_and_focus, { desc = 'Toggle opencode' })
  end,
}
