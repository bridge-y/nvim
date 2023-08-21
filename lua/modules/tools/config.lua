local config = {}

function config.telescope()
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
end

function config.project()
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
end

function config.dressing()
  require('dressing').setup({
    input = {
      enabled = true,
    },
    select = {
      enabled = true,
      backend = 'telescope',
      trim_prompt = true,
    },
  })
end

function config.legendary()
  require('legendary').setup({
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
  })
end

function config.trouble()
  require('trouble').setup({})
end

function config.which_key()
  require('which-key').setup({
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
    window = {
      border = 'none',
      position = 'bottom',
      margin = { 1, 0, 1, 0 },
      padding = { 1, 1, 1, 1 },
      winblend = 0,
    },
  })
end

function config.telekasten()
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
end

return config
