local config = {}

function config.pyright()
  local settings = {
    settings = {
      python = {
        venvPath = '.',
        pythonPath = '.venv/bin/python',
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
        },
      },
    },
  }
  return settings
end

function config.pylsp()
  local settings = {
    settings = {
      pylsp = {
        plugins = {
          autopep8 = {
            enabled = 0,
          },
          black = {
            enabled = 1,
          },
          flake8 = {
            enabled = 1,
          },
          mccabe = {
            enabled = 0,
          },
          pycodestyle = {
            enabled = 0,
          },
          pyflakes = {
            enabled = 0,
          },
          pyls_isort = {
            enabled = 1,
          },
          isort = {
            enabled = 1,
          },
          flake8_isort = {
            enabled = 1,
          },
        },
      },
    },
  }

  return settings
end

function config.rust_analyzer()
  local settings = {
    settings = {
      ['rust-analyzer'] = {
        imports = {
          granularity = {
            group = 'module',
          },
          prefix = 'self',
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  }

  return settings
end

function config.tsserver()
  local settings = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  }

  return settings
end

function config.gopls()
  local settings = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  }

  return settings
end

function config.dls()
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    vim.api.nvim_err_writeln('[diagnosticls-configs] `nvim-lspconfig` plugin not installed!')
    vim.api.nvim_err_writeln('Please install via your plugin manager.')
    return
  end

  local settings = {
    root_dir = lspconfig.util.root_pattern('.git'),
    filetypes = { 'python' },
    init_options = {
      linters = {
        flake8 = {
          sourceName = 'flake8', -- if missing, do not display lint message
          -- pyproject-flake8
          command = 'pflake8',
          args = { [[--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s]], '-' },
          debounce = 100,
          offsetLine = 0,
          offsetColumn = 0,
          formatLines = 1,
          formatPattern = {
            [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
            { line = 1, column = 2, security = 3, message = { '[flake8] ', 4 } },
          },
          securities = {
            W = 'warning',
            E = 'error',
            F = 'error',
            C = 'error',
            N = 'error',
          },
        },
      },
      formatters = {
        black = {
          command = 'black',
          args = { '--quiet', '-', '--config', 'pyproject.toml' },
          rootPatterns = { 'pyproject.toml', '.git' },
        },
        isort = {
          command = 'isort',
          args = { '--quiet', '-' },
          rootPatterns = { 'pyproject.toml', '.git' },
        },
      },
      filetypes = {
        python = { 'flake8' },
      },
      formatFiletypes = {
        python = { 'black', 'isort' },
      },
    },
  }
  return settings
end

function config.ruff_lsp()
  local settings = {
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      },
    },
  }

  return settings
end

return config
