" This file is used to list all of the plugins that you'd like to install.
" use vim-plug to manage plugins

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
"
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file, buffer, mru, tag, etc finder
Plug 'preservim/nerdtree' " File system explorer;
Plug 'github/copilot.vim' " GitHub Copilot integration
Plug 'tpope/vim-commentary' " Comment stuff out
Plug 'tpope/vim-surround' " Surround text with quotes, parens, etc
Plug 'mhinz/vim-signify'


Plug 'preservim/tagbar' " Displays tags in a window, ordered by class/function

" Themes and colorschemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline' " Lean & mean status/tabline


" Call plug#end to update &runtimepath and initialize the plugin system.
" - It automatically executes `filetype plugin indent on` and `syntax enable`
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" Color schemes should be loaded after plug#end().
" We prepend it with 'silent!' to ignore errors when it's not yet installed.
silent! colorscheme seoul256

" default updatetime 4000ms is not good for async update
set updatetime=100

