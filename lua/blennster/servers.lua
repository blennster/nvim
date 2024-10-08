local M = {}

M.servers = function ()
  local fs = require('efmls-configs.fs')
  local efmEslint = require('efmls-configs.linters.eslint_d')
  local efmPrettier = require('efmls-configs.formatters.prettier_d')

  require('efmls-configs.formatters.shfmt') -- Include so healthcheck can report
  require('efmls-configs.linters.shellcheck')

  local flake8 = require('efmls-configs.linters.flake8')
  flake8.lintCommand = string.format('%s --max-line-length 120 -', fs.executable('flake8', 'BUNDLE'))

  local efmLanguages = {
    python = {
      flake8,
      require('efmls-configs.formatters.autopep8'),
    },
    rust = { require('efmls-configs.formatters.rustfmt') },
    go = { require('efmls-configs.formatters.gofmt') },
    sh = {
      {
        formatCommand = 'shfmt -i 0 -sr -',
        formatStdin = true
      },
    },
    yaml = {
      {
        formatCommand = 'yamlfmt -formatter retain_line_breaks=true,indentless_arrays=false -in',
        formatStdin = true
      }
    },
    typescript = { efmEslint },
    javascript = { efmEslint },
    typescriptreact = { efmEslint },
    javascriptreact = { efmEslint },
    json = { efmPrettier },
    markdown = { efmPrettier },
    html = { efmPrettier },
    css = { efmPrettier },
  }

  -- Enable the following language servers
  local servers = {
    -- https://github.com/creativenull/efmls-configs-nvim
    efm = {
      init_options = { documentFormatting = true },
      settings = {
        rootMarkers = { '.git/', '.gitignore' },
        languages = efmLanguages
      },
      filetypes = vim.tbl_keys(efmLanguages)
    },
    clangd = {
      cmd = {
        -- 'xcrun',
        'clangd',
        '--query-driver=/opt/homebrew/bin/*gcc'
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
    ts_ls = {},
    zls = {},
    cssls = {},
    taplo = {},
    jsonnet_ls = {},
    cmake = {},
    -- sourcekit = {
    --   root_dir = require('lspconfig').util.root_pattern('buildServer.json', '*.xcodeproj', '*.xcworkspace',
    --     'compile_commands.json', 'Package.swift', '.git', '.clang-format', '.clangd'),
    --   single_file_support = true
    -- }
  }

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
