-- Switch for controlling whether you want autoformatting.
--  Use :KickstartFormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('FormatToggle', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true }),
  callback = function()
    if not format_is_enabled then
      return
    end

    vim.cmd [[Format]]
  end,
})
