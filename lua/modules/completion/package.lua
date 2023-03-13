local package = require('core.pack').package
local conf = require('modules.completion.config')

package({
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  config = conf.lsp_zero,
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' }, -- Required
    { 'williamboman/mason.nvim' }, -- Optional
    { 'williamboman/mason-lspconfig.nvim' }, -- Optional

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' }, -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'hrsh7th/cmp-buffer' }, -- Optional
    { 'hrsh7th/cmp-path' }, -- Optional
    { 'saadparwaiz1/cmp_luasnip', config = conf.lua_snip }, -- Optional
    { 'hrsh7th/cmp-nvim-lua' }, -- Optional
    { 'onsails/lspkind.nvim' },
    { 'ray-x/lsp_signature.nvim' },

    -- Utility
    { 'glepnir/lspsaga.nvim', config = conf.lspsaga },
    {
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup()
      end,
    },

    -- Snippets
    { 'L3MON4D3/LuaSnip' }, -- Required
    { 'rafamadriz/friendly-snippets' }, -- Optional

    -- LSP setting
    { 'folke/neoconf.nvim' },
    { 'tamago324/nlsp-settings.nvim' },

    -- Formatters and linters
    { 'jose-elias-alvarez/null-ls.nvim', dependencies = { 'jay-babu/mason-null-ls.nvim' } },
  },
})

-- Important: load after lsp-zero
package({
  'hrsh7th/cmp-cmdline',
  event = 'CmdlineEnter',
  config = conf.cmp_cmdline,
  dependencies = {
    { 'hrsh7th/nvim-cmp' }, -- Required
    { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
  },
})

package({ 'windwp/nvim-autopairs', event = 'InsertEnter', config = conf.auto_pairs })
