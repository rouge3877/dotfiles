" This is rouge's vimrc file.

" ==== 0. Check if env DOTFILES_VIM is set ====
if empty($DOTFILES_VIM)
  let $DOTFILES_VIM = expand("~/dotfiles/vim")
endif

" ==== 1. Load basic.vim ====
source $DOTFILES_VIM/basic.vim
source $DOTFILES_VIM/autoclose.vim

" ==== 2. Load plugins ====
source $DOTFILES_VIM/plugin.vim
source $DOTFILES_VIM/plugin-conf.vim

" temp for solving SpecialKey Color problem
" the main problem is that the color of SpecialKey is modified by theme
highlight SpecialKey guifg=Darkgray ctermfg=Darkgray
highlight ExtraWhitespace ctermbg=gray guibg=gray
