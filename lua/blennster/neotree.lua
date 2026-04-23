---@return string
local function get_git_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.fs.dirname(path) or vim.loop.cwd()
  local git_dir = vim.fs.find('.git', { path = path, upward = true })[1]
  return git_dir and vim.fs.dirname(git_dir) or require('util').get_root()
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    -- { 'echasnovski/mini.icons', version = false, opts = {} },
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  -- These are lazy keys and cannot be defined in keymaps
  keys = {
    {
      '<leader>E',
      function ()
        require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    {
      '<leader>e',
      function ()
        require('neo-tree.command').execute({
          toggle = true,
          reveal_file = vim.fn.expand('%:p'),
          dir = get_git_root(),
        })
      end,
      desc = 'Explorer NeoTree (git root)',
    },
  },
  init = function ()
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
      if stat and stat.type == 'directory' then
        require('neo-tree')
      end
    end
  end,
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
      },
      use_libuv_file_watcher = true,
    },
    window = {
      mappings = {
        ['<space>'] = 'none',
        ['h'] = 'close_node',
        ['l'] = 'open'
      },
      position = 'current',
    },
  },
  config = function (_, opts)
    -- Refresh git status on lazygit close
    require('neo-tree').setup(opts)
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function ()
        if package.loaded['neo-tree.sources.git_status'] then
          require('neo-tree.sources.git_status').refresh()
        end
      end,
    })
  end,
}
