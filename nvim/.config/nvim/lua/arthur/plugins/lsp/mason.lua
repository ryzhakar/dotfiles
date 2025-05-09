-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
    return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
    return
end

-- enable mason
mason.setup({
    ensure_installed = {
        "bacon",
        "bacon-ls",
    },
})

-- Configure mason-lspconfig - specify automatic_enable as false
mason_lspconfig.setup({
    -- list of servers for mason to install
    ensure_installed = {
        "dockerls",
        "pyright",
        "rust_analyzer",
        "taplo",
        -- "yamlls",
    },
    -- This is the key change:
    automatic_enable = false,
})
