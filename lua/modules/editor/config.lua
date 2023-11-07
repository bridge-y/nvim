local config = {}

function config.nvim_treesitter()
  vim.api.nvim_command('set foldmethod=expr')
  vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    ignore_install = { 'phpdoc' },
    highlight = {
      enable = true,
    },
    textobjects = {
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
  })
end

function config.nvim_lastplace()
  require('nvim-lastplace').setup({
    lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
    lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
    lastplace_open_folds = true,
  })
end

function config.dial()
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
end

function config.toggleterm()
  require('toggleterm').setup({
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
  })
end

return config
