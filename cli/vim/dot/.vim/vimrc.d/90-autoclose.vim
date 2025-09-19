"-- AUTOCLOSE NATIVE CONFIG
function! CheckComment()
    let line = getline('.')
    let stripped_line = substitute(line, '^\s*', '', '')
    return stripped_line =~# '^"'
endfunction

function! CheckRightCharacter(char)
    if CheckComment()
        return a:char
    endif

    let l:line = getline('.')
    let l:col = col('.') - 1

    " check if at the end of the line
    if l:col >= len(l:line)
        let l:next_line = getline(line('.')+1)
        if len(l:next_line) > 0 && l:next_line[0] == a:char
            return "\<ESC>j0i\<Right>"
        endif
    endif

    return l:line[l:col] == a:char ? "\<Right>" : a:char
endfunction

" Basic autoclose with cursor inside
inoremap <expr> ' CheckComment() ? "'" : "''\<Left>"
inoremap <expr> ` CheckComment() ? "`" : "``\<Left>"
inoremap <expr> " CheckComment() ? "\"" : "\"\"\<Left>"
inoremap <expr> ( CheckComment() ? "(" : "()\<Left>"
inoremap <expr> [ CheckComment() ? "[" : "[]\<Left>"
inoremap <expr> { CheckComment() ? "{" : "{}\<Left>"

" Autoclose with ; and position cursor
inoremap <expr> '; CheckComment() ? ';' : "'';\<Left>\<Left>"
inoremap <expr> `; CheckComment() ? ';' : "``;\<Left>\<Left>"
inoremap <expr> "; CheckComment() ? ';' : "\"\"\<Left>\<Left>"
inoremap <expr> (; CheckComment() ? ';' : "();\<Left>\<Left>"
inoremap <expr> [; CheckComment() ? ';' : "[];\<Left>\<Left>"
inoremap <expr> {; CheckComment() ? ';' : "{};\<Left>\<Left>"

" Autoclose with , and position cursor
inoremap <expr> ', CheckComment() ? ',' : "'',\<Left>\<Left>"
inoremap <expr> `, CheckComment() ? ',' : "``,\<Left>\<Left>"
inoremap <expr> ", CheckComment() ? ',' : "\"\",\<Left>\<Left>"
inoremap <expr> (, CheckComment() ? ',' : "(),\<Left>\<Left>"
inoremap <expr> [, CheckComment() ? ',' : "[],\<Left>\<Left>"
inoremap <expr> {, CheckComment() ? ',' : "{},\<Left>\<Left>"

" Autoclose and position after
inoremap <expr> '<tab> CheckComment() ? "'\<Tab>" : "''"
inoremap <expr> `<tab> CheckComment() ? "`\<Tab>" : "``"
inoremap <expr> "<tab> CheckComment() ? "\"\<Tab>" : "\"\""
inoremap <expr> (<tab> CheckComment() ? "(\<Tab>" : "()"
inoremap <expr> [<tab> CheckComment() ? "[\<Tab>" : "[]"
inoremap <expr> {<tab> CheckComment() ? "{\<Tab>" : "{}"

" Autoclose with ; and position after
inoremap <expr> ';<tab> CheckComment() ? "';\<Tab>" : "'';"
inoremap <expr> `;<tab> CheckComment() ? "`;\<Tab>" : "``;"
inoremap <expr> ";<tab> CheckComment() ? "\";\<Tab>" : "\"\";"
inoremap <expr> (;<tab> CheckComment() ? "(;\<Tab>" : "();"
inoremap <expr> [;<tab> CheckComment() ? "[;\<Tab>" : "[];"
inoremap <expr> {;<tab> CheckComment() ? "{;\<Tab>" : "{};"

" Autoclose with , and position after
inoremap <expr> ',<tab> CheckComment() ? "',\<Tab>" : "'',"
inoremap <expr> `,<tab> CheckComment() ? "`,\<Tab>" : "``,"
inoremap <expr> ",<tab> CheckComment() ? "\",\<Tab>" : "\"\","
inoremap <expr> (,<tab> CheckComment() ? "(,\<Tab>" : "(),"
inoremap <expr> [,<tab> CheckComment() ? "[,\<Tab>" : "[],"
inoremap <expr> {,<tab> CheckComment() ? "{,\<Tab>" : "{},"

" Multiline autoclose
inoremap <expr> '<CR> CheckComment() ? "'\<CR>" : "'\<CR>'\<Esc>O"
inoremap <expr> `<CR> CheckComment() ? "`\<CR>" : "`\<CR>`\<Esc>O"
inoremap <expr> "<CR> CheckComment() ? "\"\<CR>" : "\"\<CR>\"\<Esc>O"
inoremap <expr> (<CR> CheckComment() ? "(\<CR>" : "(\<CR>)\<Esc>O"
inoremap <expr> [<CR> CheckComment() ? "[\<CR>" : "[\<CR>]\<Esc>O"
inoremap <expr> {<CR> CheckComment() ? "{\<CR>" : "{\<CR>}\<Esc>O"

" Multiline with ; suffix
inoremap <expr> ';<CR> CheckComment() ? "';\<CR>" : "'\<CR>';\<Esc>O"
inoremap <expr> `;<CR> CheckComment() ? "`;\<CR>" : "`\<CR>`;\<Esc>O"
inoremap <expr> ";<CR> CheckComment() ? "\";\<CR>" : "\"\<CR>\";\<Esc>O"
inoremap <expr> (;<CR> CheckComment() ? "(;\<CR>" : "(\<CR>);\<Esc>O"
inoremap <expr> [;<CR> CheckComment() ? "[;\<CR>" : "[\<CR>];\<Esc>O"
inoremap <expr> {;<CR> CheckComment() ? "{;\<CR>" : "{\<CR>};\<Esc>O"

" Multiline with , suffix
inoremap <expr> ',<CR> CheckComment() ? "',\<CR>" : "'\<CR>',\<Esc>O"
inoremap <expr> `,<CR> CheckComment() ? "`,\<CR>" : "`\<CR>`,\<Esc>O"
inoremap <expr> ",<CR> CheckComment() ? "\",\<CR>" : "\"\<CR>\",\<Esc>O"
inoremap <expr> (,<CR> CheckComment() ? "(,\<CR>" : "(\<CR>),\<Esc>O"
inoremap <expr> [,<CR> CheckComment() ? "[,\<CR>" : "[\<CR>],\<Esc>O"
inoremap <expr> {,<CR> CheckComment() ? "{,\<CR>" : "{\<CR>},\<Esc>O"

" Smart close mappings
inoremap <expr> )  CheckRightCharacter(')')
inoremap <expr> ]  CheckRightCharacter(']')
inoremap <expr> }  CheckRightCharacter('}')
inoremap <expr> '  CheckRightCharacter("'")
inoremap <expr> "  CheckRightCharacter('"')
inoremap <expr> `  CheckRightCharacter('`')
