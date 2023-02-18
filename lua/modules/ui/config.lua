local config = {}

-- function config.zephyr()
--   vim.cmd('colorscheme zephyr')
-- end

function config.kanagawa()
  vim.cmd('colorscheme kanagawa')
end

function config.barbecue()
  require('barbecue').setup({
    theme = {
      -- this highlight is used to override other highlights
      -- you can take advantage of its `bg` and set a background throughout your winbar
      -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
      normal = { fg = '#c0caf5' },

      -- these highlights correspond to symbols table from config
      ellipsis = { fg = '#737aa2' },
      separator = { fg = '#737aa2' },
      modified = { fg = '#737aa2' },

      -- these highlights represent the _text_ of three main parts of barbecue
      dirname = { fg = '#737aa2' },
      basename = { bold = true },
      context = {},

      -- these highlights are used for context/navic icons
      context_file = { fg = '#ac8fe4' },
      context_module = { fg = '#ac8fe4' },
      context_namespace = { fg = '#ac8fe4' },
      context_package = { fg = '#ac8fe4' },
      context_class = { fg = '#ac8fe4' },
      context_method = { fg = '#ac8fe4' },
      context_property = { fg = '#ac8fe4' },
      context_field = { fg = '#ac8fe4' },
      context_constructor = { fg = '#ac8fe4' },
      context_enum = { fg = '#ac8fe4' },
      context_interface = { fg = '#ac8fe4' },
      context_function = { fg = '#ac8fe4' },
      context_variable = { fg = '#ac8fe4' },
      context_constant = { fg = '#ac8fe4' },
      context_string = { fg = '#ac8fe4' },
      context_number = { fg = '#ac8fe4' },
      context_boolean = { fg = '#ac8fe4' },
      context_array = { fg = '#ac8fe4' },
      context_object = { fg = '#ac8fe4' },
      context_key = { fg = '#ac8fe4' },
      context_null = { fg = '#ac8fe4' },
      context_enum_member = { fg = '#ac8fe4' },
      context_struct = { fg = '#ac8fe4' },
      context_event = { fg = '#ac8fe4' },
      context_operator = { fg = '#ac8fe4' },
      context_type_parameter = { fg = '#ac8fe4' },
    },
  })
end

function config.vim_illuminate()
  require('illuminate').configure()
end

function config.indent_blankline()
  -- vim.opt.list = true  -- already set in core module
  -- vim.opt.listchars:append "eol:↴"

  require('indent_blankline').setup({
    show_end_of_line = true,
    filetype_exclude = {
      'dashboad',
      'fugitive',
      'gitcommit',
      'markdown',
      'json',
      'txt',
      'help',
      'NvimTree',
      'git',
      'TelescopePrompt',
      '', -- for all buffers without a file type
    },
    buftype_exclude = { 'terminal', 'nofile' },
    show_trailing_blankline_indent = false,
    show_current_context = true,
  })
end

function config.dashboard()
  local db = require('dashboard')
  db.setup({
    theme = 'hyper',
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        { desc = ' Update', group = '@property', action = 'Lazy update', key = 'u' },
        {
          desc = ' Find Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' Projects',
          group = 'DiagnosticHint',
          action = 'Telescope projects',
          key = 'p',
        },
        {
          desc = ' File Browser',
          group = 'Number',
          action = 'Telescope file_browser',
          key = 'b',
        },
      },
    },
  })
end

function config.nvim_bufferline()
  require('bufferline').setup({
    options = {
      modified_icon = '✥',
      buffer_close_icon = '',
      always_show_bufferline = false,
    },
  })
end

function config.nvim_tree()
  require('nvim-tree').setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
  })
end

function config.noice()
  require('noice').setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = {
        -- to use lspsaga
        enabled = false,
        view = nil, -- when nil, use defaults from documentation
        -- ---@type NoiceViewOptions
        opts = {}, -- merged with defaults from documentation
      },
      signature = {
        -- to use lspsaga
        enabled = false,
        auto_open = {
          enabled = true,
          trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 50, -- Debounce lsp signature help request by 50ms
        },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      {
        view = 'split',
        filter = { event = 'msg_show', min_height = 20 },
      },
      {
        filter = {
          event = 'notify',
          min_height = 8,
        },
        view = 'split',
      },
    },
  })
end

