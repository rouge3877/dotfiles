" This is the configuration file for the plugin.

" Before load each part of the plugin's configuration, we will check if the
" plugin is loaded.
" The plugin managed by vim-plug

"============== vim-signify =============
set updatetime=250


"============== ctrlP =============
let g:ctrlp_regexp = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Exclude files and directories using Vim's wildignore and CtrlP's
" own g:ctrlp_custom_ignore.
" If a custom listing command is being used, exclusions are ignored
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


"============== NERDTree =============
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\.pyc$', '\~$']
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeShowGitStatus = 1

"============== papercolor =============
" Set the colorscheme to papercolor
set background=dark
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1,
  \       'allow_bold': 1,
  \       'allow_italic': 1
  \     }
  \   }
  \ }

"============== air-line ============
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


"============== Tagbar =============
nmap <F8> :TagbarToggle<CR>

