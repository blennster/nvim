return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        cond = function ()
          return vim.fn.executable 'make' == 1
        end,
      },
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
      'mgalliou/blink-cmp-tmux',
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = true
          }
        }
      },
      signature = { enabled = true, window = { border = 'rounded', show_documentation = true } },
      -- snippets = { preset = 'luasnip' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
        use_nvim_cmp_as_default = true,
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        keyword = { range = 'full' },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          -- Add pretty hover
          -- draw = function (opts)
          --   if opts.item and opts.item.documentation then
          --     local out = require('pretty_hover.parser').parse(opts.item.documentation.value)
          --     opts.item.documentation.value = out:string()
          --   end
          --
          --   opts.default_implementation(opts)
          -- end,
          window = {
            border = 'rounded',
          },
        },
        menu = {
          max_height = 20,
          draw = {
            components = {
              kind = {
                text = function (ctx) return string.format('[%s]', string.upper(ctx.kind)) end,
              }
            },
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
            treesitter = { 'lsp' },
          }
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          tmux = {
            module = 'blink-cmp-tmux',
            name = 'tmux',
            -- default options
            opts = {
              all_panes = true,
              capture_history = false,
              -- only suggest completions from `tmux` if the `trigger_chars` are
              -- used
              triggered_only = false,
              trigger_chars = { '.' }
            },
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      -- fuzzy = { implementation = 'prefer_rust_with_warning' }
      fuzzy = {
        -- implementation = 'lua',
        implementation = 'prefer_rust_with_warning',
        sorts = {
          -- 'exact',
          'score',
          'sort_text'
        }
      }
    },
    opts_extend = { 'sources.default' }
  },
  { 'williamboman/mason.nvim', opts = {} },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
    dependencies = {
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',  event = 'LspAttach', tag = 'legacy', opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/lazydev.nvim', ft = 'lua',          opts = {} },
      'b0o/schemastore.nvim',
      {
        'SmiteshP/nvim-navic',
        event = 'LspAttach',
        opts = {
          highlight = true,
        }
      },
      -- { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'p00f/clangd_extensions.nvim', opts = {} },
      { 'SmiteshP/nvim-navbuddy' },
      { 'stevearc/conform.nvim',       opts = {} },
      { 'mfussenegger/nvim-lint' },
    },
    opts = {
      inlay_hints = true
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities({}, true)
      vim.diagnostic.config({
        virtual_text = {}
      })
      -- vim.lsp.inlay_hint.enable(true)
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      local servers = require('blennster.servers').servers()

      -- configure servers
      for server, conf in pairs(servers) do
        lspconfig[server].setup(vim.tbl_extend('keep', conf, {
          capabilities = capabilities,
        }))
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspConfig', {}),
        callback = function (args)
          local bufnr = args.buf
          -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local client = vim.lsp.get_client_by_id(args.data.client_id)


          if client ~= nil and client.server_capabilities.documentSymbolProvider then
            require('nvim-navbuddy').attach(client, bufnr)
            require('nvim-navic').attach(client, bufnr)
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end
      })
    end,
  },
  -- {
  --   'Fildo7525/pretty_hover',
  --   -- tag = 'v2.0.1',
  --   event = 'LspAttach',
  --   opts = {}
  -- },
  -- {
  --   'Exafunction/codeium.vim',
  --   config = function ()
  --     vim.g.codeium_no_map_tab = false
  --     vim.g.codeium_enabled = false
  --
  --     vim.keymap.set('i', '<C-g>', function ()
  --       return vim.fn['codeium#Accept']()
  --     end, { expr = true })
  --   end,
  -- },
}
