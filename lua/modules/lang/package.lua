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

