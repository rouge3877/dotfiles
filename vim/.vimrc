"------------- User-defined Options -------------

" Automatically reload vimrc on save
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" Basic Settings
set nocompatible
set mouse=a
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8

" Interface Configurations
set nu                         " Show line numbers
set cursorline                 " Highlight the current line
set showmatch                  " Show matching brackets
set nowrap                     " Disable line wrapping
set listchars=tab:»■,trail:■   " Set special character display
set list                       " Enable list characters

" Indentation Settings
set autoindent                 " Enable auto-indentation
set smartindent                " Smart indentation for C-like programs
set cindent                    " C-style indentation
set expandtab                  " Convert tabs to spaces
set tabstop=4                  " Tab width = 4 spaces
set softtabstop=4              " Soft tab width = 4 spaces
set shiftwidth=4               " Shift width = 4 spaces
set backspace=indent,eol,start " Allow backspace in insert mode

" Status & Completion Settings
set laststatus=2               " Always show status line
set completeopt=menu,preview,longest
set cmdheight=1
set scrolloff=2
set showcmd
set wildmenu
set wildmode=longest:list,full

" Clipboard & Paste Settings
set clipboard=unnamed          " Use system clipboard

" Syntax & Highlighting
syntax on
set t_Co=256                   " Enable 256 colors
set background=dark
highlight Function cterm=bold,underline ctermbg=red ctermfg=green

" Enable filetype plugins and indentation
filetype plugin on
filetype indent on

" NERDTree Settings
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
let g:NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1

" Auto-start NERDTree when opening directories
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Key Bindings for NERDTree
map <F2> :NERDTreeToggle<CR>
map <C-n> :NERDTree<CR>
map <C-t> :tabnew<CR>

map <C-`> :bel ter<CR>
" Auto-read files changed outside of vim
set autoread

set foldenable " 开始折叠
set foldmethod=syntax " 设置语法折叠
set foldcolumn=0 " 设置折叠区域的宽度
setlocal foldlevel=1 " 设置折叠层数为 1
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " 用空格键来开关折叠

"------------- Plugin Settings -------------

call plug#begin('~/.vim/plugged')

" Plugins
Plug 'chrisbra/vim-diff-enhanced'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

call plug#end()

" Airline Configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='violet'

"------------- Search Highlighting -------------

set incsearch      " Incremental search
set ignorecase     " Ignore case in search
set smartcase      " Case-sensitive if uppercase is used

highlight Search ctermbg=yellow ctermfg=black
highlight IncSearch ctermbg=black ctermfg=yellow
highlight MatchParen cterm=underline ctermbg=NONE ctermfg=NONE

" Custom key bindings for search highlighting
noremap n :set hlsearch<cr>n
noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?


" Disable highlighting with <Ctrl-h>
nnoremap <C-h> :call DisableHighlight()<cr>
function! DisableHighlight()
    set nohlsearch
endfunction

