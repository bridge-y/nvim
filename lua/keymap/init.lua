local keymap = require('core.keymap')
local nmap, imap, cmap, xmap, vmap, tmap = keymap.nmap, keymap.imap, keymap.cmap, keymap.xmap, keymap.vmap, keymap.tmap
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
  { '<C-x>k', cmd('bdelete'), opts(noremap, silent, 'Close buffer') },
  -- save
  { '<C-s>', cmd('write'), opts(noremap, 'Save') },
  -- yank
  { 'Y', 'y$', opts(noremap, 'Yank') },
  -- buffer jump
  { ']b', cmd('bn'), opts(noremap, 'Buffer: next') },
  { '[b', cmd('bp'), opts(noremap, 'Buffer: previous') },
  -- window jump
  { '<C-h>', '<C-w>h', opts(noremap, 'Window: jump left') },
  { '<C-l>', '<C-w>l', opts(noremap, 'Window: jump right') },
  { '<C-j>', '<C-w>j', opts(noremap, 'Window: jump down') },
  { '<C-k>', '<C-w>k', opts(noremap, 'Window: jump up') },
})

imap({
  -- insert mode
  { '<C-h>', '<Bs>', opts(noremap, 'Insert Mode: backspace') },
  { '<C-e>', '<End>', opts(noremap, 'Insert Mode: move end of line') },
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
  {
    '<Leader>fA',
    cmd('Telescope egrepify'),
    opts(noremap, silent, 'Telescope: Live grep by telescope-egrepify.nvim'),
  },
  {
    '<Leader>ff',
    cmd('Telescope find_files'),
    opts(noremap, silent, 'Telescope: Find files under current directory'),
  },
  {
    '<Leader>fb',
    cmd('Telescope file_browser hidden=true initial_mode=normal'),
    opts(noremap, silent, 'Telescope: File browser'),
  },
  { '<Leader>fp', cmd('Telescope projects'), opts(noremap, silent, 'Telescope: File browser') },
  { '<C-p>', cmd('Telescope keymaps') },

  -- lazygit
  { '<Leader>lg', cmd('LazyGit'), opts(noremap, silent, 'Git: Toggle lazygit') },

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
  { 'gd', cmd('Glance definitions'), opts(noremap, silent, 'LSP: Preview definition') },
  { 'gD', cmd('Lspsaga goto_definition'), opts(noremap, silent, 'LSP: Go to definition') },
  { 'gp', cmd('Lspsaga peek_definition'), opts(noremap, silent, 'LSP: Peek definition (Lspsaga)') },
  { 'gh', cmd('Glance references'), opts(noremap, silent, 'LSP: Show reference') },
  { '[d', cmd('Lspsaga diagnostic_jump_prev'), opts(noremap, silent, 'LSP: Prev diagnostic (Lspsaga)') },
  { ']d', cmd('Lspsaga diagnostic_jump_next'), opts(noremap, silent, 'LSP: Next diagnostic (Lspsaga)') },
  { '<F4>', cmd('Lspsaga code_action'), opts(noremap, silent, 'LSP: Code action (Lspsaga)') },
  { 'gl', cmd('Lspsaga show_line_diagnostics'), opts(noremap, silent, 'LSP: Show line diagnostic (Lspsaga)') },
  { 'go', cmd('Lspsaga outline'), opts(noremap, silent, 'LSP: Outline (Lspsaga)') },
  { 'ga', cmd('Lspsaga code_action'), opts(noremap, silent, 'LSP: Code action') },
})

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

-- hop.nvim
nmap({
  { '<leader>w', cmd('HopWordMW'), opts(noremap, 'jump: Goto word') },
  { '<leader>j', cmd('HopLineMW'), opts(noremap, 'jump: Goto line') },
  { '<leader>k', cmd('HopLineMW'), opts(noremap, 'jump: Goto line') },
  { '<leader>c', cmd('HopChar1MW'), opts(noremap, 'jump: Goto one char') },
  { '<leader>cc', cmd('HopChar2MW'), opts(noremap, 'jump: Goto two chars') },
})
vmap({
  { '<leader>w', cmd('HopWordMW'), opts(noremap, 'jump: Goto word') },
  { '<leader>j', cmd('HopLineMW'), opts(noremap, 'jump: Goto line') },
  { '<leader>k', cmd('HopLineMW'), opts(noremap, 'jump: Goto line') },
  { '<leader>c', cmd('HopChar1MW'), opts(noremap, 'jump: Goto one char') },
  { '<leader>cc', cmd('HopChar2MW'), opts(noremap, 'jump: Goto two chars') },
})

-- Quick operation for my scraps using Octo
nmap({
  { '<leader>ss', cmd('Octo issue list bridge-y/scraps'), opts(noremap, 'Octo: show my open scraps') },
  {
    '<leader>sS',
    cmd('Octo issue list bridge-y/scraps states=OPEN,CLOSED'),
    opts(noremap, 'Octo: show my all scraps'),
  },
  { '<leader>sc', cmd('Octo issue create bridge-y/scraps'), opts(noremap, 'Octo: create a scrap') },
})

nmap({
  '<leader>t',
  cmd('TabToggleTerm!'),
  opts(noremap, silent, 'ToggleTerm: Launch terminal on horizonal window'),
})

tmap({
  '<ESC><ESC>',
  '<C-\\><C-n>',
  opts(noremap, 'Escape terminal mode'),
})

