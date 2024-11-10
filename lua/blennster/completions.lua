return {
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
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'p00f/clangd_extensions.nvim',        opts = {} },
      { 'SmiteshP/nvim-navbuddy' },
      { 'stevearc/conform.nvim',              opts = {} },
      { 'mfussenegger/nvim-lint' },
    },
    opts = {
      inlay_hints = true
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_extend('keep', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistraton = true

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
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
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
      'saadparwaiz1/cmp_luasnip',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Add other completions
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function ()
      -- gray deprecated
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#e678ef' })

      local cmp = require('cmp')

      -- local defaults = require('cmp.config.default')()
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }
      cmp.setup {
        window = {
          documentation = cmp.config.window.bordered()
        },
        formatting = {
          fields = { 'abbr', 'kind' },
          expandable_indicator = true,
          -- format = require('lspkind').cmp_form st {}
          format = function (entry, vim_item)
            if vim_item.kind ~= nil then
              -- Kind icons
              local kind_icons = require('common').icons.kinds
              local k = string.upper(vim_item.kind)
              vim_item.kind = string.format('%s[%s]', kind_icons[vim_item.kind], k) -- This concatenates the icons with the name of the item kind
            end

            -- Source
            -- vim_item.menu = nil
            -- vim_item.menu = ({
            --   nvim_lsp = '[LSP]',
            --   nvim_lsp_signature_help = '[LSP]',
            --   luasnip = '[SNIP]',
            --   lazydev = '[Lua]',
            --   buffer = '[BUF]',
            --   latex_symbols = '[TeX]',
            --   path = '[PATH]',
            -- })[entry.source.name]
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
              cmp.complete()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif not cmp.visible() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources(cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
        }, {
          { name = 'luasnip' },
          { name = 'lazydev' }
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })),
      }
    end
  },
  {
    'Fildo7525/pretty_hover',
    event = 'LspAttach',
    opts = {}
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
