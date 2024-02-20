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

function config.img_clip()
  return {
    default = {
      file_name = '%Y-%m-%d_%H-%M-%S',
    },
  }
end

function config.nvim_ufo()
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
end

return config
