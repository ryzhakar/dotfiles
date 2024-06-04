vim.cmd [[
  au VimEnter * lua OpenLazyTools()
]]

function OpenLazyTools()
  vim.cmd [[tabnew]]
  vim.cmd [[terminal lazygit]]
  vim.cmd [[file LazyGit]]
  vim.cmd [[tabnew]]
  vim.cmd [[terminal lazydocker]]
  vim.cmd [[file LazyDocker]]
  vim.cmd [[tabprev]]
  vim.cmd [[tabprev]]
end
