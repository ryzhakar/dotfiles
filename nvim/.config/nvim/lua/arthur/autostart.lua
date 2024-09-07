vim.cmd [[
  au VimEnter * lua OpenLazyTools()
]]

function OpenLazyTools()
  vim.cmd [[tabnew]]
  vim.cmd [[terminal gitui]]
  vim.cmd [[file GitUI]]
  -- vim.cmd [[tabnew]]
  -- vim.cmd [[terminal lazydocker]]
  -- vim.cmd [[file LazyDocker]]
  -- vim.cmd [[tabprev]]
  vim.cmd [[tabprev]]
end
