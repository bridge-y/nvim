return {
  -- nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    -- event = "BufReadPost",
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = 'all',
      ignore_install = { 'phpdoc' },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
      -- vim-matchup
      matchup = {
        enable = true,
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },
  { 'nvim-treesitter/nvim-treesitter-context', lazy = true },
  { 'andymass/vim-matchup', lazy = true },

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
      { '<C-a>', '<Plug>(dial-increment)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: increment' },
      { '<C-x>', '<Plug>(dial-decrement)', noremap = true, mode = { 'n', 'v' }, desc = 'dial.nvim: decrement' },
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
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }),
          augend.constant.new({
            elements = { '&&', '||' },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { 'True', 'False' },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }), -- Python's bool
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
      shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
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
    ops = {
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
  { 'kevinhwang91/promise-async', lazy = true },
  -- if not use herline.nvim, enable statuscol.nvim
  {
    'luukvbaal/statuscol.nvim',
    lazy = true,
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          {
            sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          { text = { '%s' }, click = 'v:lua.ScSa' },
        },
      })
    end,
  },
}
