local M = {}

M.servers = function ()
  require('conform').setup {
    formatters_by_ft = {
      -- Conform will run multiple formatters sequentially
      python = { 'ruff_format' },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { 'rustfmt' },
      -- Conform will run the first available formatter
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'yamlfmt -formatter retain_line_breaks=true' }
    },
  }

  -- Format selection
  vim.api.nvim_create_user_command('Format', function (args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ['end'] = { args.line2, end_line:len() },
      }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })

  vim.api.nvim_create_user_command('FormatFile', function (args)
    require('conform').format({ bufnr = args.buf, lsp_format = 'fallback' })
  end, {})

  require('lint').linters_by_ft = {
    javascript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    python = { 'ruff' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' }
  }

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
    callback = function ()
      -- try_lint without arguments runs the linters defined in `linters_by_ft`
      -- for the current filetype
      require('lint').try_lint()
    end,
  })

  local mason_registry = require('mason-registry')
  local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'

  local clangd_bin = 'clangd'
  if jit.os == 'OSX' then
    clangd_bin = '/opt/homebrew/opt/llvm/bin/clangd'
  end
  local home = os.getenv('HOME')

  -- Enable the following language servers
  local servers = {
    clangd = {
      cmd = {
        clangd_bin,
        '--query-driver=/opt/nordic/**gcc',
        '--query-driver=/opt/zephyr-sdk/*gcc',
        '--query-driver=' .. home .. '/.local/opt/**/*gcc'
      }
    },
    gopls = {},
    -- pyright = {},
    basedpyright = {
      settings = {
        basedpyright = {
          analysis = {
            autoImportCompletions = true,
            diagnosticSeverityOverrides = {
              reportMissingTypeStubs = false
            }
          }
        }
      }
    },
    rust_analyzer = {},
    yamlls = {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          schemas = require('schemastore').yaml.schemas(),
        }
      }
    },
    nil_ls = {
      settings = {
        ['nil'] = {
          formatting = {
            command = { 'alejandra' }
          }
        }
      }
    },
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
    },
    jdtls = {
      cmd = { 'jdt-language-server',
        '-configuration', vim.fn.expand('~/.jdtls/config'),
        '-data', vim.fn.expand('~/.jdtls/workspace')
      },
      init_options = {
        extendedClientCapabilities = {
          progressReportProvider = true,
        },
      },
    },
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = true,
        },
      },
    },
    bashls = {},
    ts_ls = {
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    },
    zls = {},
    cssls = {},
    taplo = {},
    jsonnet_ls = {},
    cmake = {},
    omnisharp = {
      cmd = { vim.fn.stdpath 'data' .. '/mason/bin/OmniSharp' }
    },

    vue_ls = {},
    harper_ls = {},
  }

  if 0 == 1 then
    servers.clangd = nil
    servers.sourcekit = {
      root_dir = require('lspconfig').util.root_pattern('buildServer.json', '*.xcodeproj', '*.xcworkspace',
        'compile_commands.json', 'Package.swift', '.git', '.clang-format', '.clangd'),
      single_file_support = true,
      cmd = {
        'sourcekit-lsp',
        '-Xclangd',
        '--query-driver=/opt/homebrew/bin/*gcc'
      }
    }
  end

  if vim.fn.filereadable(vim.loop.cwd() .. '/tools/gopackagesdriver.sh') == 1 then
    -- if true then
    servers.gopls = {
      settings = {
        gopls = {
          env = {
            GOPACKAGESDRIVER = './tools/gopackagesdriver.sh'
          },
          directoryFilters = {
            '-bazel-bin',
            '-bazel-out',
            '-bazel-testlogs',
            '-bazel-mypkg',
          },
        },
      }
    }
  end

  return servers
end

return M
