local package = require('core.pack').package
local conf = require('modules.tools.config')

package({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = conf.telescope,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'ahmedkhalf/project.nvim', event = 'BufReadPost', config = conf.project },
    { 'debugloop/telescope-undo.nvim' },
    { 'nvim-telescope/telescope-media-files.nvim' },
    { 'fdschmidt93/telescope-egrepify.nvim' },
  },
})

package({
  'glepnir/hlsearch.nvim',
  event = 'BufRead',
  config = function()
    require('hlsearch').setup()
  end,
})

-- noice can do same.
-- package({
--   'kevinhwang91/nvim-hlslens',
--   keys = '/',
--   config = function()
--     require('hlslens').setup()
--   end,
-- })

package({
  'ziontee113/icon-picker.nvim',
  cmd = { 'IconPickerInsert', 'IconPickerYank', 'IconPickerNormal' },
  config = function()
    require('icon-picker').setup({
      disable_legacy_commands = true,
    })
  end,
})

package({
  'dstein64/vim-startuptime',
  cmd = 'StartupTime',
})

package({
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G' },
})

package({
  'folke/trouble.nvim',
  cmd = { 'Trouble', 'TroubleToggle', 'TroubleRefresh' },
})

package({
  'mrjones2014/legendary.nvim',
  cmd = 'Legendary',
  config = conf.legendary,
  dependencies = {
    { 'kkharji/sqlite.lua' },
    {
      'stevearc/dressing.nvim',
      event = 'VeryLazy',
      config = conf.dressing,
    },
    {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      config = conf.which_key,
    },
  },
})

package({
  'renerocksai/telekasten.nvim',
  cmd = 'Telekasten',
  config = conf.telekasten,
  dependencies = { 'nvim-telescope/telescope.nvim' },
})

package({
  'keaising/im-select.nvim',
  event = { 'InsertEnter' },
  config = function()
    require('im_select').setup()
  end,
})

package({
  'pwntester/octo.nvim',
  cmd = { 'Octo' },
  config = function()
    require('octo').setup()
    vim.treesitter.language.register('markdown', 'octo')
  end,
})

package({
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle' },
  config = function()
    require('overseer').setup()
  end,
})

package({
  'subnut/nvim-ghost.nvim',
  cmd = 'GhostTextStart',
})

package({
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
})

package({
  {
    '3rd/image.nvim',
    opts = {},
  },
}, {
  rocks = {
    hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
  },
})

package({
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
  opts = {
    -- add any opts here
    provider = 'ollama',
    vendors = {
      ollama = {
        __inherited_from = 'openai',
        api_key_name = '',
        disable_tools = true,
        -- TODO: replace ip address and model name
        endpoint = 'http://192.0.2.1:11434/v1',
        model = 'phi4',
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
})

