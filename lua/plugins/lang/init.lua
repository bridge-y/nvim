return {
  -- 'iamcco/markdown-preview.nvim',
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    ft = { 'markdown', 'telekasten' },
    build = ':call mkdp#util#install()',
  },

  -- 'saecki/crates.nvim',
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      local function show_documentation()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ 'vim', 'help' }, filetype) then
          vim.cmd('h ' .. vim.fn.expand('<cword>'))
        elseif vim.tbl_contains({ 'man' }, filetype) then
          vim.cmd('Man ' .. vim.fn.expand('<cword>'))
        elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
          require('crates').show_popup()
        else
          vim.lsp.buf.hover()
        end
      end

      -- code action
      local null_ls = require('null-ls')
      require('crates').setup({
        src = {
          cmp = {
            enabled = true,
          },
        },
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
      })

      local crates = require('crates')
      local keymap = require('utils.keymap')
      local nmap, vmap = keymap.nmap, keymap.vmap
      local silent = keymap.silent
      local opts = keymap.new_opts

      nmap({
        { '<leader>Ct', crates.toggle, opts(silent, 'Crates: Enable or disable UI elements') },
        { '<leader>Cr', crates.reload, opts(silent, 'Crates: Reload data') },
        { '<leader>CK', show_documentation, opts(silent, 'Crates: Show/hide popup with crate details') },
        {
          '<leader>Cv',
          crates.show_versions_popup,
          opts(silent, 'Crates: Show/hide popup with crate details (always show verions)'),
        },
        {
          '<leader>Cf',
          crates.show_features_popup,
          opts(silent, 'Crates: Show/hide popup with crate details (always show features)'),
        },
        {
          '<leader>Cd',
          crates.show_dependencies_popup,
          opts(silent, 'Crates: Show/hide popup with crate details (always show dependencies)'),
        },

        { '<leader>Cu', crates.update_crate, opts(silent, 'Crates: Update crate') },
        { '<leader>Ca', crates.update_all_crates, opts(silent, 'Crates: Update all crates') },
        { '<leader>CU', crates.upgrade_crate, opts(silent, 'Crates: Upgrade crate') },
        { '<leader>CA', crates.upgrade_all_crates, opts(silent, 'Crates: Upgrade all crates') },

        {
          '<leader>Ce',
          crates.expand_plain_crate_to_inline_table,
          opts(silent, 'Crates: Expand a plain crate declaration into an inline table'),
        },
        {
          '<leader>CE',
          crates.extract_crate_into_table,
          opts(silent, 'Crates: Extract an crate declaration from a dependency section into a table'),
        },

        { '<leader>CH', crates.open_homepage, opts(silent, 'Crates: Open the homepage of the crate') },
        { '<leader>CR', crates.open_repository, opts(silent, 'Crates: Open the repository page of the crate') },
        { '<leader>CD', crates.open_documentation, opts(silent, 'Crates: Open the documentation page of the crate') },
        { '<leader>Cc', crates.open_documentation, opts(silent, 'Crates: Open the `crate.io` page of the crate') },
      })

      vmap({
        { '<leader>Cu', crates.update_crates, opts(silent, 'Crates: Update crate') },
        { '<leader>CU', crates.upgrade_crates, opts(silent, 'Crates: Upgrade crate') },
      })
    end,
  },

  -- 'mrcjkb/rustaceanvim',
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },

  -- 'topazape/md-preview.nvim',
  {
    'topazape/md-preview.nvim',
    ft = {
      'md',
      'markdown',
      'mkd',
      'mkdn',
      'mdwn',
      'mdown',
      'mdtxt',
      'mdtext',
      'rmd',
      'wiki',
      'telekasten',
    },
    opts = {},
  },

  -- 'OXY2DEV/markview.nvim',
  {
    'OXY2DEV/markview.nvim',
    -- lazy = false, -- Recommended
    ft = { 'markdown', 'telekasten' }, -- If you decide to lazy-load anyway
    -- ft = { 'markdown', 'telekasten', 'Avante' }, --not work on Avante
    opts = {
      preview = {
        filetypes = { 'markdown', 'telekasten' },
        -- filetypes = { 'markdown', 'telekasten', 'Avante' },  -- not work on Avante
        -- ignore_buftypes = {},
      },
    },
    config = function()
      -- Load the checkboxes module.
      require('markview.extras.checkboxes').setup()
    end,
  },

  -- 'windwp/nvim-ts-autotag',
  {
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
    opts = {},
    config = function()
      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
          spacing = 5,
          severity_limit = 'Warning',
        },
        update_in_insert = true,
      })
    end,
  },
}
