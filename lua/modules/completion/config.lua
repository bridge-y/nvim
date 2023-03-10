local config = {}

function config.lua_snip()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')
  ls.config.set_config({
    history = true,
    enable_autosnippets = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = { virt_text = { { '<- choiceNode', 'Comment' } } },
      },
    },
  })
  require('luasnip.loaders.from_lua').lazy_load({
    paths = vim.fn.stdpath('config') .. '/snippets',
  })
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = { './snippets/' } })
end

function config.lsp_zero()
  -- local keymap = require('core.keymap')
  -- local nmap = keymap.nmap
  -- local cmd = keymap.cmd

  -- code formatting
  -- nmap({ 'gf', cmd('LspZeroFormat!') })

  -- nlsp-settings setting
  local nlspsettings = require('nlspsettings')

  nlspsettings.setup({
    config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
    local_settings_dir = '.nlsp-settings',
    local_settings_root_markers_fallback = { '.git' },
    append_default_schemas = true,
    loader = 'json',
  })

  -- neoconf settings
  -- needs to be located before nvim-lspconfig
  local neoconf_ok, neoconf = pcall(require, 'neoconf')
  if neoconf_ok then
    neoconf.setup({})
  end

  -- Learn the keybindings, see :help lsp-zero-keybindings
  -- Learn to configure LSP servers, see :help lsp-zero-api-showcase
  local lsp = require('lsp-zero')

  -- settings by lsp-compe
  lsp.preset('lsp-compe')
  lsp.set_preferences({
    sign_icons = {
      error = ' ',
      warn = ' ',
      info = ' ',
      hint = ' ',
    },
    -- omit keys that lspsaga uses.
    set_lsp_keymaps = {
      omit = {
        '<F2>',
        'K',
        'gd',
        '[d',
        ']d',
        '<F4>',
        'gl',
      },
    },
  })

  -- nlsp-settings requires jsonls
  lsp.ensure_installed({
    'jsonls',
    'pyright',
    -- "diagnosticls",
  })

  -- (Optional) Configure lua language server for neovim
  lsp.nvim_workspace()

  -- settings of server are located before .setup()
  local conf = require('modules.completion.lspconfig')
  -- lsp.configure('pylsp', conf.pylsp())
  -- lsp.configure('diagnosticls', conf.dls())
  lsp.configure('pyright', conf.pyright())

  lsp.setup()

  -- lsp settings need to be located after lsp.setup()
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

  local cmp_config = lsp.defaults.cmp_config({
    preselect = cmp.PreselectMode.Item,
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = lsp.defaults.cmp_mappings({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-c>'] = cmp.mapping.abort(),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help' },
    },
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
      format = lspkind.cmp_format({
        mode = 'symbol', -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      }),
    },
  })

  cmp.setup(cmp_config)

  -- diagnostic text setting
  vim.diagnostic.config({ virtual_text = { prefix = '🔥', source = true } })

  -- null-ls settings
  local null_ls = require('null-ls')
  local null_opts = lsp.build_options('null-ls', {})

  -- code formatting by null-ls
  -- nmap({ "gf", cmd("NullFormat") })

  null_ls.setup({
    on_attach = function(client, bufnr)
      null_opts.on_attach(client, bufnr)

      local format_cmd = function(input)
        vim.lsp.buf.format({
          id = client.id,
          timeout_ms = 5000,
          async = input.bang,
        })
      end

      local bufcmd = vim.api.nvim_buf_create_user_command
      bufcmd(bufnr, 'NullFormat', format_cmd, { bang = true, range = true, desc = 'Format using null-ls' })
    end,
    root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git', 'pyproject.toml'),
    sources = {
      --- Replace these with the tools you have installed
      null_ls.builtins.formatting.black.with({
        extra_args = { '--config', 'pyproject.toml' },
        condition = function(utils)
          return utils.root_has_file({ 'pyproject.toml' })
        end,
      }),
      null_ls.builtins.diagnostics.pyproject_flake8,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.fish_indent,
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { '-i', '2' },
      }),
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.textlint.with({ filetypes = { 'markdown' } }),
      null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.code_actions.gitsigns,
      -- null_ls.builtins.formatting.lua_format.with({
      --   extra_args = {
      --     "--no-use-tab",
      --     [[--indent-width=2]],
      --     "-break-after-functioncall-lp",
      --     "--break-before-functioncall-rp",
      --     "--align-table-field",
      --     "--single_quote_to_double_quote",
      --     [[--column_table_limit=1]]
      --   }
      -- })
    },
  })

  require('mason-null-ls').setup({
    ensure_installed = nil,
    automatic_installation = true, -- You can still set this to `true`
    automatic_setup = true,
  })

  -- Required when `automatic_setup` is true
  require('mason-null-ls').setup_handlers()
