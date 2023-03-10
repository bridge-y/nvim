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
    { '<C-a>', '<Plug>(dial-increment)', noremap = true, mode = { 'n', 'v' } },
    { '<C-x>', '<Plug>(dial-decrement)', noremap = true, mode = { 'n', 'v' } },
  },
  config = conf.dial,
})

package({
  'akinsho/toggleterm.nvim',
  event = 'UIEnter',
  config = conf.toggleterm,
})
