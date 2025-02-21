return {
  -- 'nvim-telescope/telescope.nvim',
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = function()
      local actions = require('telescope.actions')
      local fb_actions = require('telescope').extensions.file_browser.actions

      require('telescope').setup({
        defaults = {
          layout_config = {
            horizontal = { prompt_position = 'top', results_width = 0.6 },
            vertical = { mirror = false },
          },
          sorting_strategy = 'ascending',
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        extensions = {
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },
          file_browser = {
            theme = 'dropdown',
            hijack_netrw = true,
            mappings = {
              ['n'] = {
                ['h'] = fb_actions.goto_parent_dir,
                ['l'] = actions.select_default,
              },
            },
          },
          undo = {
            side_by_side = true,
            mappings = { -- this whole table is the default
              i = {
                -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
                -- you want to use the following actions. This means installing as a dependency of
                -- telescope in it's `requirements` and loading this extension from there instead of
                -- having the separate plugin definition as outlined above. See issue #6.
                ['<cr>'] = require('telescope-undo.actions').yank_additions,
                ['<S-cr>'] = require('telescope-undo.actions').yank_deletions,
                ['<C-cr>'] = require('telescope-undo.actions').restore,
              },
            },
          },
        },
      })
      require('telescope').load_extension('fzy_native')
      require('telescope').load_extension('file_browser')
      require('telescope').load_extension('projects')
      require('telescope').load_extension('undo')
      require('telescope').load_extension('noice')
      require('telescope').load_extension('media_files')
      require('telescope').load_extension('egrepify')
    end,
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-telescope/telescope-fzy-native.nvim', lazy = true },
  { 'nvim-telescope/telescope-file-browser.nvim', lazy = true },
  {
    'ahmedkhalf/project.nvim',
    event = 'BufReadPost',
    config = function()
      require('project_nvim').setup({
        manual_mode = false,
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
        ignore_lsp = { 'efm', 'copilot', 'diagonosticls' },
        exclude_dirs = { '~/.cargo/*' },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath('data'),
      })
    end,
  },
  { 'debugloop/telescope-undo.nvim', lazy = true },
  { 'nvim-telescope/telescope-media-files.nvim', lazy = true },
  { 'fdschmidt93/telescope-egrepify.nvim', lazy = true },

  -- 'glepnir/hlsearch.nvim',
  {
    'glepnir/hlsearch.nvim',
    event = 'BufRead',
    opts = {},
  },

  -- 'ziontee113/icon-picker.nvim',
  {
    'ziontee113/icon-picker.nvim',
    cmd = { 'IconPickerInsert', 'IconPickerYank', 'IconPickerNormal' },
    opts = {
      disable_legacy_commands = true,
    },
  },

  -- 'dstein64/vim-startuptime',
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  },

  -- 'tpope/vim-fugitive',
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
  },

  -- 'folke/trouble.nvim',
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle', 'TroubleRefresh' },
  },

  -- 'mrjones2014/legendary.nvim',
  {
    'mrjones2014/legendary.nvim',
    cmd = 'Legendary',
    opts = {
      which_key = {
        auto_register = true,
        do_binding = false,
      },
      scratchpad = {
        view = 'float',
        results_view = 'float',
        keep_contents = true,
      },
      sort = {
        -- sort most recently used item to the top
        most_recent_first = true,
        -- sort user-defined items before built-in items
        user_items_first = true,
        frecency = {
          -- the directory to store the database in
          db_root = string.format('%s/legendary/', vim.fn.stdpath('data')),
          -- the maximum number of timestamps for a single item
          -- to store in the database
          max_timestamps = 10,
        },
      },
      -- Directory used for caches
      cache_path = string.format('%s/legendary/', vim.fn.stdpath('cache')),
      -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
      log_level = 'info',
    },
  },
  { 'kkharji/sqlite.lua', lazy = true },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      input = {
        enabled = true,
      },
      select = {
        enabled = true,
        backend = 'telescope',
        trim_prompt = true,
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = {
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = true,
        },
      },
      win = {
        border = 'none',
        title_pos = 'bottom',
        padding = { 1, 1, 1, 1 },
        wo = {
          winblend = 0,
        },
      },
    },
  },

  -- 'renerocksai/telekasten.nvim',
  {
    'renerocksai/telekasten.nvim',
    cmd = 'Telekasten',
    config = function()
      local home = vim.fn.expand('~/zettelkasten')
      -- NOTE for Windows users:
      -- - don't use Windows
      -- - try WSL2 on Windows and pretend you're on Linux
      -- - if you **must** use Windows, use "/Users/myname/zettelkasten" instead of "~/zettelkasten"
      -- - NEVER use "C:\Users\myname" style paths
      require('telekasten').setup({
        -- path to main notes folder
        home = home .. '/' .. 'notes',

        -- if true, telekasten will be enabled when opening a note within the configured home
        take_over_my_home = true,

        -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
        --                               and thus the telekasten syntax will not be loaded either
        auto_set_filetype = true,

        -- dir names for special notes (absolute path or subdir name)
        dailies = home .. '/' .. 'daily',
        weeklies = home .. '/' .. 'weekly',
        templates = home .. '/' .. 'templates',

        -- image (sub)dir for pasting
        -- dir name (absolute path or subdir name)
        -- or nil if pasted images shouldn't go into a special subdir
        image_subdir = home .. '/' .. 'img',

        -- markdown file extension
        extension = '.md',

        -- following a link to a non-existing note will create it
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,

        -- template for new notes (new_note, follow_link)
        -- set to `nil` or do not specify if you do not want a template
        template_new_note = home .. '/' .. 'templates/new_note.md',

        -- template for newly created daily notes (goto_today)
        -- set to `nil` or do not specify if you do not want a template
        template_new_daily = home .. '/' .. 'templates/daily.md',

        -- template for newly created weekly notes (goto_thisweek)
        -- set to `nil` or do not specify if you do not want a template
        template_new_weekly = home .. '/' .. 'templates/weekly.md',

        -- image link style
        -- wiki:     ![[image name]]
        -- markdown: ![](image_subdir/xxxxx.png)
        image_link_style = 'markdown',

        -- integrate with calendar-vim
        plug_into_calendar = false,
        calendar_opts = {
          -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
          weeknm = 4,
          -- use monday as first day of week: 1 .. true, 0 .. false
          calendar_monday = 1,
          -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
          calendar_mark = 'left-fit',
        },

        -- telescope actions behavior
        close_after_yanking = false,
        insert_after_inserting = true,

        -- tag notation: '#tag', ':tag:', 'yaml-bare'
        tag_notation = '#tag',

        -- command palette theme: dropdown (window) or ivy (bottom panel)
        command_palette_theme = 'ivy',

        -- tag list theme:
        -- get_cursor: small tag list at cursor; ivy and dropdown like above
        show_tags_theme = 'ivy',

        -- when linking to a note in subdir/, create a [[subdir/title]] link
        -- instead of a [[title only]] link
        subdirs_in_links = true,

        -- template_handling
        -- What to do when creating a new note via `new_note()` or `follow_link()`
        -- to a non-existing note
        -- - prefer_new_note: use `new_note` template
        -- - smart: if day or week is detected in title, use daily / weekly templates (default)
        -- - always_ask: always ask before creating a note
        template_handling = 'smart',

        -- path handling:
        --   this applies to:
        --     - new_note()
        --     - new_templated_note()
        --     - follow_link() to non-existing note
        --
        --   it does NOT apply to:
        --     - goto_today()
        --     - goto_thisweek()
        --
        --   Valid options:
        --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
        --              all other ones in home, except for notes/with/subdirs/in/title.
        --              (default)
        --
        --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
        --                    except for notes with subdirs/in/title.
        --
        --     - same_as_current: put all new notes in the dir of the current note if
        --                        present or else in home
        --                        except for notes/with/subdirs/in/title.
        new_note_location = 'smart',

        -- should all links be updated when a file is renamed
        rename_update_links = true,
      })
    end,
  },

  -- 'keaising/im-select.nvim',
  {
    'keaising/im-select.nvim',
    event = { 'InsertEnter' },
    opts = {},
  },

  -- 'pwntester/octo.nvim',
  {
    'pwntester/octo.nvim',
    cmd = { 'Octo' },
    config = function()
      require('octo').setup()
      vim.treesitter.language.register('markdown', 'octo')
    end,
  },

  -- 'stevearc/overseer.nvim',
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle' },
    opts = {},
  },

  -- 'subnut/nvim-ghost.nvim',
  {
    'subnut/nvim-ghost.nvim',
    cmd = 'GhostTextStart',
  },

  -- 'kdheepak/lazygit.nvim',
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
  },

  -- '3rd/image.nvim',
  {
    '3rd/image.nvim',
    opts = {},
  },

  -- 'yetone/avante.nvim',
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    -- lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = function(_, opt)
      -- avante config
      opt.provider = 'gemini'
      opt.auto_suggestions_provider = 'gemini'
      opt.behaviour = {
        auto_apply_diff_after_generation = true,
      }
      opt.vendors = {
        ollama = {
          __inherited_from = 'openai',
          api_key_name = '',
          disable_tools = true,
          -- TODO: replace ip address and model name
          endpoint = 'http://192.0.2.1:11434/v1',
          model = 'phi4',
        },
      }
      opt.gemini = {
        model = 'gemini-2.0-flash',
      }

      -- keymap for avante
      -- https://github.com/yetone/avante.nvim/wiki/Recipe-and-Tricks
      -- https://namileriblog.com/mac/neovim_avante/

      -- prefil edit window with common scenarios to avoid repeating query and submit immediately
      local prefill_edit_window = function(request)
        require('avante.api').edit()
        local code_bufnr = vim.api.nvim_get_current_buf()
        local code_winid = vim.api.nvim_get_current_win()
        if code_bufnr == nil or code_winid == nil then
          return
        end
        vim.api.nvim_buf_set_lines(code_bufnr, 0, -1, false, { request })
        -- Optionally set the cursor position to the end of the input
        vim.api.nvim_win_set_cursor(code_winid, { 1, #request + 1 })
        -- Simulate Ctrl+S keypress to submit
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-s>', true, true, true), 'v', true)
      end

      -- NOTE: most templates are inspired from ChatGPT.nvim -> chatgpt-actions.json
      local avante_code_readability_analysis = [[
  以下の点を考慮しコードの可読性の問題を特定してください。
  考慮すべき可読性の問題:
  - 不明瞭な命名
  - 不明瞭な目的
  - 冗長なコメント
  - コメントの欠如
  - 長いまたは複雑な一行のコード
  - ネストが多すぎる
  - 長すぎる変数名
  - 命名とコードスタイルの不一致
  - コードの繰り返し
  上記以外の問題を特定しても構いません。
]]
      local avante_optimize_code = '次のコードを最適化してください。'
      local avante_fix_bugs = '次のコード内のバグを修正してください。'
      local avante_add_tests = '次のコードのテストを実装してください。'
      local avante_add_docstring = '次のコードにdocstringを追加してください。'
      local avante_grammar_correction = 'Correct the text to standard English, but keep any code blocks inside intact.'

      local avante_ask = require('avante.api').ask
      local keymap = require('utils.keymap')
      local nmap, vmap = keymap.nmap, keymap.vmap
      local silent, noremap = keymap.silent, keymap.noremap
      local opts = keymap.new_opts

      nmap({
        {
          '<leader>al',
          function()
            avante_ask({ question = avante_code_readability_analysis })
          end,
          opts(noremap, silent, 'Avante: Code Readability Analysis(ask)'),
        },
        {
          '<leader>aL',
          function()
            prefill_edit_window(avante_code_readability_analysis)
          end,
          opts(noremap, silent, 'Avante: Code Readability Analysis(edit)'),
        },
        {
          '<leader>ao',
          function()
            avante_ask({ question = avante_optimize_code })
          end,
          opts(noremap, silent, 'Avante: Optimize Code(ask)'),
        },
        {
          '<leader>aO',
          function()
            prefill_edit_window(avante_optimize_code)
          end,
          opts(noremap, silent, 'Avante: Optimize Code(edit)'),
        },
        {
          '<leader>ab',
          function()
            avante_ask({ question = avante_fix_bugs })
          end,
          opts(noremap, silent, 'Avante: Fix Bugs(ask)'),
        },
        {
          '<leader>aB',
          function()
            prefill_edit_window(avante_fix_bugs)
          end,
          opts(noremap, silent, 'Avante: Fix Bugs(edit)'),
        },
        {
          '<leader>au',
          function()
            avante_ask({ question = avante_add_tests })
          end,
          opts(noremap, silent, 'Avante: Add Tests(ask)'),
        },
        {
          '<leader>aU',
          function()
            prefill_edit_window(avante_add_tests)
          end,
          opts(noremap, silent, 'Avante: Add Tests(edit)'),
        },
        {
          '<leader>ad',
          function()
            avante_ask({ question = avante_add_docstring })
          end,
          opts(noremap, silent, 'Avante: Docstring(ask)'),
        },
        {
          '<leader>aD',
          function()
            prefill_edit_window(avante_add_docstring)
          end,
          opts(noremap, silent, 'Avante: Docstring(edit)'),
        },
        {
          '<leader>ag',
          function()
            require('avante.api').ask({ question = avante_grammar_correction })
          end,
          opts(noremap, silent, 'Avante: Grammar Correction(ask)'),
        },
        {
          '<leader>ag',
          function()
            prefill_edit_window(avante_grammar_correction)
          end,
          opts(noremap, silent, 'Avante: Grammar Correction(edit)'),
        },
      })

      vmap({
        {
          '<leader>al',
          function()
            avante_ask({ question = avante_code_readability_analysis })
          end,
          opts(noremap, silent, 'Avante: Code Readability Analysis(ask)'),
        },
        {
          '<leader>aL',
          function()
            prefill_edit_window(avante_code_readability_analysis)
          end,
          opts(noremap, silent, 'Avante: Code Readability Analysis(edit)'),
        },
        {
          '<leader>ao',
          function()
            avante_ask({ question = avante_optimize_code })
          end,
          opts(noremap, silent, 'Avante: Optimize Code(ask)'),
        },
        {
          '<leader>aO',
          function()
            prefill_edit_window(avante_optimize_code)
          end,
          opts(noremap, silent, 'Avante: Optimize Code(edit)'),
        },
        {
          '<leader>ab',
          function()
            avante_ask({ question = avante_fix_bugs })
          end,
          opts(noremap, silent, 'Avante: Fix Bugs(ask)'),
        },
        {
          '<leader>aB',
          function()
            prefill_edit_window(avante_fix_bugs)
          end,
          opts(noremap, silent, 'Avante: Fix Bugs(edit)'),
        },
        {
          '<leader>au',
          function()
            avante_ask({ question = avante_add_tests })
          end,
          opts(noremap, silent, 'Avante: Add Tests(ask)'),
        },
        {
          '<leader>aU',
          function()
            prefill_edit_window(avante_add_tests)
          end,
          opts(noremap, silent, 'Avante: Add Tests(edit)'),
        },
        {
          '<leader>ad',
          function()
            avante_ask({ question = avante_add_docstring })
          end,
          opts(noremap, silent, 'Avante: Docstring(ask)'),
        },
        {
          '<leader>aD',
          function()
            prefill_edit_window(avante_add_docstring)
          end,
          opts(noremap, silent, 'Avante: Docstring(edit)'),
        },
        {
          '<leader>ag',
          function()
            require('avante.api').ask({ question = avante_grammar_correction })
          end,
          opts(noremap, silent, 'Avante: Grammar Correction(ask)'),
        },
        {
          '<leader>ag',
          function()
            prefill_edit_window(avante_grammar_correction)
          end,
          opts(noremap, silent, 'Avante: Grammar Correction(edit)'),
        },
      })
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    -- I wanted to use markview.nvim, but since it didn't work properly, I'm using this plugin instead.
    opts = {
      -- file_types = { 'markdown', 'Avante' },
      file_types = { 'Avante' },
    },
    -- ft = { 'markdown', 'Avante' },
    ft = { 'Avante' },
  },
}
