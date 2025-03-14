" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" Show cursor position in the lower right corner of the screen
set ruler

" Show command as it's being entered in console.
set showcmd

" Use the system clipboard
set clipboard=unnamedplus

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
" Reset wrapscan to lead the search will not continue at the start in ending.
set incsearch
set wrapscan! 
set hlsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>


" =========== about tabs ===========
" ========== Tab 与空格基础设置 ==========
set tabstop=4       " 实际显示的 Tab 宽度为 4 列
set shiftwidth=4    " 自动缩进时使用的宽度为 4 列
set softtabstop=4   " 按 Tab 键时插入的「虚拟空格」数量为 4

" 默认将 Tab 转换为空格（适用于大多数文件类型）
set expandtab

" ========== 按文件类型禁用 expandtab（如 Makefile） ==========
autocmd FileType make setlocal noexpandtab  " Makefile 必须用真实 Tab

" ========== 可视化空白字符 ==========
set list                      " 启用特殊字符显示
set listchars=tab:▸\ ,        " Tab 显示为 ▸，后跟一个空格（确保对齐）
set listchars+=trail:·        " 行尾空格显示为 ·
set listchars+=space:·        " 行首空格（非缩进）显示为 ·
set listchars+=nbsp:␣         " 非换行空格显示为 ␣（可选）

" 高亮特殊空白字符的颜色（根据主题调整颜色值）
highlight SpecialKey ctermfg=DarkGray guifg=#666666

" 高亮行尾空格（不依赖 listchars）
highlight ExtraWhitespace ctermbg=cyan guibg=#FF0000
match ExtraWhitespace /\s\+$/ 
