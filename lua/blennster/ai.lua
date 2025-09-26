return {
  'olimorris/codecompanion.nvim',
  config = function ()
    if not vim.fn.executable('pass') then
      return
    end

    require('codecompanion').setup({
      adapters = {
        http = {
          openai = function ()
            return require('codecompanion.adapters').extend('openai', {
              env = {
                api_key = 'cmd: pass Svep/openai'
              },
              schema = {
                model = {
                  default = 'o4-mini-2025-04-16'
                }
              }
            })
          end
        }
      },
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        cmd = {
          adapter = 'openai',
        },
      },
      send = {
        callback = function (chat)
          vim.cmd('stopinsert')
          chat:submit()
          chat:add_buf_message({ role = 'llm', content = '' })
        end,
        index = 1,
        description = 'Send',
      },
    })
    require('spinner'):init()
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'echasnovski/mini.diff', opts = {} }
  },
}
