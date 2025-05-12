-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

-- Better diagnostic symbols for Mononoki Nerd Font
local diagnostic_signs = { 
    Error = " ", -- More visible error icon
    Warn = " ",  -- Warning triangle
    Hint = " ",  -- Lightbulb for hints
    Info = " "   -- Information icon
}

-- Setup sign column icons
local function setup_diagnostic_signs()
    for type, icon in pairs(diagnostic_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

-- Format virtual text based on language
local function format_virtual_text(diagnostic)
    local message = diagnostic.message
    local source = diagnostic.source or ""
    local code = diagnostic.code or ""
    
    -- Extract the error identifier based on language
    if source:match("pyright") then
        -- For Python, show exception name or error type
        return code ~= "" and code or (message:match("^%w+Error:") or message:match("^%w+Warning:") or "")
    elseif source:match("rust") then
        -- For Rust, show error code
        return code ~= "" and code or message:match("E%d+") or ""
    else
        -- For other languages, keep it minimal
        return code ~= "" and code or ""
    end
end

-- Format float diagnostic prefix based on severity
local function format_float_prefix(diag)
    local level = vim.diagnostic.severity[diag.severity]
    local prefix = " "
    if level == "Error" then
        prefix = diagnostic_signs.Error
    elseif level == "Warn" then
        prefix = diagnostic_signs.Warn
    elseif level == "Info" then
        prefix = diagnostic_signs.Info
    elseif level == "Hint" then
        prefix = diagnostic_signs.Hint
    end
    return prefix, "Diagnostic" .. level
end

-- Format float diagnostic message
local function format_float_message(diag)
    -- Add extra spacing between diagnostics for readability
    return diag.message .. "\n"
end

-- Setup highlight links for underlines
local function setup_diagnostic_highlights()
    vim.cmd([[
        highlight! link DiagnosticUnderlineError DiagnosticVirtualTextError
        highlight! link DiagnosticUnderlineWarn DiagnosticVirtualTextWarn 
        highlight! link DiagnosticUnderlineInfo DiagnosticVirtualTextInfo
        highlight! link DiagnosticUnderlineHint DiagnosticVirtualTextHint
    ]])
end

-- Configure diagnostics appearance and behavior
local function setup_diagnostics()
    -- Setup signs first
    setup_diagnostic_signs()
    
    -- Setup highlight links
    setup_diagnostic_highlights()
    
    -- Configure diagnostic display
    vim.diagnostic.config({
        -- Minimal but informative virtual text
        virtual_text = {
            prefix = '●', -- Small dot as prefix
            format = format_virtual_text,
            spacing = 4,
            severity = {
                min = vim.diagnostic.severity.HINT
            }
        },
        
        -- Nice floating windows
        float = {
            border = "rounded",
            header = { "  Diagnostics", "DiagnosticHeader" },
            source = true,
            prefix = format_float_prefix,
            format = format_float_message,
            max_width = 100,
            max_height = 25,
        },
        
        -- Only underline specific problem locations
        underline = true,
        
        -- Show signs in the sign column
        signs = {
            active = diagnostic_signs,
        },
        
        -- Update diagnostics in insert mode (set to false to reduce distraction)
        update_in_insert = false,
        
        -- Sort diagnostics by severity
        severity_sort = true,
    })
end

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	
	-- Fixed keybindings for diagnostics
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor (primary)
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Initialize diagnostic configuration
setup_diagnostics()
		
-- configure language servers
lspconfig["dockerls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})

lspconfig["bacon_ls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    autostart = true,
    init_options = {
        updateOnSave = true,
        updateOnSaveWaitMillis = 1000,
        runBaconInBackground = true,
        runBaconInBackgroundCommandArguments = "--headless -j bacon-ls",
        synchronizeAllOpenFilesWaitMillis = 2000,
        locationsFile = ".bacon-locations"
    },
})

lspconfig["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
          -- Other Settings ...
          checkOnSave = {
            enable = false
          },
          diagnostics = {
            enable = false
          },
          procMacro = {
            ignored = {
                leptos_macro = {
                    -- optional: --
                    -- "component",
                    "server",
                },
            },
          },
        },
    }
})

lspconfig["taplo"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
