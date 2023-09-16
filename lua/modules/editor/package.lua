local package = require('core.pack').package
local conf = require('modules.editor.config')

package({
  'nvim-treesitter/nvim-treesitter',
  event = 'BufRead',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'andymass/vim-matchup',
  },
})

package({
  'numToStr/Comment.nvim',
  keys = {
    { '<C-_>', '<Plug>(comment_toggle_linewise_current)', noremap = true, mode = 'n', desc = 'Comment Toggle Current' },
    { '<C-_>', '<Plug>(comment_toggle_linewise_visual)', noremap = true, mode = 'x', desc = 'Comment Toggle Current' },
    { '<C-/>', '<Plug>(comment_toggle_linewise_current)', noremap = true, mode = 'n', desc = 'Comment Toggle Current' },
    { '<C-/>', '<Plug>(comment_toggle_linewise_visual)', noremap = true, mode = 'x', desc = 'Comment Toggle Current' },
  },
  config = function()
    require('Comment').setup()
  end,
})

package({
  'ethanholz/nvim-lastplace',
  event = { 'BufRead' },
  config = conf.nvim_lastplace,
})

package({
  'monaqa/dial.nvim',
  keys = {
    { '<C-a>', '<Plug>(dial-increment)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: increment' },
    { '<C-x>', '<Plug>(dial-decrement)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: decrement' },
    { 'g<C-a>', 'g<Plug>(dial-increment)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: increment' },
    { 'g<C-x>', 'g<Plug>(dial-decrement)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: decrement' },
  },
  config = conf.dial,
})

package({
  'akinsho/toggleterm.nvim',
  event = 'UIEnter',
  config = conf.toggleterm,
})

package({
  'NvChad/nvim-colorizer.lua',
  event = 'UIEnter',
  config = function()
    require('colorizer').setup({})
  end,
})

package({
  'smoka7/hop.nvim',
  version = '*',
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
  end,
})

package({
  'smjonas/inc-rename.nvim',
  event = { 'CursorHold', 'CursorHoldI' },
  config = function()
    require('inc_rename').setup()
  end,
})

