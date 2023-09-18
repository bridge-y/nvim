local package = require('core.pack').package
local conf = require('modules.completion.config')

package({
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  lazy = true,
  config = false,
  init = function()
    -- Disable automatic setup, we are doing it manually
    vim.g.lsp_zero_extend_cmp = 0
    vim.g.lsp_zero_extend_lspconfig = 0
  end,
})

package({
  'williamboman/mason.nvim',
  lazy = false,
  config = true,
})

-- Autocompletion
package({
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'hrsh7th/cmp-buffer' }, -- Optional
    { 'hrsh7th/cmp-path' }, -- Optional
    { 'saadparwaiz1/cmp_luasnip', config = conf.lua_snip }, -- Optional
    { 'hrsh7th/cmp-nvim-lua' }, -- Optional
    { 'petertriho/cmp-git' }, -- Optional
    { 'onsails/lspkind.nvim' },
    { 'ray-x/lsp_signature.nvim' },
    -- Snippets
    { 'L3MON4D3/LuaSnip' }, -- Required
    { 'rafamadriz/friendly-snippets' }, -- Optional

    {
      'hrsh7th/cmp-cmdline',
      event = 'CmdlineEnter',
      config = conf.cmp_cmdline,
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
      },
    },
    { 'lukas-reineke/cmp-under-comparator' },
  },
  config = conf.nvim_cmp,
})

package({
  'neovim/nvim-lspconfig',
  cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
  event = { 'BufReadPre', 'BufNewFile', 'BufNew' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Utility

    -- LSP setting
    {
      'folke/neoconf.nvim',
      config = function()
        require('neoconf').setup({})
      end,
    },
    { 'tamago324/nlsp-settings.nvim', config = conf.nlspsettings },
    {
      'lvimuser/lsp-inlayhints.nvim',
      config = function()
        require('lsp-inlayhints').setup({})
        vim.cmd('hi! LspInlayHint guifg=#403d52 guibg=#1f1d2e')
      end,
    },
  },
  config = conf.nvim_lspconfig,
})

package({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  config = conf.lspsaga,
})

package({
  'dnlhc/glance.nvim',
  event = 'LspAttach',
  config = function()
    require('glance').setup()
  end,
})

package({
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'CursorHold', 'CursorHoldI' },
  dependencies = { 'jay-babu/mason-null-ls.nvim' },
  config = conf.null_ls,
})

package({
  'hrsh7th/nvim-insx',
  event = 'InsertEnter',
  config = function()
    require('insx.preset.standard').setup()
  end,
})

-- Ai coding
package({
  'jcdickinson/codeium.nvim',
  config = true,
  ft = { 'python', 'go', 'rust' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'jcdickinson/http.nvim', build = 'cargo build --workspace --release' },
  },
})
