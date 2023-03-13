local _lazygit = nil
function _lazygit_toggle()
  if vim.fn.executable('lazygit') then
    if not _lazygit then
      local ok, _ = pcall(require, 'toggleterm.terminal')
      if ok then
        _lazygit = require('toggleterm.terminal').Terminal:new({
          cmd = 'lazygit',
          direction = 'float',
          close_on_exit = true,
          hidden = true,
        })
      else
        vim.notify('Plugin [toggleterm] is not found.', vim.log.levels.ERROR, { title = 'toggleterm' })
      end
    end
    _lazygit:toggle()
  else
    vim.notify('Command [lazygit] is not found.', vim.log.levels.ERROR, { title = 'toggleterm' })
  end
end

local keymap = require('core.keymap')
local nmap, imap, cmap, xmap, vmap = keymap.nmap, keymap.imap, keymap.cmap, keymap.xmap, keymap.vmap
local silent, noremap, expr = keymap.silent, keymap.noremap, keymap.expr
local opts = keymap.new_opts
local cmd = keymap.cmd

-- Use space as leader key
vim.g.mapleader = ' '

-- leaderkey
nmap({ ' ', '', opts(noremap) })
xmap({ ' ', '', opts(noremap) })

-- usage example
nmap({
  -- noremal remap
  -- close buffer
  { '<C-x>k', cmd('bdelete'), opts(noremap, silent) },
  -- save
  { '<C-s>', cmd('write'), opts(noremap) },
  -- yank
  { 'Y', 'y$', opts(noremap) },
  -- buffer jump
  { ']b', cmd('bn'), opts(noremap) },
  { '[b', cmd('bp'), opts(noremap) },
  -- remove trailing white space
  { '<Leader>t', cmd('TrimTrailingWhitespace'), opts(noremap) },
  -- window jump
  { '<C-h>', '<C-w>h', opts(noremap) },
  { '<C-l>', '<C-w>l', opts(noremap) },
  { '<C-j>', '<C-w>j', opts(noremap) },
  { '<C-k>', '<C-w>k', opts(noremap) },
})

imap({
  -- insert mode
  { '<C-h>', '<Bs>', opts(noremap) },
  { '<C-e>', '<End>', opts(noremap) },
})

-- commandline remap
cmap({ '<C-b>', '<Left>', opts(noremap) })
-- usage of plugins
nmap({
  -- plugin manager: Lazy.nvim
  { '<Leader>pu', cmd('Lazy update'), opts(noremap, silent, 'Plugin: Update') },
  { '<Leader>pi', cmd('Lazy install'), opts(noremap, silent, 'Plugin: Install') },
  -- dashboard  cannot use following command
  -- { '<Leader>n', cmd('DashboardNewFile'), opts(noremap, silent, 'Dashboard: New file') },
  -- { '<Leader>ss', cmd('SessionSave'), opts(noremap, silent, 'Dashboard: Save session') },
  -- { '<Leader>sl', cmd('SessionLoad'), opts(noremap, silent, 'Dashboard: Load session') },

  -- nvimtree
  { '<Leader>e', cmd('NvimTreeToggle'), opts(noremap, silent, 'NvimTree: Toggle filer') },
  -- Telescope
  { '<Leader>b', cmd('Telescope buffers'), opts(noremap, silent, 'Telescope: Buffers') },
  { '<Leader>fa', cmd('Telescope live_grep'), opts(noremap, silent, 'Telescope: Live grep') },
  { '<Leader>ff', cmd('Telescope find_files'), opts(noremap, silent, 'Telescope: Find files under current directory') },
  {
    '<Leader>fb',
    cmd('Telescope file_browser hidden=true initial_mode=normal'),
    opts(noremap, silent, 'Telescope: File browser'),
  },
  { '<Leader>fp', cmd('Telescope projects'), opts(noremap, silent, 'Telescope: File browser') },
  { '<C-p>', cmd('Telescope keymaps') },

  -- lazygit
  { '<Leader>lg', cmd('lua _lazygit_toggle()'), opts(noremap, silent, 'Git: Toggle lazygit') },

  -- legendary
  -- {'<C-p>', cmd('Legendary')}
})

-- Completion
nmap({
  { 'gf', cmd('LspZeroFormat!'), opts(noremap, silent, 'LSP: Code formatting') },
  -- Lspsaga
  { 'K', cmd('Lspsaga hover_doc'), opts(noremap, silent, 'LSP: Hover doc (Lspsaga)') },
  -- { '<F2>', cmd('Lspsaga rename'), opts(noremap, silent, 'LSP: Rename (Lspsaga)') },
  {
    '<F2>',
    function()
      return ':IncRename ' .. vim.fn.expand('<cword>')
    end,
    opts(noremap, silent, expr, 'LSP: Rename (inc_rename)'),
  },
  { 'gd', cmd('Lspsaga lsp_finder'), opts(noremap, silent, 'LSP: Lsp finder (Lspsaga)') },
  { 'gp', cmd('Lspsaga peek_definition'), opts(noremap, silent, 'LSP: Peek definition (Lspsaga)') },
  { '[d', cmd('Lspsaga diagnostic_jump_prev'), opts(noremap, silent, 'LSP: Prev diagnostic (Lspsaga)') },
  { ']d', cmd('Lspsaga diagnostic_jump_next'), opts(noremap, silent, 'LSP: Next diagnostic (Lspsaga)') },
  { '<F4>', cmd('Lspsaga code_action'), opts(noremap, silent, 'LSP: Code action (Lspsaga)') },
  { 'gl', cmd('Lspsaga show_line_diagnostics'), opts(noremap, silent, 'LSP: Show line diagnostic (Lspsaga)') },
  { '<leader>go', cmd('Lspsaga outline'), opts(noremap, silent, 'LSP: Outline (Lspsaga)') },
})
vmap({ '<F4>', cmd('Lspsaga code_action'), opts(noremap, silent, 'LSP: Code Action (Lspsaga)') })

-- Telekasten
nmap({
  { '<leader>zf', cmd('Telekasten find_notes'), opts(noremap, 'Telekasten: Find notes') },
  { '<leader>zs', cmd('Telekasten search_notes'), opts(noremap, 'Telekasten: Search notes') },
  { '<leader>zd', cmd('Telekasten goto_today'), opts(noremap, 'Telekasten: Goto today') },
  { '<leader>zz', cmd('Telekasten follow_link'), opts(noremap, 'Telekasten: Follow link') },
  { '<leader>zn', cmd('Telekasten new_note'), opts(noremap, 'Telekasten: New note') },
  { '<leader>zc', cmd('Telekasten show_calendar'), opts(noremap, 'Telekasten: Show calendar') },
  { '<leader>zb', cmd('Telekasten show_backlinks'), opts(noremap, 'Telekasten: Show backlinks') },
  { '<leader>zI', cmd('Telekasten insert_img_link'), opts(noremap, 'Telekasten: Insert image link') },
})
