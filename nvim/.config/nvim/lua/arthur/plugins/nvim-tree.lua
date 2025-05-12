local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
    return
end

-- recommended settings from nvim-documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]]) -- Note: You have indent_markers disabled below, this might not have an effect.

nvimtree.setup({
    -- Tweak renderer settings if needed
    renderer = {
        add_trailing = false,
        group_empty = false, -- Set to true to enable grouping empty folders
        highlight_git = true, -- Enable git highlighting
        full_name = false,
        highlight_opened_files = "none",
        root_folder_modifier = ":~", -- Show '~' for root folder in home directory
        indent_markers = {
            enable = true, -- Set to true if you want indent markers
            -- Consider using Nerd Font glyphs for indent markers too
            icons = {
                corner = "└ ", -- nf-fae-corner / Alternative: "╰ " Unicode
                edge   = "│ ", -- nf-fae-vertical_line / Alternative: "│ " Unicode
                item   = "│ ", -- nf-fae-vertical_line / Alternative: "│ " Unicode
                none   = "  ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ", -- Unicode arrow for symlinks
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",        -- nf-fa-file_text_o / Alternative:  nf-fa-file_o
                symlink = "",        -- nf-fa-link
                folder = {
                    arrow_closed = "▶", -- nf-fa-caret_right / Alternative: 
                    arrow_open = "▼",   -- nf-fa-caret_down / Alternative: 
                    default = "",      -- nf-fa-folder
                    open = "",        -- nf-fa-folder_open
                    empty = "",       -- nf-fa-folder_o (empty closed)
                    empty_open = "",  -- nf-fa-folder_open_o (empty open)
                    symlink = "",      -- nf-oct-file_symlink_directory
                    symlink_open = "", -- Use same icon for open symlink folder
                },
                git = {
                    -- Using Nerd Font Icons for consistency:
                    unstaged  = "", -- nf-oct-diff_modified / Your original: "✗"
                    staged    = "", -- nf-oct-diff_added / Your original: "✓"
                    unmerged  = "", -- nf-dev-git_merge (or  nf-oct-issue_opened)
                    renamed   = "", -- nf-oct-diff_renamed / Your original: "➜"
                    untracked = "", -- nf-fa-question_circle_o / Your original: "★"
                    deleted   = "", -- nf-oct-diff_removed
                    ignored   = "", -- nf-oct-git_commit (or  nf-oct-circle_slash) / Your original: "◌"
                },
            },
        },
    },
    -- disable window_picker for explorer to work well with window splits
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    -- Other nvim-tree options can go here
    -- e.g., view = { width = 30 }
})