end

function config.cmp_cmdline()
  local cmp = require('cmp')
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
    }, {
      { name = 'buffer' },
    }),
  })
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
    }),
  })
end

function config.lspsaga()
  require('lspsaga').setup({
    preview = {
      lines_above = 1,
      lines_below = 17,
    },
    scroll_preview = {
      scroll_down = '<C-j>',
      scroll_up = '<C-k>',
    },
    finder = {
      -- percentage
      max_height = 0.5,
      keys = {
        jump_to = 'e',
        edit = { 'o', '<CR>' },
        vsplit = 'v',
        split = 's',
        tabe = 't',
        quit = { 'q', '<ESC>' },
        close_in_preview = '<ESC>',
      },
    },
    definition = {
      edit = 'e',
      vsplit = 'v',
      split = 's',
      tabe = 't',
      quit = 'q',
      close = '<Esc>',
    },
    code_action = {
      num_shortcut = true,
      keys = {
        quit = 'q',
        exec = '<CR>',
      },
    },
    lightbulb = {
      enable = false,
      -- enable = true,
      sign = true,
      enable_in_insert = true,
      sign_priority = 20,
      virtual_text = false,
      -- virtual_text = true,
    },
    diagnostic = {
      show_code_action = true,
      border_follow = true,
      show_source = true,
      jump_num_shortcut = true,
      keys = {
        exec_action = '<CR>',
        quit = 'q',
        go_action = 'g',
      },
    },
    rename = {
      quit = { '<C-c>', '<ESC>' },
      exec = '<CR>',
      mark = 'x',
      confirm = '<CR>',
      in_select = true,
    },
    outline = {
      win_position = 'right',
      win_with = '_sagaoutline',
      win_width = 30,
      show_detail = true,
      auto_preview = false,
      auto_refresh = true,
      auto_close = true,
      keys = {
        jump = '<CR>',
        expand_collapse = 'u',
        quit = 'q',
      },
    },
    symbol_in_winbar = {
      enable = false,
    },
    beacon = {
      enable = true,
      frequency = 12,
    },
    ui = {
      winblend = 10,
      border = 'rounded',
      colors = { normal_bg = '#002b36' },
    },
  })

  -- local keymap = require('core.keymap')
  -- local nmap, vmap = keymap.nmap, keymap.vmap
  -- local cmd = keymap.cmd

  -- nmap({
  --   { 'K', cmd('Lspsaga hover_doc') },
  --   { '<F2>', cmd('Lspsaga rename') },
  --   { 'gd', cmd('Lspsaga lsp_finder') },
  --   { 'gp', cmd('Lspsaga peek_definition') },
  --   { '[d', cmd('Lspsaga diagnostic_jump_prev') },
  --   { ']d', cmd('Lspsaga diagnostic_jump_next') },
  --   { '<F4>', cmd('Lspsaga code_action') },
  --   { 'gl', cmd('Lspsaga show_line_diagnostics') },
  --   { '<leader>go', cmd('Lspsaga outline') },
  -- })
  -- vmap({ '<F4>', cmd('Lspsaga code_action') })
end

function config.auto_pairs()
  require('nvim-autopairs').setup({})
  local status, cmp = pcall(require, 'cmp')
  if not status then
    vim.cmd([[packadd nvim-cmp]])
    cmp = require('cmp')
  end
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
end

return config
