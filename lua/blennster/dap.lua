return {
  {
    'mfussenegger/nvim-dap',
    config = function ()
      vim.fn.sign_define('DapBreakpoint', { text = require 'common'.icons.dap.Breakpoint, texthl = 'Error' })
      local dap = require('dap')

      local port = 13300
      dap.adapters.codelldb = {
        type = 'server',
        port = port,
        executable = {
          command = 'codelldb',
          args = { '--port', port },

        }
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function ()
            local a_out = vim.fn.getcwd() .. '/a.out'
            if vim.fn.filereadable(a_out) == 1 then
              print('Running C/C++ debug on file ' .. a_out)
              return a_out
            end

            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp;
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    event = 'VimEnter',
    config = function ()
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function ()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function ()
        dapui.open()
      end

      vim.cmd([[ DapBind ]])
    end
  }
}
