return {
  { 'williamboman/mason.nvim', opts = {} },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    dependencies = {
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',               event = 'LspAttach', tag = 'legacy',    opts = {} },
      { 'creativenull/efmls-configs-nvim', event = 'LspAttach', version = 'v1.x.x' },
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim',               ft = 'lua' },
      'b0o/schemastore.nvim',
      {
        "SmiteshP/nvim-navic",
        event = "LspAttach",
        opts = {
          highlight = true,
        }
      },
    },
    config = function()
      require('neodev').setup()

      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
      })

      local servers = require('blennster.servers').servers()

      -- configure servers
      for server, conf in pairs(servers) do
        lspconfig[server].setup(conf)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspConfig', {}),
        callback = function(args)
          local bufnr = args.buf
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
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
    'ms-jpq/coq_nvim',
    branch = 'coq',
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    dependencies = {
      { 'ms-jpq/coq.artifacts',  branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p' },
    },
    init = function()
      require('coq_3p') {
        { src = "bc", short_name = "MATH", precision = 6 },
      }
      vim.g.coq_settings = {
        auto_start = 'shut-up',
        ['display.preview.border'] = 'solid',
        ['clients.lsp.resolve_timeout'] = 0.15,
        ['limits.completion_auto_timeout'] = 0.95,
        ['clients.lsp.always_on_top'] = {},
      }
    end
  },
  {
    "Exafunction/codeium.vim",
    config = function()
      vim.g.codeium_no_map_tab = false
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
    end,
  },
}
