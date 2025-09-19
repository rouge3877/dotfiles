"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM configuration file
" Author: Rouge Lin
" This is a part of my dotfiles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty($DOTFILES_VIM)
  let s:config_path = expand('~/.vim/vimrc.d')
else
  let s:config_path = $DOTFILES_VIM . '/.vim/vimrc.d'
endif

" Use glob() to get all .vim files in the directory
for s:file in glob(s:config_path . '/*.vim', 1, 1)
    " Use execute to run the source command
    execute 'source' s:file
endfor


" temp for solving SpecialKey Color problem
" the main problem is that the color of SpecialKey is modified by theme
highlight SpecialKey guifg=Darkgray ctermfg=Darkgray
highlight ExtraWhitespace ctermbg=gray guibg=gray

" End of .vimrc