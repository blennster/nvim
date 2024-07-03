-- [[ Autoformatting ]]
-- Switch for controlling whether you want autoformatting.
--  Use :FormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('FormatToggle', function ()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

local util = require('util')
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.g.augroup,
  callback = function ()
    local no_format = vim.fn.filereadable(util.get_root() .. '/.no_format')
    if not format_is_enabled or no_format == 1 then
      return
    end

    -- Lsp config will setup formatting via :Format command and
    vim.cmd [[Format]]
  end,
})
