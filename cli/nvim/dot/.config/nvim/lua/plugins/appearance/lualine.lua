return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'moonfly',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
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
                lualine_c = {'buffers'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'lsp_status'},
                lualine_z = {'progress', 'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'buffers'},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },

            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'buffers'},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {}
            }

        end,
    },
}