return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  dependencies = {
    -- 'nvim-treesitter/nvim-treesitter-textobjects',
    'HiPhish/rainbow-delimiters.nvim'
  },
  build = ':TSUpdate',
  opts = {
    -- highlight = { enable = true },
    -- indent = { enable = true },
    -- -- ...
  },
  init = function ()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function (args)
        local filetype = vim.bo[args.buf].filetype
        local parser = vim.treesitter.language.get_lang(filetype) or filetype
        local ignored = { 'neo-tree' }

        -- Skip ignored filetypes
        if vim.tbl_contains(ignored, parser) then
          return
        end

        if parser ~= '' then
          local alreadyInstalled = require('nvim-treesitter.config').get_installed()
          if not vim.tbl_contains(alreadyInstalled, parser) then
            require('nvim-treesitter').install(parser)
          end
        end

        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start, args.buf)
        -- Enable treesitter-based indentation
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    local ensureInstalled = {
      'c', 'lua', 'vimdoc', 'vim', 'bash', 'markdown', 'markdown_inline', 'regex', 'yaml',
    }
    local alreadyInstalled = require('nvim-treesitter.config').get_installed()
    local parsersToInstall = vim.iter(ensureInstalled)
        :filter(function (parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
    require('nvim-treesitter').install(parsersToInstall)
  end,
  -- config = function ()
  --   require('nvim-treesitter').setup {
  --     -- Add languages to be installed here that you want installed for treesitter
  --     ensure_installed = { 'c', 'lua', 'vimdoc', 'vim', 'bash', 'markdown', 'markdown_inline', 'regex', 'yaml' },
  --
  --     sync_install = false,
  --     auto_install = true,
  --     ignore_install = { '' },
  --
  --     highlight = {
  --       enable = true,
  --       disable = function (lang, bufnr) -- Disable in large buffers
  --         return vim.api.nvim_buf_line_count(bufnr) > 20000
  --       end,
  --     },
  --     -- indent = { enable = true },
  --     incremental_selection = {
  --       enable = true,
  --       keymaps = {
  --         init_selection = '<c-space>',
  --         node_incremental = '<c-space>',
  --         scope_incremental = '<c-s>',
  --         node_decremental = '<M-space>',
  --       },
  --     },
  --     modules = {}
  --   }
  -- end
}
