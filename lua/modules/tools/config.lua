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

return config
