local M = {}

vim.api.nvim_create_user_command('ToHex', function (opts)
  local n = tonumber(opts.args)
  if n ~= nil then
    local s = string.format('0x%x', n)
    print(string.format("Hex: %s (stored in 'a' register)", s))
    vim.fn.setreg('a', s)
  else
    print('not a number')
  end
end, { nargs = 1 })

vim.api.nvim_create_user_command('ToInt', function (opts)
  local n = tonumber(opts.args, 16)
  if n ~= nil then
    local s = string.format('%d', n)
    print(string.format("Int: %s (stored in 'a' register)", s))
    vim.fn.setreg('a', s)
  else
    print('not a number')
  end
end, { nargs = 1 })

M.root_patterns = { '.git', 'lua', '.gitignore' }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function (ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r ~= nil then
          if path:find(r, 1, true) then
            roots[#roots + 1] = r
          end
        end
      end
    end
  end
  table.sort(roots, function (a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

return M
