" This is rouge's vimrc file.

" ==== 0. Check if env DOTFILES_VIM is set ====
if empty($DOTFILES_VIM)
  let $DOTFILES_VIM = expand("~/dotfiles/vim")
endif

" ==== 1. Load basic.vim ====
source $DOTFILES_VIM/basic.vim
source $DOTFILES_VIM/autoclose.vim
source $DOTFILES_VIM/status-line.vim

" ==== 2. Load plugins ====
source $DOTFILES_VIM/plugin.vim

" ==== 3. Load color ====
set background=dark
colorscheme PaperColor
