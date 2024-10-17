local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param plugin string
local function has(plugin)
  -- Lazy has not been loaded and therefore we have no plugins at all
  if require('lazy.core.config') == nil then
    return false
  end

  return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Show help using ctrl K
map('n', '<C-K>', function ()
  local cword = vim.fn.expand('<cword>')
  if cword ~= '' then
    vim.cmd('Man ' .. cword)
  end
end, { desc = 'Show hover' })

-- [[ Netrw ]]
if not has('neo-tree.nvim') then
  map('n', '<leader>e', function ()
    local netrw_open = vim.api.nvim_buf_get_option_value(0, 'filetype') == 'netrw'
    if not netrw_open then
      vim.cmd [[Ex]]
    else
      vim.cmd [[bd]]
    end
  end, { desc = 'Toggle explorer' })
  map('n', '<leader>E', function ()
    local netrw_open = vim.api.nvim_buf_get_option_value(0, 'filetype') == 'netrw'
    if not netrw_open then
      vim.cmd [[Ex .]]
    else
      vim.cmd [[bd]]
    end
  end, { desc = 'Toggle explorer' })
end

-- buffers
if has('bufferline.nvim') then
  map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
  map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
  map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
  map('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
  map('n', '<leader>b,', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move left' })
  map('n', '<leader>b.', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move right' })
else
  map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
  map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
  map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
  map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
end

map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Switch to next buffer' })
map('n', '<leader>bp', '<cmd>bprev<cr>', { desc = 'Switch to next buffer' })
map('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })

if has('harpoon') then
  map('n', '<C-m>', function ()
    require('harpoon'):list():add()
  end, { desc = 'add to harpoon list (mark)' })
  map('n', '<leader><leader>', function ()
    local harpoon = require('harpoon')
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = 'show harpoon list' })
  map('n', '<S-h>', function ()
    require('harpoon'):list():prev()
  end, { desc = 'Prev mark' })
  map('n', '<S-l>', function ()
    require('harpoon'):list():next()
  end, { desc = 'Next mark' })
  map('n', '<leader>1', function ()
    require('harpoon'):list():select(1)
  end, { desc = 'goto first mark' })
  map('n', '<leader>2', function ()
    require('harpoon'):list():select(2)
  end, { desc = 'goto second mark' })
  map('n', '<leader>3', function ()
    require('harpoon'):list():select(3)
  end, { desc = 'goto third mark' })
  map('n', '<leader>4', function ()
    require('harpoon'):list():select(4)
  end, { desc = 'goto fourth mark' })
end

if has('buffer_manager.nvim') then
  map('n', '<leader><space>', require('buffer_manager.ui').toggle_quick_menu, { desc = 'Open buffer manager' })
elseif false then
  map('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Search buffers' })
end


map('n', '<leader>h', '<cmd>noh<cr>', { desc = 'Clear highlights' })
map('n', '<C-q>', function ()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end, { desc = 'Open quickfix' })

if has('noice.nvim') then
  map('n', '<leader>nd', '<cmd>Noice dismiss<cr>', { desc = 'Noice dismiss' })
  map('n', '<leader>ne', '<cmd>Noice errors<cr>', { desc = 'Noice errors' })
  map('n', '<leader>nn', '<cmd>Noice<cr>', { desc = 'Noice' })
end

require 'which-key'.add(
  {
    { '<leader>s', group = 'search' },
  }
)
vim.api.nvim_create_user_command('TelescopeBind',
  function ()
    local builtin = require('telescope.builtin')

    -- See `:help telescope.builtin`
    map('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    map('n', '<leader>sb', builtin.buffers, { desc = '[s]earch [b]uffers' })

    map('n', '<leader>sg', builtin.find_files, { desc = '[s]earch [f]iles (non git)' })
    map('n', '<leader>sf', builtin.git_files, { desc = '[s]earch [f]iles (git)' })
    map('n', '<leader>sF', function ()
      builtin.find_files { cwd = require('telescope.utils').buffer_dir() }
    end, { desc = '[s]earch [F]iles (from here)' })
    map('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
    map('n', '<leader>st', builtin.live_grep, { desc = '[s]earch [t]ext' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    map('n', '<leader>sT', builtin.current_buffer_fuzzy_find, { desc = '[s]earch [T]ext in current buffer' })
  end, {})

vim.api.nvim_create_user_command('FzfBind',
  function ()
    local builtin = require('fzf-lua')

    -- See `:help telescope.builtin`
    map('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
    map('n', '<leader>sb', builtin.buffers, { desc = '[s]earch [b]uffers' })

    map('n', '<leader>sg', builtin.files, { desc = '[s]earch files (non git)' })
    map('n', '<leader>sf', function ()
      if builtin.git_files() then
      else
        builtin.files()
      end
    end, { desc = '[s]earch [f]iles (git)' })
    -- map('n', '<leader>sF', function ()
    --   builtin.find_files { cwd = require('telescope.utils').buffer_dir() }
    -- end, { desc = '[s]earch [F]iles (from here)' })
    map('n', '<leader>sh', builtin.helptags, { desc = '[s]earch [h]elp' })
    map('n', '<leader>sw', builtin.grep_cword, { desc = '[s]earch current [w]ord' })
    map('n', '<leader>st', builtin.live_grep, { desc = '[s]earch [t]ext' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
    map('n', '<leader>sT', builtin.lgrep_curbuf, { desc = '[s]earch [T]ext in current buffer' })
  end, {})


-- LSP bindings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.g.augroup,
  callback = function (args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local lspmap = function (mode, keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    lspmap('n', '<leader>cr', vim.lsp.buf.rename, '[R]ename')
    lspmap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    lspmap('v', 'ga', vim.lsp.buf.code_action, 'Code [A]ction')

    local builtin = require('fzf-lua')

    lspmap('n', 'gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    lspmap('n', 'gr', builtin.lsp_references, '[G]oto [R]eferences')
    lspmap('n', 'gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
    lspmap('n', 'gD', builtin.lsp_typedefs, 'Type [D]efinition')


    lspmap('n', '<leader>si', builtin.lsp_incoming_calls,
      '[S]earch [i]ncoming calls')
    lspmap('n', '<leader>so', builtin.lsp_outgoing_calls,
      '[S]earch [o]utgoing calls')

    lspmap('n', '<leader>cs', vim.lsp.buf.signature_help, 'Show [S]ignature help')
    lspmap('i', '<C-j>', vim.lsp.buf.signature_help, 'Show Signature help')

    lspmap('n', '<leader>ci', function ()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
    end, 'Toggle [i]nlay hints')

    if client ~= nil and client.server_capabilities.documentFormattingProvider then
      lspmap('n', 'gO', builtin.lsp_document_symbols, '[S]earch Document [S]ymbols')
      lspmap('n', '<leader>ss', builtin.lsp_document_symbols, '[S]earch Document [S]ymbols')
      lspmap('n', '<leader>sS', builtin.lsp_workspace_symbols,
        '[S]earch Workspace [S]ymbols')
    end
    lspmap('n', '<leader>sd', builtin.lsp_document_diagnostics, '[s]earch document [d]iagnostics')
    lspmap('n', '<leader>sD', builtin.lsp_workspace_diagnostics, '[s]earch workspace [d]iagnostics')

    -- See `:help K` for why this keymap
    -- lspmap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
    lspmap('n', 'K', require('pretty_hover').hover, 'Hover Documentation')

    -- Lesser used LSP functionality
    lspmap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    lspmap('n', '<C-s>', require('clangd_extensions.switch_source_header').switch_source_header,
      'Switch source/[h]eader')
    lspmap('n', '<leader>ch', require('clangd_extensions.switch_source_header').switch_source_header,
      'Switch source/[h]eader')

    -- Create a command `:Format` local to the LSP buffer
    if client ~= nil and client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function (_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    require 'which-key'.add({
      { '<leader>c', group = 'code' }
    })

    -- Diagnostic keymaps
    lspmap('n', '[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
    lspmap('n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
    lspmap('n', 'gl', vim.diagnostic.open_float, 'Open floating diagnostic message')
    lspmap('n', '<leader>cd', vim.diagnostic.setloclist, 'Open diagnostics list')
    lspmap('n', '<leader>cD', vim.diagnostic.setloclist, 'Search workspace diagnostics list')
  end
})

vim.api.nvim_create_user_command('DapBind',
  function ()
    local dap = require('dap')
    local dapui = require('dapui')

    -- See `:help telescope.builtin`
    map('n', '<leader>dd', dap.continue, { desc = 'dap continue/start' })
    map('n', '<leader>dc', dap.run_to_cursor, { desc = 'run to cursor' })
    map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'dap toggle breakpoint' })
    map('n', '<leader>dB', function ()
      local cond = vim.fn.input('Condition: ')
      dap.set_breakpoint(cond)
    end, { desc = 'dap toggle breakpoint' })

    -- local view = require 'dap.ui.widgets'.hover()
    -- map('n', '<leader>dk', view.toggle, { desc = 'dap hover' })
    map('n', '<leader>ds', dap.step_over, { desc = 'dap step over' })
    map('n', '<leader>di', dap.step_into, { desc = 'dap step into' })
    map('n', '<leader>do', dap.step_out, { desc = 'dap step out' })
    map('n', '<leader>dx', function ()
      dap.close()
      dapui.close()
    end, { desc = 'dap close' })

    map('n', '<leader>dr', dap.run_last, { desc = 'dap rerun' })
  end, {})

require 'which-key'.add({
  { '<leader>g', group = 'git' }
})
vim.api.nvim_create_user_command('GitsignsAttach',
  function (opts)
    local bufnr = tonumber(opts.args)
    local gitsigns = require('gitsigns')
    map('n', '<leader>gp', gitsigns.prev_hunk,
      { buffer = bufnr, desc = '[g]it goto [p]revious Hunk' })
    map('n', '<leader>gn', gitsigns.next_hunk,
      { buffer = bufnr, desc = '[g]it goto [n]ext Hunk' })
    map('n', '<leader>gk', gitsigns.preview_hunk,
      { buffer = bufnr, desc = '[g]it preview hun[k]' })
    map('n', '<leader>gb', gitsigns.blame_line,
      { buffer = bufnr, desc = '[g]it [b]lame' })
    map('n', '<leader>gd', function ()
        gitsigns.diffthis(nil, {
          split = 'belowright'
        })
      end,
      { buffer = bufnr, desc = '[g]it [d]iff' })
    map('n', '<leader>gr', gitsigns.reset_hunk,
      { buffer = bufnr, desc = '[g]it [r]eset hunk' })
    map('n', '<leader>gs', gitsigns.stage_hunk,
      { buffer = bufnr, desc = '[g]it [s]tage' })
    map('n', '<leader>gl', gitsigns.blame_line,
      { buffer = bufnr, desc = '[g]it blame [l]ine' })
  end
  , { nargs = 1 })
map('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Lazy [g]it' })

map('n', '<leader>u', function ()
  vim.cmd [[UndotreeToggle]]
  vim.cmd [[UndotreeFocus]]
end, { desc = '[u]ndotree' })

map('n', '<leader>a', function ()
  vim.cmd [[ ChatGPT ]]
end, { desc = 'Toggle Chat' })

-- Fix terminal
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  map('t', '<C-esc>', [[<C-\><C-n>]], opts)
  -- map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  -- map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  -- map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  -- map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  map('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

map('n', '<leader>tt', function ()
  vim.cmd [[ToggleTerm]]
end, { desc = 'Toggle terminal' })
