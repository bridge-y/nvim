-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
local cache_dir = vim.env.HOME .. "/.cache/nvim/"

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.termguicolors = true
opt.hidden = true
opt.magic = true
opt.virtualedit = "block"
opt.clipboard = "unnamedplus"
opt.wildignorecase = true
opt.swapfile = false
opt.backup = false
opt.directory = cache_dir .. "swap/"
opt.undodir = cache_dir .. "undo/"
opt.backupdir = cache_dir .. "backup/"
opt.viewdir = cache_dir .. "view/"
opt.spellfile = cache_dir .. "spell/en.uft-8.add"
opt.history = 2000
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true

if vim.fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

opt.completeopt = "menu,menuone,noselect"
opt.showmode = false
opt.shortmess = "aoOTIcF"
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.ruler = false
opt.showtabline = 0
opt.winwidth = 30
opt.pumheight = 15
opt.showcmd = false

opt.cmdheight = 0
opt.laststatus = 3
opt.list = true
opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true

opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2

-- wrap
opt.linebreak = true
opt.whichwrap = "h,l,<,>,[,],~"
opt.breakindentopt = "shift:2,min:20"
opt.showbreak = "↳ "

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = "1"
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "marker"

opt.number = true
opt.signcolumn = "yes"
opt.spelloptions = "camel"

opt.helplang = "ja"
opt.spelllang = "en,cjk"

-- opt.textwidth = 100
-- opt.colorcolumn = '100'
if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
  vim.g.python_host_prog = "/usr/bin/python"
  vim.g.python3_host_prog = "/usr/local/bin/python3"
end
