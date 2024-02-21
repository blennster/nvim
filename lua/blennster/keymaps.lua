local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param plugin string
local function has(plugin)
  -- Lazy has not been loaded and therefore we have no plugins at all
  if require("lazy.core.config") == nil then
    return false
  end

  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- [[ Netrw ]]
if not has("neo-tree.nvim") then
  map("n", "<leader>e", function()
    local netrw_open = vim.api.nvim_buf_get_option(0, "filetype") == "netrw"
    if not netrw_open then
      vim.cmd [[Ex]]
    elseif vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
      vim.cmd [[bd]]
    end
  end, { desc = "Toggle explorer" })
  map("n", "<leader>E", function()
    local netrw_open = vim.api.nvim_buf_get_option(0, "filetype") == "netrw"
    if not netrw_open then
      vim.cmd [[Ex .]]
    elseif vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
      vim.cmd [[bd]]
    end
  end, { desc = "Toggle explorer" })
end

-- buffers
if has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "<leader>b,", "<cmd>BufferLineMovePrev<cr>", { desc = "Move left" })
  map("n", "<leader>b.", "<cmd>BufferLineMoveNext<cr>", { desc = "Move right" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })
map("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "Switch to next buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })

if has("harpoon") then
  map("n", "<C-m>", function()
    require("harpoon"):list():append()
  end, { desc = "add to harpoon list (mark)" })
  map("n", "<leader><leader>", function()
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "show harpoon list" })
  map("n", "<S-h>", function()
    require("harpoon"):list():prev()
  end, { desc = "Prev mark" })
  map("n", "<S-l>", function()
    require("harpoon"):list():next()
  end, { desc = "Next mark" })
  map("n", "<leader>1", function()
    require("harpoon"):list():select(1)
  end, { desc = "goto first mark" })
  map("n", "<leader>2", function()
    require("harpoon"):list():select(2)
  end, { desc = "goto second mark" })
  map("n", "<leader>3", function()
    require("harpoon"):list():select(3)
  end, { desc = "goto third mark" })
  map("n", "<leader>4", function()
    require("harpoon"):list():select(4)
  end, { desc = "goto fourth mark" })
end

if has("buffer_manager.nvim") then
  map("n", "<leader><space>", require("buffer_manager.ui").toggle_quick_menu, { desc = "Open buffer manager" })
elseif false then
  map("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "Search buffers" })
end


map("n", "<leader>h", "<cmd>noh<cr>", { desc = "Clear highlights" })
map("n", "<C-q>", function()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end, { desc = "Open quickfix" })

if has("noice.nvim") then
  map("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Noice dismiss" })
  map("n", "<leader>ne", "<cmd>Noice errors<cr>", { desc = "Noice errors" })
  map("n", "<leader>nn", "<cmd>Noice<cr>", { desc = "Noice" })
end

require 'which-key'.register({
  s = {
    name = 'search',
  }
}, { prefix = '<leader>' })
vim.api.nvim_create_user_command('TelescopeBind',
  function()
    local builtin = require('telescope.builtin')

    -- See `:help telescope.builtin`
    map('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    map('n', '<leader>sb', builtin.buffers, { desc = '[s]earch [b]uffers' })

    map('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
    map('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
    map('n', '<leader>st', builtin.live_grep, { desc = '[s]earch [t]ext' })
    map('n', '<leader>sg', builtin.git_files, { desc = '[s]earch [g]it Files' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    map('n', '<leader>sT', builtin.current_buffer_fuzzy_find, { desc = '[s]earch [T]ext in current buffer' })
  end, {})


-- LSP bindings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.g.augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local lspmap = function(mode, keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    lspmap('n', '<leader>cr', vim.lsp.buf.rename, '[R]ename')
    lspmap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    lspmap('v', 'ga', vim.lsp.buf.code_action, 'Code [A]ction')

    lspmap('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    lspmap('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    lspmap('n', 'gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    lspmap('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

    if client.server_capabilities.documentFormattingProvider then
      lspmap('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch Document [S]ymbols')
      lspmap('n', '<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        '[S]earch Workspace [S]ymbols')
    end

    -- See `:help K` for why this keymap
    lspmap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')

    -- Lesser used LSP functionality
    lspmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Create a command `:Format` local to the LSP buffer
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    require 'which-key'.register({
      c = { name = 'code', }
    }, { prefix = '<leader>' })

    -- Diagnostic keymaps
    lspmap('n', '[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
    lspmap('n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
    lspmap('n', 'gl', vim.diagnostic.open_float, 'Open floating diagnostic message')
    lspmap('n', '<leader>cd', vim.diagnostic.setloclist, 'Open diagnostics list')
    lspmap('n', '<leader>cD', vim.diagnostic.setloclist, 'Search workspace diagnostics list')
  end
})

require 'which-key'.register({
  g = {
    name = 'git',
  }
}, { prefix = '<leader>' })
vim.api.nvim_create_user_command('GitsignsAttach',
  function(opts)
    local bufnr = tonumber(opts.args)
    map('n', '<leader>gp', require('gitsigns').prev_hunk,
      { buffer = bufnr, desc = '[g]it goto [p]revious Hunk' })
    map('n', '<leader>gn', require('gitsigns').next_hunk,
      { buffer = bufnr, desc = '[g]it goto [n]ext Hunk' })
    map('n', '<leader>gk', require('gitsigns').preview_hunk,
      { buffer = bufnr, desc = '[g]it preview hun[k]' })
    map('n', '<leader>gb', require('gitsigns').blame_line,
      { buffer = bufnr, desc = '[g]it [b]lame' })
    map('n', '<leader>gd', require('gitsigns').diffthis,
      { buffer = bufnr, desc = '[g]it [d]iff' })
    map('n', '<leader>gr', require('gitsigns').reset_hunk,
      { buffer = bufnr, desc = '[g]it [r]eset hunk' })
  end
  , { nargs = 1 })
map('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Lazy [g]it' })

map("n", "<leader>u", function()
  vim.cmd [[UndotreeToggle]]
  vim.cmd [[UndotreeFocus]]
end, { desc = "[u]ndotree" })
