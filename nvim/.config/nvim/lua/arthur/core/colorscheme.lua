local status, catppuccin = pcall(require, "catppuccin")
if not status then
    print("catppuccin not found!")
    return
end
catppuccin.setup({
    flavour = "frappe"
  -- your configuration comes here
  -- or leave it empty to use the default settings
})

local status, _ = pcall(vim.cmd, "colorscheme catppuccin")
if not status then
    print("Colorscheme not found!")
    return
end
