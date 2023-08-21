local package = require('core.pack').package
local conf = require('modules.completion.config')

package({
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  lazy = true,
  config = conf.lsp_zero,
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
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile', 'BufNew' },
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason-lspconfig.nvim' },
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },

    -- Utility
    { 'glepnir/lspsaga.nvim', config = conf.lspsaga },
    {
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup()
      end,
    },

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
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'CursorHold', 'CursorHoldI' },
  dependencies = { 'jay-babu/mason-null-ls.nvim' },
  config = conf.null_ls,
})

package({ 'windwp/nvim-autopairs', event = 'InsertEnter', config = conf.auto_pairs })
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
