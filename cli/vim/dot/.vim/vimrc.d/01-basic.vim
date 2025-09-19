" This is the basic configuration file for Vim.
" It will be sourced anytime you run Vim.

"================= Basic Basic Configuration =================
set nocompatible
set noerrorbells visualbell t_vb=
set shortmess+=I " Disable the default Vim startup message.
nmap Q <Nop> " Q in normal mode enters Ex mode. You almost never want this.

syntax on " Turn on syntax highlighting.
set fileformat=unix " Set the default file format to Unix
set encoding=UTF-8 " Set the default encoding to UTF-8, just in case


"================= Clipboard =================
" Use the system clipboard
" set clipboard=unnamedplus

" 设置剪贴板命令为 wl-clipboard
if executable('wl-copy') && executable('wl-paste')
  let g:clipboard = {
    \ 'name': 'wl-clipboard',
    \ 'copy': {
      \ '+': 'wl-copy --foreground --type text/plain',
      \ '*': 'wl-copy --foreground --primary --type text/plain',
    \ },
    \ 'paste': {
      \ '+': 'wl-paste --no-newline',
      \ '*': 'wl-paste --no-newline --primary',
    \ },
    \ 'cache_enabled': 0
  \ }
endif

vnoremap <C-c> y:call system("wl-copy", @")<CR>

"================= Line and Line Number =================
" Show line numbers (relative + absolute).
" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
set number
set relativenumber
set nowrap " Don't wrap lines
set cursorline " Highlight the current line
set cursorcolumn " Highlight the current column
set signcolumn=yes " Always show the sign column, otherwise it would shift the text each time.
set scrolloff=8 " Always show x lines above/below the cursor


"================= Status Line and under =================
" Set the status line to always show the filename
set statusline=%F
" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
" Show cursor position in the lower right corner of the screen
set ruler
" Show command as it's being entered in console.
set showcmd


"================= Backspace =================
" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start


"================= Search =================
" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
" Reset wrapscan to lead the search will not continue at the start in ending.
set incsearch
set wrapscan! " Search will not continue at the start in ending.
set hlsearch
nnoremap <silent> <CR> :noh<CR><CR>

"================= Indentation and Space =================
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |

" Set the tab size to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent
set smartindent
set smarttab
set expandtab " Use spaces instead of tabs

" Visualize tabs and trailing spaces
set list
set listchars=tab:▸\ ,
set listchars+=trail:·        " 行尾空格显示为 ·
set listchars+=space:·        " 行首空格（非缩进）显示为 ·
set listchars+=nbsp:␣         " 非换行空格显示为 ␣（可选）
set listchars+=extends:»      " 可视块的行尾显示为 »
set listchars+=precedes:«     " 可视块的行首显示为 «

" 高亮特殊空白字符的颜色（根据主题调整颜色值）
highlight SpecialKey ctermfg=DarkGray guifg=#666666

" 高亮行尾空格（不依赖 listchars）
highlight ExtraWhitespace ctermbg=cyan guibg=#FF0000
match ExtraWhitespace /\s\+$/ 

"================= Mapping =================
" Set the arrow keys to scroll left, right, up, down
" Do this in normal mode...
nnoremap <Down> <C-e>
nnoremap <Up> <C-y>
nnoremap <Left> <z><h>
nnoremap <Right> <z><l>

" " ...and in insert mode
inoremap <Down> <C-e>
inoremap <Up> <C-y>
inoremap <Left> <ESC><z><h>
inoremap <Right> <ESC><z><l>


"================= Buffer =================
" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

"================= Backup =================
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
