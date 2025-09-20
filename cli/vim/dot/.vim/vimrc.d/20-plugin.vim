" This file is used to list all of the plugins that you'd like to install.
" use vim-plug to manage plugins

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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

" Themes
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }

" Beauti
Plug 'luochen1990/rainbow'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline' " Lean & mean status/tabline

" Project management
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file, buffer, mru, tag, etc finder
Plug 'preservim/nerdtree' " File system explorer;
Plug 'mhinz/vim-signify' " Visualize git diff

" Batter typing
Plug 'tpope/vim-commentary' " Comment stuff out
Plug 'tpope/vim-surround' " Surround text with quotes, parens, etc
Plug 'github/copilot.vim' " GitHub Copilot integration

" Analysis
Plug 'preservim/tagbar' " Displays tags in a window, ordered by class/function

" LSP
" For lightweight vim, disable this plugins
" Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense engine
" Plug 'sheerun/vim-polyglot' " Language packs
" Plug 'dense-analysis/ale' " Asynchronous Lint Engine

Plug 'junegunn/goyo.vim'

" Call plug#end to update &runtimepath and initialize the plugin system.
" - It automatically executes `filetype plugin indent on` and `syntax enable`
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
