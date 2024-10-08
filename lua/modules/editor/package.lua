local package = require('core.pack').package
local conf = require('modules.editor.config')

package({
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  run = ':TSUpdate',
  config = conf.nvim_treesitter,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
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
  event = { 'BufReadPost' },
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
  'watanany/tabtoggleterm.nvim',
  event = 'UIEnter',
  config = function()
    require('tabtoggleterm').setup({
      size = 20,
    })
  end,
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

package({
  'LunarVim/bigfile.nvim',
})

package({
  'vidocqh/auto-indent.nvim',
  event = { 'InsertEnter' },
  ops = {},
})

package({
  'HakonHarnes/img-clip.nvim',
  opts = conf.img_clip,
  keys = {
    { '<leader>v', '<cmd>PasteImage<cr>', desc = 'img-clip: Paste clipboard image' },
  },
})

package({
  'kevinhwang91/nvim-ufo',
  event = 'BufRead',
  keys = {
    {
      'zR',
      function()
        require('ufo').openAllFolds()
      end,
      desc = 'nvim-ufo: open all folds',
    },
    {
      'zM',
      function()
        require('ufo').closeAllFolds()
      end,
      desc = 'nvim-ufo: close all folds',
    },
    {
      'zr',
      function()
        require('ufo').openFoldsExceptKinds()
      end,
      desc = 'nvim-ufo: fold less',
    },
    {
      'zm',
      function()
        require('ufo').closeFoldsWith()
      end,
      desc = 'nvim-ufo: fold more',
    },
  },
  dependencies = {
    'kevinhwang91/promise-async',
    -- if not use herline.nvim, enable statuscol.nvim
    {
      'luukvbaal/statuscol.nvim',
      config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
            {
              sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
              click = 'v:lua.ScSa',
            },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
          },
        })
      end,
    },
  },
  config = conf.nvim_ufo,
})

