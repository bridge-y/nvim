local package = require('core.pack').package
local conf = require('modules.ui.config')

-- package({ 'glepnir/zephyr-nvim', config = conf.zephyr })

package({
  'rachartier/tiny-devicons-auto-colors.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'rebelot/kanagawa.nvim',
      name = 'kanagawa',
      event = 'VimEnter',
      config = conf.kanagawa,
    },
  },
  event = 'VeryLazy',
  config = function()
    local colors = require('kanagawa.colors').setup()
    local pallets = colors.palette
    require('tiny-devicons-auto-colors').setup({
      colors = pallets,
    })
  end,
})

-- package({
--   'shaunsingh/nord.nvim',
--   event = "VimEnter",
--   config = function ()
--     require('nord').set()
--   end
-- })

package({
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*',
  -- event = { "FocusLost", "CursorHold" },
  event = 'BufReadPost',
  config = conf.barbecue,
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons', -- optional dependency
  },
})

package({
  'RRethy/vim-illuminate',
  -- event = { "FocusLost", "CursorHold" },
  event = 'BufReadPost',
  config = conf.vim_illminate,
})

-- package({
--   'lukas-reineke/indent-blankline.nvim',
--   -- event = { "FocusLost", "CursorHold" },
--   main = 'ibl',
--   event = 'BufReadPost',
--   config = conf.indent_blankline,
-- })

package({
  'shellRaining/hlchunk.nvim',
  event = { 'UIEnter' },
  config = conf.hlchunk,
})

package({ 'glepnir/dashboard-nvim', event = 'BufWinEnter', config = conf.dashboard })

package({
  'nvim-tree/nvim-tree.lua',
  cmd = {
    'NvimTreeToggle',
    'NvimTreeOpen',
    'NvimTreeFindFile',
    'NvimTreeFindFileToggle',
    'NvimTreeRefresh',
  },
  config = conf.nvim_tree,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
})

package({
  'akinsho/nvim-bufferline.lua',
  event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  config = conf.nvim_bufferline,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
})

package({
  'folke/noice.nvim',
  event = 'VeryLazy',
  config = conf.noice,
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- 'rcarriga/nvim-notify',  -- if disabled, always use mini view
  },
})

package({
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  config = conf.lualine,
})

package({
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = conf.gitsigns,
})

package({
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
  config = conf.diffview,
})

-- package({
--   'rebelot/heirline.nvim',
--   event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
--   dependencies = { 'zeioth/heirline-components.nvim', 'kanagawa' },
--   config = conf.heirline,
-- })
