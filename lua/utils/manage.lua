# ref: https://github.com/pgosar/CyberNvim/blob/main/lua/core/utils/utils.lua

local M = {}

-- updates all Mason packages
M.update_mason = function()
  local registry = require('mason-registry')
  registry.refresh()
  registry.update()
  local packages = registry.get_all_packages()
  for _, pkg in ipairs(packages) do
    if pkg:is_installed() then
      pkg:install()
    end
  end
end

-- updates everything in CyberNvim
M.update_all = function()
  -- vim.notify('Pulling latest changes...')
  -- vim.fn.jobstart({ 'git', 'pull', '--rebase' })
  require('lazy').sync({ wait = true })
  vim.notify('Updating Mason packages...')
  M.update_mason()
  -- make sure treesitter is loaded so it can update parsers
  require('nvim-treesitter')
  vim.cmd('TSUpdate')
  vim.notify('Nvim plugins updated!', 'info')
end

return M

