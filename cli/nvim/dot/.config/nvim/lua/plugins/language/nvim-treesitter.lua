return {
    
    {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master', -- 警告：master 分支已冻结，未来会切换到 main
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        -- 安装哪些语言的解析器。推荐只写你需要的，或保持为空，后续手动安装。
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false, -- 同步安装解析器，会阻塞 Neovim 启动

        -- Automatically install missing parsers when entering buffer
        -- 是否在打开一个新文件时，自动安装对应语言的解析器
        auto_install = true,

        -- List of parsers to ignore installing
        -- 忽略安装的解析器列表
        ignore_install = { "javascript" },

        -- 核心模块：高亮
        highlight = {
            enable = true, -- 启用高亮模块

            -- 为某些大型文件禁用 treesitter 高亮，以保证性能
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            -- 强制运行 vim 传统的语法高亮。
            -- 如果你依赖某些基于传统语法的插件（比如缩进），可以设为 true
            additional_vim_regex_highlighting = false,
        },

        -- 核心模块：缩进
        indent = {
            enable = true,
        },

        -- 核心模块：增量选择
        incremental_selection = {
            enable = true,
            keymaps = {
            init_selection = "gnn", -- 开始增量选择
            node_incremental = "grn", -- 扩大选择范围
            scope_incremental = "grc", -- 按范围扩大选择
            node_decremental = "grm", -- 减小选择范围
            },
        },
        }
        
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.opt.foldenable = false -- 可以在打开文件时不自动折叠

    end,
    },

}