function config.lualine()
  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  local function python_venv()
    local function env_cleanup(venv)
      if string.find(venv, '/') then
        local final_venv = venv
        for w in venv:gmatch('([^/]+)') do
          final_venv = w
        end
        venv = final_venv
      end
      return venv
    end

    if vim.bo.filetype == 'python' then
      local venv = os.getenv('CONDA_DEFAULT_ENV')
      if venv then
        return string.format('%s', env_cleanup(venv))
      end
      venv = os.getenv('VIRTUAL_ENV')
      if venv then
        return string.format('%s', env_cleanup(venv))
      end
    end
    return ''
  end

  local function lsp_client(msg)
    msg = msg or ''
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })

    if next(buf_clients) == nil then
      if type(msg) == 'boolean' or #msg == 0 then
        return ''
      end
      return msg
    end

    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then
        table.insert(buf_client_names, client.name)
      end
    end

    -- add formatter
    local lsp_utils = require('modules.completion.utils')
    local formatters = lsp_utils.list_formatters(buf_ft)
    vim.list_extend(buf_client_names, formatters)

    -- add linter
    local linters = lsp_utils.list_linters(buf_ft)
    vim.list_extend(buf_client_names, linters)

    -- add hover
    local hovers = lsp_utils.list_hovers(buf_ft)
    vim.list_extend(buf_client_names, hovers)

    -- add code action
    local code_actions = lsp_utils.list_code_actions(buf_ft)
    vim.list_extend(buf_client_names, code_actions)

    local hash = {}
    local client_names = {}
    for _, v in ipairs(buf_client_names) do
      if not hash[v] then
        client_names[#client_names + 1] = v
        hash[v] = true
      end
    end
    table.sort(client_names)
    return '' .. ' ' .. table.concat(client_names, ', ') .. ' ' .. ''
  end

  require('lualine').setup({
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        { 'diff', source = diff_source },
        {
          'diagnostics',
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
          },
        },
      },
      lualine_c = {
        'filename',
        {
          lsp_client,
          colored = true,
          on_click = function()
            vim.cmd([[LspInfo]])
          end,
        },
      },
      lualine_x = {
        {
          require('noice').api.statusline.mode.get,
          cond = require('noice').api.statusline.mode.has,
          color = { fg = '#ff9e64' },
        },
        { 'filetype', colored = true, icon_only = true },
        { python_venv },
        { 'encoding' },
        {
          'fileformat',
          icons_enabled = true,
        },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extentions = {
      'fugitive',
      'nvim-tree',
      'toggleterm',
    },
  })
end

function config.gitsigns()
  require('gitsigns').setup({
    current_line_blame = true,
    current_line_blame_opts = { delay = 1000, virt_text_pos = 'eol' },
    diff_opts = { internal = true },
    on_attach = function(bufnr)
      local ga = require('gitsigns.actions')
      local keymap = require('core.keymap')
      local nmap, vmap, omap, xmap = keymap.nmap, keymap.vmap, keymap.omap, keymap.xmap
      local cmd = require('core.keymap').cmd

      --   nmap(
      --     )
      nmap({
        {
          ']g',
          function()
            if vim.wo.diff then
              return ']g'
            end
            vim.schedule(function()
              require('gitsigns.actions').next_hunk()
            end)
            return '<Ignore>'
          end,
          { buffer = bufnr, expr = true, desc = 'git: Goto next hunk' },
        },
        {
          '[g',
          function()
            if vim.wo.diff then
              return '[g'
            end
            vim.schedule(function()
              ga.prev_hunk()
            end)
            return '<Ignore>'
          end,
          { buffer = bufnr, expr = true, desc = 'git: Goto prev hunk' },
        },
        { '<leader>hs', cmd('Gitsigns stage_hunk'), { buffer = bufnr, desc = 'git: Stage hunk' } },
        { '<leader>hr', cmd('Gitsigns reset_hunk'), { buffer = bufnr, desc = 'git: Reset hunk' } },
        { '<leader>hu', ga.undo_stage_hunk, { buffer = bufnr, desc = 'git: Undo stage hunk' } },
        { '<leader>hR', ga.reset_buffer, { buffer = bufnr, desc = 'git: Reset buffer' } },
        { '<leader>hp', ga.preview_hunk, { buffer = bufnr, desc = 'git: Preview hunk' } },
        {
          '<leader>hb',
          function()
            ga.blame_line({ full = true })
          end,
          { buffer = bufnr, desc = 'git: Preview hunk' },
        },
        { '<leader>hd', ga.diffthis, { buffer = bufnr, desc = 'git: Diff this' } },
      })
      vmap({
        { '<leader>hs', cmd('Gitsigns stage_hunk'), { buffer = bufnr, desc = 'git: Stage hunk' } },
        { '<leader>hr', cmd('Gitsigns reset_hunk'), { buffer = bufnr, desc = 'git: Reset hunk' } },
      })
      -- Text object
      omap({
        { 'ih', cmd('<C-U>Gitsigns select_hunk') },
      })
      xmap({
        { 'ih', cmd('<C-U>Gitsigns select_hunk') },
      })
    end,
  })
end

function config.diffview()
  require('diffview').setup()
end

return config
