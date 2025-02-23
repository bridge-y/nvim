return {
  -- tiny-devicons-auto-colors and kanagawa
  {
    'rachartier/tiny-devicons-auto-colors.nvim',
    event = 'VeryLazy',
    config = function()
      local colors = require('kanagawa.colors').setup()
      local pallets = colors.palette
      require('tiny-devicons-auto-colors').setup({
        colors = pallets,
      })
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    event = 'VimEnter',
    config = function()
      require('kanagawa').load('wave')
    end,
  },

  -- catppuccin
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      integrations = {
        alpha = true,
        barbecue = true,
        cmp = true,
        dashboard = true,
        diffview = true,
        gitsigns = true,
        hop = true,
        illuminate = true,
        lspsaga = true,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = true,
        semantic_tokens = true,
        telekasten = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,
      },
    },
  },

  -- berbecue
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    -- event = { "FocusLost", "CursorHold" },
    event = 'BufReadPost',
    opts = {
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
    },
  },
  { 'SmiteshP/nvim-navic', lazy = true },

  -- vim-illuminate
  {
    'RRethy/vim-illuminate',
    event = 'BufReadPost',
    config = function()
      require('illuminate').configure()
    end,
  },

  -- hlchunk
  {
    'shellRaining/hlchunk.nvim',
    event = { 'UIEnter' },
    opts = {
      indent = {
        chars = { '│', '¦', '┆', '┊' }, -- more code can be found in https://unicodeplus.com/
      },
      blank = {
        enable = false,
      },
    },
  },

  -- dashboard-nvim
  {
    'nvimdev/dashboard-nvim',
    event = 'BufWinEnter',
    opts = {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          {
            desc = ' Find Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' New File',
            group = 'Label',
            action = 'vim.api.nvim_command("enew")',
            key = 'n',
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
          { desc = ' Update', group = '@property', action = 'Lazy update', key = 'u' },
        },
      },
    },
  },

  -- nvim-tree
  {
    'nvim-tree/nvim-tree.lua',
    cmd = {
      'NvimTreeToggle',
      'NvimTreeOpen',
      'NvimTreeFindFile',
      'NvimTreeFindFileToggle',
      'NvimTreeRefresh',
    },
    opts = {
      disable_netrw = false,
      hijack_cursor = true,
      hijack_netrw = true,
      filters = {
        custom = {
          '.git',
          'venv',
          '.venv',
          'node_modules',
          '__pycache__',
        },
      },
    },
  },

  -- neo-tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['h'] = {
            function(state)
              local node = state.tree:get_node()
              if node.type == 'directory' and node:is_expanded() then
                require('neo-tree.sources.filesystem').toggle_directory(state, node)
              else
                require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
              end
            end,
            desc = 'Move left or close directory',
          },
          ['l'] = {
            function(state)
              local node = state.tree:get_node()
              if node.type == 'directory' then
                if not node:is_expanded() then
                  require('neo-tree.sources.filesystem').toggle_directory(state, node)
                elseif node:has_children() then
                  require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
                end
              end
            end,
            desc = 'Move right or open directory',
          },
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = { 'toggle_preview', config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
    },
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },
  {
    's1n7ax/nvim-window-picker',
    lazy = true,
    version = '2.*',
    config = function()
      require('window-picker').setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      })
    end,
  },

  -- bufferline.nvim
  {
    'akinsho/bufferline.nvim',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    opts = {
      options = {
        modified_icon = '✥',
        buffer_close_icon = '',
        always_show_bufferline = false,
        diagnostics = 'nvim_lsp',
      },
    },
  },

  -- noice.nvim
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
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
          filter = {
            event = 'notify',
            kind = 'info',
            find = 'keymap must has rhs',
          },
          opts = { skip = true },
        },
      },
    },
    -- ref: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
    -- stylua: ignore
    keys = {
      { "<leader>sn",  "",                                                                            desc = "+noice" },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
  },
  -- 'rcarriga/nvim-notify',  -- if disabled, always use mini view

  -- 'nvim-lualine/lualine.nvim',
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
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
        local lsp_utils = require('plugins.completion.utils')
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

      -- avante-status
      local avante_chat_component = require('avante-status.lualine').chat_component
      local avante_suggestions_component = require('avante-status.lualine').suggestions_component

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
            avante_chat_component,
            avante_suggestions_component,
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
    end,
  },

  -- gitsigns.nvim
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 1000, virt_text_pos = 'eol' },
      diff_opts = { internal = true },
      on_attach = function(bufnr)
        local ga = require('gitsigns.actions')
        -- local keymap = require('core.keymap')
        local keymap = require('utils.keymap')
        local nmap, vmap, omap, xmap = keymap.nmap, keymap.vmap, keymap.omap, keymap.xmap
        local cmd = keymap.cmd

        --   nmap
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
    },
  },

  -- diffview.nvim
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
    opts = {},
  },
}
