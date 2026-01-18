return {
  -- 'VonHeikemen/lsp-zero.nvim',
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = true,
    config = false,
  },

  -- 'williamboman/mason.nvim',
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    lazy = false,
    config = true,
  },

  -- 'hrsh7th/nvim-cmp',
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      local lsp_zero = require('lsp-zero')
      local cmp_action = lsp_zero.cmp_action()

      local cmp = require('cmp')
      local lspkind = require('lspkind')

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'treesitter' },
          { name = 'codecompanion' },
          { name = 'codeium' },
          { name = 'git' },
          { name = 'crates' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-c>'] = cmp.mapping.abort(),

          -- Navigate between snippet placeholder
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),

          -- Scroll up and down in the completion documentation
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = cmp_action.tab_complete(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require('cmp-under-comparator').under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        formatting = {
          fields = { 'menu', 'abbr', 'kind' },
          format = lspkind.cmp_format({
            mode = 'symbol',       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            symbol_map = { Codeium = '' },
          }),
        },
      })
    end,
  },
  { 'hrsh7th/cmp-buffer', lazy = true }, -- Optional
  { 'hrsh7th/cmp-path',   lazy = true }, -- Optional
  {
    'saadparwaiz1/cmp_luasnip',
    lazy = true,
    config = function()
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
    end,
  },                                               -- Optional
  { 'hrsh7th/cmp-nvim-lua',         lazy = true }, -- Optional
  { 'petertriho/cmp-git',           lazy = true }, -- Optional
  { 'onsails/lspkind.nvim',         lazy = true },
  { 'ray-x/lsp_signature.nvim',     lazy = true },
  { 'ray-x/cmp-treesitter',         lazy = true },
  -- Snippets
  { 'L3MON4D3/LuaSnip',             lazy = true }, -- Required
  { 'rafamadriz/friendly-snippets', lazy = true }, -- Optional
  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    config = function()
      local cmp = require('cmp')
      cmp.setup.cmdline({ '/', '?' }, {
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
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp-document-symbol', lazy = true },
  { 'lukas-reineke/cmp-under-comparator',   lazy = true },

  -- 'neovim/nvim-lspconfig',
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile', 'BufNew' },
    -- ref: https://lsp-zero.netlify.app/docs/guide/lazy-loading-with-lazy-nvim.html
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- lsp_signature
      -- https://github.com/VonHeikemen/lsp-zero.nvim/issues/69
      local lsp_signature_config = {
        bind = true,    -- This is mandatory, otherwise border config won't get registered.
        fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
        noice = true,   -- set to true if you using noice to render markdown
        handler_opts = {
          border = 'rounded',
        },
      }

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities =
          vim.tbl_deep_extend('force', lsp_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          -- vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          -- vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

          require('lsp_signature').on_attach(lsp_signature_config, event.buf)
        end,
      })

      -- diagnostic text setting
      -- ref: https://github.com/izumin5210/dotfiles/blob/aa17b272068491d24e7e52bd9fb58903c6947e4f/config/.config/nvim/lua/plugins/lsp/init.lua
      vim.diagnostic.config({
        virtual_text = { prefix = '🔥', source = true },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticErrorLine',
            [vim.diagnostic.severity.WARN] = 'DiagnosticWarnLine',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHintLine',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfoLine',
          },
        },
      })
      local signs = {
        Error = ' ',
        Warn = ' ',
        Info = ' ',
        Hint = ' ',
      }
      for type, icon in pairs(signs) do
        local name = 'DiagnosticSign' .. type
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end

      require('neodev').setup({})

      -- lsp common setting
      vim.lsp.config('*', {
        on_attach = function(client, bufnr)
          -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          -- NOTE: To use fuzzy finder instead of quickfix list
          -- other keymaps like GoToImplementation, GoToReferences are set in telescope.nvim config
          -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'LSP: [G]oto [D]efinition' })
          -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'LSP: [G]oto [D]eclaration' })

          -- vim.lsp.completion.enable(true, client.id, bufnr, {
          --   autotrigger = true, -- 自動補完を有効にする
          --   convert = function(item)
          --     return { abbr = item.label:gsub('%b()', '') }
          --   end,
          -- })

          -- -- Inlay hints (Neovim 0.10+)
          -- if vim.lsp.inlay_hint then
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- end

          -- -- Format on save (opt-in per server)
          -- if client.server_capabilities.documentFormattingProvider then
          --   vim.api.nvim_create_autocmd('BufWritePre', {
          --     buffer = bufnr,
          --     callback = function()
          --       vim.lsp.buf.format({ async = false })
          --     end,
          --   })
          -- end
          require('lsp_signature').on_attach(lsp_signature_config, bufnr)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      require('mason-lspconfig').setup()

      -- These are just examples. Replace them with the language
      -- servers you have installed in your system
      vim.lsp.enable({
        -- nvim-lspconfig で"lua_ls"という名前で設定したプリセットが読まれる
        -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'pylsp',
        'tsserver',
        'gopls',
        'ruff',
        'biome',
        'dockerls',
        'docker_compose_language_service',
        'dockerfile_language_server',
        'jsonls',
        'marksman',
        'shellcheck',
        'shfmt',
        'stylua',
      })
    end,
    -- config = function()
    --   local lsp_zero = require('lsp-zero')
    --
    --   -- lsp_signature
    --   -- onttps://github.com/VonHeikemen/lsp-zero.nvim/issues/69
    --   local lsp_signature_config = {
    --     bind = true, -- This is mandatory, otherwise border config won't get registered.
    --     fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
    --     noice = true, -- set to true if you using noice to render markdown
    --     handler_opts = {
    --       border = 'rounded',
    --     },
    --   }
    --
    --   local lsp_attach = function(client, buffer)
    --     lsp_zero.default_keymaps({
    --       buffer = bufnr,
    --       omit = {
    --         '<F2>',
    --         'K',
    --         'gd',
    --         '[d',
    --         ']d',
    --         '<F4>',
    --         'gl',
    --       },
    --     })
    --     require('lsp_signature').on_attach(lsp_signature_config, bufnr)
    --   end
    --
    --   -- for rustaceanvim
    --   vim.g.rustaceanvim = {
    --     server = {
    --       capabilities = lsp_zero.get_capabilities(),
    --     },
    --   }
    --
    --   -- for nvim-ufo
    --   local lsp_capabilities = vim.tbl_deepextend_lspconfig_extend('force', require('cmp_nvim_lsp').default_capabilities(), {
    --     textDocument = {
    --       foldingRange = {
    --         dynamicRegistration = false,
    --         lineFoldingOnly = true,
    --       },
    --     },
    --   })
    --
    --   lsp_zero.extend_lspconfig({
    --     capabilities = lsp_capabilities,
    --     lsp_attach = lsp_attach,
    --   })
    --
    --   -- diagnostic text setting
    --   vim.diagnostic.config({ virtual_text = { prefix = '🔥', source = true } })
    --
    --   lsp_zero.ui({
    --     float_border = 'rounded',
    --     error = ' ',
    --     warn = ' ',
    --     info = ' ',
    --     hint = ' ',
    --   })
    --
    --   local conf = require('plugins.completion.lspconfig')
    --   local ih = require('lsp-inlayhints')
    --   require('neodev').setup({})
    --
    --   require('mason-lspconfig').setup({
    --     ensure_installed = {
    --       -- nlsp-settings requires jsonls
    --       'jsonls',
    --       -- python
    --       'pyright',
    --       'ruff',
    --       -- rust
    --       'rust_analyzer',
    --       -- docker
    --       'dockerls',
    --       'docker_compose_language_service',
    --       -- markdown
    --       'marksman',
    --       -- javascript/typescript
    --       'biome',
    --       'html',
    --       'tailwindcss',
    --       -- golang
    --       'gopls',
    --       -- bash
    --       'bashls',
    --       -- "diagnosticls",
    --     },
    --     handlers = {
    --       lsp_zero.default_setup,
    --       lua_ls = function()
    --         require('lspconfig').lua_ls.setup({
    --           on_attach = function(client, bufnr)
    --             ih.on_attach(client, bufnr)
    --           end,
    --           settings = {
    --             Lua = {
    --               hint = {
    --                 enable = true,
    --               },
    --               completion = {
    --                 callSnippet = 'Replace',
    --               },
    --             },
    --           },
    --         })
    --       end,
    --       pyright = function()
    --         require('lspconfig').pyright.setup(conf.pyright())
    --       end,
    --       rust_analyzer = lsp_zero.noop, -- for rustaceanvim
    --       gopls = function()
    --         require('lspconfig').gopls.setup(conf.gopls())
    --       end,
    --       -- rust_analyzer = function()
    --       --   require('lspconfig').rust_analyzer.setup(conf.rust_analyzer())
    --       -- end,
    --       -- diagnosticls = function()
    --       --   lsp.configure('diagnosticls', conf.dls())
    --       -- end,
    --       ruff = require('lspconfig').ruff.setup(conf.ruff_lsp()),
    --     },
    --   })
    --
    --   -- format on save
    --   lsp_zero.format_on_save({
    --     format_opts = {
    --       timeout_ms = 10000,
    --     },
    --     servers = {
    --       ['null-ls'] = {
    --         'markdown',
    --         'telekasten',
    --         'lua',
    --         'octo',
    --         'sh',
    --         'javascript',
    --         'javascriptreact',
    --         'typescript',
    --         'typescriptreact',
    --       },
    --       ['rust_analyzer'] = { 'rust' },
    --       ['ruff'] = { 'python' },
    --     },
    --   })
    -- end,
  },
  { 'hrsh7th/cmp-nvim-lsp',           lazy = true },
  { 'mason-org/mason-lspconfig.nvim', lazy = true },

  -- LSP setting
  {
    'folke/neoconf.nvim',
    lazy = true,
    opts = {},
  },
  {
    'tamago324/nlsp-settings.nvim',
    lazy = true,
    opts = {
      config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
      local_settings_dir = '.nlsp-settings',
      local_settings_root_markers_fallback = { '.git' },
      append_default_schemas = true,
      loader = 'json',
    },
  },
  {
    'lvimuser/lsp-inlayhints.nvim',
    lazy = true,
    config = function()
      require('lsp-inlayhints').setup({})
      vim.cmd('hi! LspInlayHint guifg=#403d52 guibg=#1f1d2e')
    end,
  },

  { 'folke/neodev.nvim',           lazy = true, opts = {} },

  -- 'nvimdev/lspsaga.nvim',
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    opts = {
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
    },
  },

  -- 'dnlhc/glance.nvim',
  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    opts = {},
  },

  -- 'nvimtools/none-ls.nvim',
  {
    'nvimtools/none-ls.nvim',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function()
      local null_ls = require('null-ls')

      null_ls.setup({
        diagnostics_format = '#{m} (#{s}: #{c})',
        root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git', 'pyproject.toml'),
        sources = {
          --- Replace these with the tools you have installed
          -- null_ls.builtins.formatting.black.with({
          --   extra_args = { '--config', 'pyproject.toml' },
          --   condition = function(utils)
          --     return utils.root_has_file({ 'pyproject.toml' })
          --   end,
          -- }),
          -- null_ls.builtins.diagnostics.pyproject_flake8,
          -- null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.rustywind,
          -- null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.fish_indent,
          -- null_ls.builtins.formatting.shfmt.with({
          --   extra_args = { '-i', '2' },
          -- }),
          -- null_ls.builtins.formatting.prettier,
          -- null_ls.builtins.diagnostics.textlint.with({ filetypes = { 'markdown', 'telekasten' } }),
          -- null_ls.builtins.formatting.prettier.with({ extra_filetypes = { 'telekasten', 'octo' } }),
          -- null_ls.builtins.formatting.biome.with({
          --   args = {
          --     'check',
          --     '--apply-unsafe',
          --     '--formatter-enabled=true',
          --     '--organize-imports-enabled=true',
          --     '--skip-errors',
          --     '$FILENAME',
          --   },
          --   filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'css', 'graphql' },
          -- }),
          -- null_ls.builtins.formatting.textlint.with({ extra_filetypes = { 'telekasten', 'octo' } }),
          null_ls.builtins.diagnostics.textlint.with({ extra_filetypes = { 'telekasten' } }),
          null_ls.builtins.code_actions.gitsigns,
        },
      })

      require('mason-null-ls').setup({
        ensure_installed = nil,
        automatic_installation = { exclude = { 'textlint' } },
        automatic_setup = true,
      })
    end,
  },
  { 'jay-babu/mason-null-ls.nvim', lazy = true },

  -- 'stevearc/conform.nvim',
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        'gf',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      formatters_by_ft = {
        fish = { 'fish_indent' },
        javascript = { 'biome', 'rustywind' },
        javascriptreact = { 'biome', 'rustywind' },
        json = { 'biome' },
        jsonc = { 'biome' },
        lua = { 'stylua' },
        markdown = { 'textlint', 'textlint_check' },
        telekasten = { 'textlint', 'textlint_check' },
        python = { 'ruff' },
        sh = { 'shfmt' },
        text = { 'textlint', 'textlint_check' },
        typescript = { 'biome', 'rustywind' },
        typescriptreact = { 'biome', 'rustywind' },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        black = {
          prepend_args = { '--config', 'pyproject.toml' },
        },
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        -- if add following settings, will occur error
        textlint = {
          command = { 'textlint' },
          args = { '--fix', '$FILENAME' },
        },
        -- textlint_check = {
        --   command = { 'textlint' },
        --   args = { '-f', 'json', '--stdin', '--stdin-filename', '$FILENAME' },
        -- },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- 'hrsh7th/nvim-insx',
  {
    'hrsh7th/nvim-insx',
    event = 'InsertEnter',
    config = function()
      require('insx.preset.standard').setup()
    end,
  },

  -- 'jcdickinson/codeium.nvim',
  {
    'jcdickinson/codeium.nvim',
    config = true,
    ft = { 'python', 'go', 'rust' },
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'jcdickinson/http.nvim', build = 'cargo build --workspace --release', lazy = true },

  -- overlook.nvim
  {
    'WilliamHsieh/overlook.nvim',
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = vim.api.nvim_create_augroup('overlook_enter_mapping', { clear = true }),
        pattern = '*',
        callback = function()
          vim.schedule(function()
            if vim.w.is_overlook_popup then
              -- open in orig window on enter
              vim.keymap.set('n', '<CR>', function()
                require('overlook.api').open_in_original_window()
              end, { buffer = true, desc = 'Overlook: Open in original window' })

              -- open in vsplit on ctrl+enter
              for _, lhs in ipairs({ '<C-CR>', ';' }) do
                vim.keymap.set('n', lhs, function()
                  require('overlook.api').open_in_vsplit()
                end, { buffer = true, desc = 'Overlook: Open in vertical split' })
              end
            end
          end)
        end,
      })
    end,
    keys = {
      {
        '<leader>ou',
        function()
          require('overlook.api').restore_popup()
        end,
        { desc = 'Restore last popup' },
      },
      {
        '<leader>oU',
        function()
          require('overlook.api').restore_all_popups()
        end,
        { desc = 'Restore all popups' },
      },
      {
        '<leader>oc',
        function()
          require('overlook.api').close_all()
        end,

        { desc = 'Close all popups' },
      },
      {
        '<leader>os',
        function()
          require('overlook.api').open_in_split()
        end,
        { desc = 'Open popup in split' },
      },
      {
        '<leader>ov',
        function()
          require('overlook.api').open_in_vsplit()
        end,
        { desc = 'Open popup in vsplit' },
      },
      {
        '<leader>ot',
        function()
          require('overlook.api').open_in_tab()
        end,
        { desc = 'Open popup in tab' },
      },
      {
        '<leader>oo',
        function()
          require('overlook.api').open_in_original_window()
        end,
        { desc = 'Open popup in current window' },
      },
    },
  },
}
