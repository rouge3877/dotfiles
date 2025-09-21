return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'horizon',
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {'NvimTree', 'neo-tree'},
                },
                ignore_focus = {'NvimTree', 'neo-tree'},
                always_divide_middle = true,
                always_show_tabline = false,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                    refresh_time = 16, -- ~60fps
                    events = {
                        'WinEnter',
                        'BufEnter',
                        'BufWritePost',
                        'SessionLoadPost',
                        'FileChangedShellPost',
                        'VimResized',
                        'Filetype',
                        'CursorMoved',
                        'CursorMovedI',
                        'ModeChanged',
                    },
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {
                    {
                        'buffers',
                        show_filename_only = true,   -- Shows shortened relative path when set to false.
                        hide_filename_extension = false,   -- Hide filename extension when set to true.
                        show_modified_status = true, -- Shows indicator when the buffer is modified.

                        mode = 2, -- 0: Shows buffer name
                                    -- 1: Shows buffer index
                                    -- 2: Shows buffer name + buffer index
                                    -- 3: Shows buffer number
                                    -- 4: Shows buffer name + buffer number

                        max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                                            -- it can also be a function that returns
                                                            -- the value of `max_length` dynamically.
                        filetype_names = {
                            TelescopePrompt = 'Telescope',
                            dashboard = 'Dashboard',
                            packer = 'Packer',
                            fzf = 'FZF',
                            alpha = 'Alpha'
                        }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                        -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                        use_mode_colors = false,

                        buffers_color = {
                            -- Same values as the general color option can be used here.
                            active = 'lualine_a_normal',     -- Color for active buffer.
                            inactive = 'lualine_a_inactive', -- Color for inactive buffer.
                        },

                        symbols = {
                            modified = ' ●',      -- Text to show when the buffer is modified
                            alternate_file = '#', -- Text to show to identify the alternate file
                            directory =  '',     -- Text to show when the buffer is a directory
                        },
                    }
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_a = {'tabs'},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {'windows'}
            },
            winbar = {
                lualine_a = {'location', 'filename'},
                lualine_b = {'progress'},
                lualine_c = {},
                lualine_x = {'encoding', 'fileformat'},
                lualine_y = {},
                lualine_z = {'lsp_status', 'filetype'}
            },
            inactive_winbar = {
                lualine_a = {'location', 'filename'},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {'lsp_status', 'filetype'}
            },
            extensions = {'quickfix', 'nvim-tree'}
            }
        end,
    },
}