local config = {}

function config.crates()
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
    null_ls = {
      enabled = true,
      name = 'crates.nvim',
    },
  })

  local crates = require('crates')
  local keymap = require('core.keymap')
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
end

function config.headlines()
  require('headlines').setup({
    markdown = {
      query = vim.treesitter.query.parse(
        'markdown',
        [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
            ]]
      ),
      headline_highlights = { 'Headline' },
      codeblock_highlight = 'CodeBlock',
      dash_highlight = 'Dash',
      dash_string = '-',
      quote_highlight = 'Quote',
      quote_string = '┃',
      fat_headlines = true,
      fat_headline_upper_string = '▃',
      fat_headline_lower_string = '🬂',
    },
    yaml = {
      query = vim.treesitter.query.parse(
        'yaml',
        [[
                (
                    (comment) @dash
                    (#match? @dash "^# ---+$")
                )
            ]]
      ),
      dash_highlight = 'Dash',
    },
    telekasten = {
      query = vim.treesitter.query.parse(
        'markdown',
        [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
            ]]
      ),
      treesitter_language = 'markdown',
      headline_highlights = { 'Headline' },
      codeblock_highlight = 'CodeBlock',
      dash_highlight = 'Dash',
      dash_string = '-',
      quote_highlight = 'Quote',
      quote_string = '┃',
      fat_headlines = true,
      fat_headline_upper_string = '▃',
      fat_headline_lower_string = '🬂',
    },
  })
end

return config
