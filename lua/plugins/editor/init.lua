return {
  -- nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    -- event = "BufReadPost",
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>',      desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    opts = {
      indent = { enable = true }, ---@type lazyvim.TSFeat
      highlight = { enable = true }, ---@type lazyvim.TSFeat
      folds = { enable = true }, ---@type lazyvim.TSFeat
      ensure_installed = 'all',
      ignore_install = 'phpdoc',
    },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('vim-treesitter-start', {}),
        callback = function(ctx)
          -- 必要に応じて`ctx.match`に入っているファイルタイプの値に応じて挙動を制御
          local ts = require("nvim-treesitter")
          local ok_available, available_langs = pcall(ts.get_available)

          local treesitter = vim.treesitter
          local ok_lang, lang = pcall(treesitter.language.get_lang, ctx.match)

          local tbl_contains = vim.tbl_contains
          if ok_available and ok_lang and tbl_contains(available_langs, lang) then
            local ok_installed, installed_langs = pcall(ts.get_installed)
            if ok_installed and not tbl_contains(installed_langs, lang) then
              pcall(ts.install, lang)
            end
            -- `pcall`でエラーを無視することでパーサーやクエリがあるか気にしなくてすむ
            pcall(vim.treesitter.start)
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            -- start vim-matchup
            pcall(require, 'match-up')
            -- start textobjects
            pcall(require, 'nvim-treesitter-textobjects')
            -- start treesitter-context
            pcall(require, 'treesitter-context')
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    branch = 'main',
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    opts = {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V',  -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    },
    config = function()
      -- move
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end)

      -- select
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
      end)
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-context', lazy = true },
  {
    'andymass/vim-matchup',
    lazy = true,
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },

  -- 'numToStr/Comment.nvim',
  {
    'numToStr/Comment.nvim',
    keys = {
      {
        '<C-_>',
        '<Plug>(comment_toggle_linewise_current)',
        noremap = true,
        mode = 'n',
        desc = 'Comment Toggle Current',
      },
      {
        '<C-_>',
        '<Plug>(comment_toggle_linewise_visual)',
        noremap = true,
        mode = 'x',
        desc = 'Comment Toggle Current',
      },
      {
        '<C-/>',
        '<Plug>(comment_toggle_linewise_current)',
        noremap = true,
        mode = 'n',
        desc = 'Comment Toggle Current',
      },
      {
        '<C-/>',
        '<Plug>(comment_toggle_linewise_visual)',
        noremap = true,
        mode = 'x',
        desc = 'Comment Toggle Current',
      },
    },
    opts = {},
  },

  -- 'ethanholz/nvim-lastplace',
  {
    'ethanholz/nvim-lastplace',
    event = { 'BufReadPost' },
    opts = {
      lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
      lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
      lastplace_open_folds = true,
    },
  },

  -- 'monaqa/dial.nvim',
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>',  '<Plug>(dial-increment)',  noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: increment' },
      { '<C-x>',  '<Plug>(dial-decrement)',  noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: decrement' },
      { 'g<C-a>', 'g<Plug>(dial-increment)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: increment' },
      { 'g<C-x>', 'g<Plug>(dial-decrement)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: decrement' },
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'], -- 2021/01/23, ...
          augend.date.alias['%Y-%m-%d'], -- 2021-01-04, ...
          augend.date.new({
            pattern = '%Y.%m.%d',
            default_kind = 'day',
            -- if true, it does not match dates which does not exist, such as 2022/05/32
            only_valid = true,
            -- if true, it only matches dates with word boundary
            word = false,
          }), -- 2021.01.04, ...
          augend.date.alias['%m/%d'], -- 01/04, 02/28, 12/25, ...
          augend.date.alias['%-m/%-d'], -- 1/4, 2/28. 12/25, ...
          augend.date.alias['%Y年%-m月%-d日'], -- 2021年1月4日, ...
          augend.date.alias['%Y年%-m月%-d日(%ja)'], -- 2021年1月4日(月), ...
          augend.date.alias['%H:%M:%S'], -- 14:30:00, ...
          augend.date.alias['%H:%M'], -- 14:30, ...
          augend.constant.alias.ja_weekday, -- 月, 火, ..., 土, 日
          augend.constant.alias.ja_weekday_full, -- 月曜日, 火曜日, ..., 日曜日
          augend.constant.alias.bool, -- true, false
          augend.constant.new({
            elements = { 'and', 'or' },
            word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }),
          augend.constant.new({
            elements = { '&&', '||' },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'True', 'False' },
            word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }),              -- Python's bool
          augend.hexcolor.new({
            case = 'lower',
          }),
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      })
    end,
  },

  -- 'akinsho/toggleterm.nvim',
  {
    'akinsho/toggleterm.nvim',
    event = 'UIEnter',
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.40
        end
      end,
      on_open = function()
        -- Prevent infinite calls from freezing neovim.
        -- Only set these options specific to this terminal buffer.
        vim.api.nvim_set_option_value('foldmethod', 'manual', { scope = 'local' })
        vim.api.nvim_set_option_value('foldexpr', '0', { scope = 'local' })
      end,
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = '1',   -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell,  -- change the default shell
      winbar = {
        enabled = true,
        name_formatter = function(term) --  term: Terminal
          return term.name
        end,
      },
    },
  },

  -- 'watanany/tabtoggleterm.nvim',
  {
    'watanany/tabtoggleterm.nvim',
    event = 'UIEnter',
    opts = {
      size = 20,
    },
  },

  -- 'NvChad/nvim-colorizer.lua',
  {
    'NvChad/nvim-colorizer.lua',
    event = 'UIEnter',
    opts = {},
  },

  -- 'smoka7/hop.nvim',
  {
    'smoka7/hop.nvim',
    version = '*',
    event = { 'CursorHold', 'CursorHoldI' },
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
    },
  },

  -- 'smjonas/inc-rename.nvim',
  {
    'smjonas/inc-rename.nvim',
    event = { 'CursorHold', 'CursorHoldI' },
    opts = {},
  },

  -- 'LunarVim/bigfile.nvim',
  {
    'LunarVim/bigfile.nvim',
  },

  -- 'vidocqh/auto-indent.nvim',
  {
    'vidocqh/auto-indent.nvim',
    event = { 'InsertEnter' },
    ops = {},
  },

  -- 'HakonHarnes/img-clip.nvim',
  {
    'HakonHarnes/img-clip.nvim',
    opts = {
      default = {
        file_name = '%Y-%m-%d_%H-%M-%S',
      },
    },
    keys = {
      { '<leader>v', '<cmd>PasteImage<cr>', desc = 'img-clip: Paste clipboard image' },
    },
  },

  -- 'kevinhwang91/nvim-ufo',
  {
    'kevinhwang91/nvim-ufo',
    cond = false,
    event = 'BufRead',
    keys = {
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'nvim-ufo: open all folds',
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'nvim-ufo: close all folds',
      },
      {
        'zr',
        function()
          require('ufo').openFoldsExceptKinds()
        end,
        desc = 'nvim-ufo: fold less',
      },
      {
        'zm',
        function()
          require('ufo').closeFoldsWith()
        end,
        desc = 'nvim-ufo: fold more',
      },
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        })
      end

      -- global handler
      -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
      -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
      require('ufo').setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      })

      -- buffer scope handler
      -- will override global handler if it is existed
      -- local bufnr = vim.api.nvim_get_current_buf()
      -- require('ufo').setFoldVirtTextHandler(bufnr, handler)
    end,
  },
  { 'kevinhwang91/promise-async',              lazy = true },
  -- if not use herline.nvim, enable statuscol.nvim
  {
    'luukvbaal/statuscol.nvim',
    event = 'BufRead',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
          {
            sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          { text = { '%s' },                  click = 'v:lua.ScSa' },
        },
      })
    end,
  },
}
