local package = require('core.pack').package
local conf = require('modules.lang.config')

package({
  'iamcco/markdown-preview.nvim',
  lazy = true,
  ft = { 'markdown' },
  build = ':call mkdp#util#install()',
})

package({
  'saecki/crates.nvim',
  event = { 'BufRead Cargo.toml' },
  requires = { { 'nvim-lua/plenary.nvim' } },
  config = conf.crates,
})

package({
  'mrcjkb/rustaceanvim',
  version = '^3', -- Recommended
  ft = { 'rust' },
})

package({
  'lukas-reineke/headlines.nvim',
  ft = { 'markdown', 'telekasten', 'yaml' },
  config = conf.headlines,
})

package({
  'topazape/md-preview.nvim',
  ft = { 'md', 'markdown', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'rmd', 'wiki', 'zettelkasten' },
  config = function()
    require('md-preview').setup({})
  end,
})

package({
  'windwp/nvim-ts-autotag',
  ft = {
    'astro',
    'glimmer',
    'handlebars',
    'html',
    'javascript',
    'javascriptreact',
    'jsx',
    'markdown',
    'php',
    'rescript',
    'svelte',
    'tsx',
    'typescript',
    'typescriptreact',
    'vue',
    'xml',
  },
  config = function()
    require('nvim-ts-autotag').setup()
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        spacing = 5,
        severity_limit = 'Warning',
      },
      update_in_insert = true,
    })
  end,
})
