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
let g:NERDTreeIgnore = ['\.pyc$', '\~$', '\.swp$', '\.git$', '\.hg$', '\.svn$']
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeShowGitStatus = 1
let g:NERDTreeFileLines = 1

nnoremap <leader>n :NERDTreeFocus<CR> "leader default is '\'
nnoremap <C-n> :NERDTreeToggle<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

"============== theme =============
set background=dark
" Set the colorscheme to papercolor
" We prepend it with 'silent!' to ignore errors when it's not yet installed.
colorscheme moonfly

let g:moonflyCursorColor = v:true
let g:moonflyNormalFloat = v:true
let g:moonflyUnderlineMatchParen = v:true
let g:moonflyVirtualTextColor = v:true

let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 0,
  \       'allow_bold': 1,
  \       'allow_italic': 1
  \     }
  \   }
  \ }

"============== air-line and theme =============
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme = 'moonfly'


"============== Tagbar =============
nmap <F8> :TagbarToggle<CR>

"============== rainbow =============
let g:rainbow_active = 1
let g:rainbow_conf = {
\    'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\    'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\    'operators': '_,_',
\    'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\    'separately': {
\        '*': {},
\        'tex': {
\            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\        },
\        'lisp': {
\            'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\        },
\        'vim': {
\            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\        },
\        'html': {
\            'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\        },
\        'css': 0,
\        'nerdtree': 0,
\    }
\}

"============= Copilot =============
" Copilot settings, about keymap, etc.
imap <silent><script><expr> <C-C> copilot#Accept("\<CR>")
imap <C-L> <Plug>(copilot-accept-word)
imap <C-J> <Plug>(copilot-next)
imap <C-K> <Plug>(copilot-previous)
let g:copilot_no_tab_map = v:true

"============= COC =============
" Use <Tab> and <S-Tab> to navigate through popup menu
" in the other word, use <C-Tab > and <C-S-Tab> to navigate through popup menu

inoremap <expr> <C-Tab> coc#pum#visible() ? "\<C-n>" : "\<C-Tab>"
inoremap <expr> <C-S-Tab> coc#pum#visible() ? "\<C-p>" : "\<C-S-Tab>"
inoremap <expr> <C-Space> coc#refresh()


