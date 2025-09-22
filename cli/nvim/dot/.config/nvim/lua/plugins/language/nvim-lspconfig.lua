return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- 补全引擎
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",

            -- 用于自动安装和管理 LSP 服务器
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- (可选) 改善 LSP 加载状态的 UI
            "j-hui/fidget.nvim",

            -- (可选) 其他有用的补全源
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },

        config = function()
            -- 1. 定义通用 on_attach 函数
            --    这个函数会在 LSP 客户端附加到缓冲区时执行
            --    是设置快捷键和每个缓冲区特定选项的最佳位置
            local on_attach = function(client, bufnr)
                -- 定义一个局部函数来简化快捷键设置
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        noremap = true,
                        silent = true,
                        buffer = bufnr,
                        desc = "LSP: " .. desc,
                    })
                end

                -- 跳转和引用
                map('n', 'gd', vim.lsp.buf.definition, "Go to Definition")
                map('n', 'gD', vim.lsp.buf.declaration, "Go to Declaration")
                map('n', 'gi', vim.lsp.buf.implementation, "Go to Implementation")
                map('n', 'gr', vim.lsp.buf.references, "Go to References")

                -- 悬浮提示
                map('n', 'K', vim.lsp.buf.hover, "Hover Documentation")
                map('n', '<C-k>', vim.lsp.buf.signature_help, "Signature Help")

                -- 代码操作
                map('n', '<leader>ca', vim.lsp.buf.code_action, "Code Action")
                map('n', '<leader>rn', vim.lsp.buf.rename, "Rename Symbol")

                -- 诊断 (错误和警告)
                map('n', '<leader>e', vim.diagnostic.open_float, "Show Line Diagnostics")
                map('n', '[d', vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
                map('n', ']d', vim.diagnostic.goto_next, "Go to Next Diagnostic")

                -- (可选) 如果客户端支持，格式化代码
                if client:supports_method("textDocument/formatting") then
                    map('n', '<leader>f', function()
                        vim.lsp.buf.format({ async = true })
                    end, "Format Code")
                end
            end

            -- 2. 设置诊断图标
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- 3. 配置 Mason，自动安装 LSP 服务器
            require('mason').setup()
            require('mason-lspconfig').setup({
                -- 在这里列出你希望 mason-lspconfig 自动为你安装的 LSP 服务器
                -- 例如: { "lua_ls", "pyright", "tsserver", "gopls", "clangd" }
                -- 留空则不会自动安装任何服务器
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "clangd",
                },
                -- 设为 true，当进入一个需要 LSP 的文件时，如果 LSP 没有安装，会自动开始安装
                automatic_installation = true,
            })

            -- 4. 配置 nvim-cmp 补全源
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- 5. 使用新的 vim.lsp.config API 设置已安装的 LSP 服务器
            local mason_lspconfig = require('mason-lspconfig')
            
            -- 获取所有已安装的服务器
            local installed_servers = mason_lspconfig.get_installed_servers()
            
            -- 定义常见服务器的配置
            local server_configs = {
                lua_ls = {
                    cmd = { "lua-language-server" },
                    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
                    settings = {
                        Lua = {
                            -- 让 LSP 知道 nvim 的全局变量，如 "vim"
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            workspace = {
                                -- 允许 LSP 扫描整个工作区，提供更好的项目范围补全
                                checkThirdParty = false,
                            },
                        },
                    },
                },
                pyright = {
                    cmd = { "pyright-langserver", "--stdio" },
                    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
                },
                tsserver = {
                    cmd = { "typescript-language-server", "--stdio" },
                    root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
                },
                clangd = {
                    cmd = { "clangd" },
                    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
                },
                gopls = {
                    cmd = { "gopls" },
                    root_markers = { "go.mod", "go.sum", ".git" },
                },
                rust_analyzer = {
                    cmd = { "rust-analyzer" },
                    root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
                },
            }
            
            -- 为每个已安装的服务器设置 LSP
            for _, server_name in ipairs(installed_servers) do
                local config = server_configs[server_name] or {
                    cmd = { server_name },
                    root_markers = { ".git" },
                }
                
                -- 使用新的 vim.lsp.config API
                vim.lsp.config(server_name, {
                    cmd = config.cmd,
                    root_markers = config.root_markers,
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = config.settings,
                })
            end
            
            -- (可选) 配置 fidget.nvim，提供美观的 LSP 状态显示
            require('fidget').setup({})
        end,
    },
}