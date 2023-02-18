local package = require('core.pack').package

package({
  'iamcco/markdown-preview.nvim',
  lazy = true,
  ft = { 'markdown' },
  build = ':call mkdp#util#install()',
})
