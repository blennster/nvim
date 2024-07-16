return {
  { 'williamboman/mason.nvim', opts = {} },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
    dependencies = {
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',               event = 'LspAttach', tag = 'legacy',    opts = {} },
      { 'creativenull/efmls-configs-nvim', event = 'LspAttach', version = 'v1.x.x' },
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/lazydev.nvim',              ft = 'lua',          opts = {} },
      'b0o/schemastore.nvim',
      {
        'SmiteshP/nvim-navic',
        event = 'LspAttach',
        opts = {
          highlight = true,
        }
      },
      { 'hrsh7th/cmp-nvim-lsp' },
    },
    opts = {
      inlay_hints = true
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.util.default_config = vim.tbl_extend('keep', lspconfig.util.default_config, {
        capabilities = capabilities,
      })

      local servers = require('blennster.servers').servers()

      -- configure servers
      for server, conf in pairs(servers) do
        lspconfig[server].setup(conf)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspConfig', {}),
        callback = function (args)
          local bufnr = args.buf
          -- vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, bufnr)
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end
      })
    end,
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Add other completions
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    opts = function ()
      -- gray deprecated
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#e678ef' })

      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}
      return {
        formatting = {
          -- format = require('lspkind').cmp_format {}
          format = function (entry, vim_item)
            local kind_icons = require('common').icons.kinds
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = '[BUF]',
              nvim_lsp = '[LSP]',
              luasnip = '[SINP]',
              nvim_lua = '[Lua]',
              latex_symbols = '[TeX]',
              path = '[PATH]',
            })[entry.source.name]
            return vim_item
          end
        },
        snippet = {
          expand = function (args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<Down>'] = cmp.mapping.select_next_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-l>'] = cmp.mapping(function (fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function (fallback)
            if luasnip.expand_or_locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-Space>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif not cmp.visible() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'lazydev', group_index = 0 }
        }),
        sorting = defaults.sorting,
      }
    end
  },
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
