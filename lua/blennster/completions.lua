local M = {}

M.lazy = {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', event = 'LspAttach', tag = 'legacy', opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  { 'b0o/schemastore.nvim' },
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = function()
  --     local nls = require("null-ls")
  --     return {
  --       root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
  --       sources = {
  --         nls.builtins.formatting.yamlfmt,
  --         -- nls.builtins.diagnostics.flake8,
  --       },
  --     }
  --   end,
  -- },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
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
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},

          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        sorting = defaults.sorting,
      }
    end
  },
  {
    "Exafunction/codeium.vim",
    config = function()
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
    end,
  },
  -- {
  --   'huggingface/llm.nvim',
  --   opts = {
  --     api_token = '',
  --     accept_keymap = '<C-g>',
  --   }
  -- },
}

M.configure = function()
  -- [[ Configure LSP ]]
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(client, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end

    nmap('<leader>cr', ":IncRename ", '[R]ename')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

    if client.server_capabilities.documentFormattingProvider then
      nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch Document [S]ymbols')
      nmap('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch Workspace [S]ymbols')
    end

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    require 'which-key'.register({
      c = {
        name = 'code',
      }
    }, { prefix = '<leader>' })

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
    vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
    vim.keymap.set('n', '<leader>cD', vim.diagnostic.setloclist, { desc = 'Search workspace diagnostics list' })
  end

  -- Setup neovim lua configuration
  require('neodev').setup()

  -- Enable the following language servers
  local servers = {
    clangd = {},
    gopls = {},
    -- pyright = {},
    rust_analyzer = {},
    yamlls = {
      yaml = {
        schemaStore = { enable = false, url = '' },
        schemas = require('schemastore').yaml.schemas(),
      }
    },
    nil_ls = {
      ['nil'] = {
        formatting = {
          command = { "alejandra" }
        }
      }
    },
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
    jdtls = {
      cmd = { "jdt-language-server",
        "-configuration", vim.fn.expand("~/.jdtls/config"),
        "-data", vim.fn.expand("~/.jdtls/workspace")
      },
      init_options = {
        extendedClientCapabilities = {
          progressReportProvider = true,
        },
      },
    },
    jsonls = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = true,
      },
      cmd = { "vscode-json-languageserver", "--stdio" }
    },
    tsserver = {},
  }

  local lspconfig = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    capabilities = capabilities,
  })

  -- configure servers
  for server, conf in pairs(servers) do
    local opts = { on_attach = on_attach, settings = conf, cmd = nil, init_options = nil, handlers = nil }
    if conf.cmd then opts.cmd = conf.cmd end
    if conf.init_options then opts.init_options = conf.init_options end
    if conf.handlers then opts.handlers = conf.handlers end
    lspconfig[server].setup(opts)
  end
end

return M
