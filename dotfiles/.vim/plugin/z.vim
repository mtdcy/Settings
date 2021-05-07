""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Copyright 2018 (c) Chen Fang
"
" Redistribution and use in source and binary forms, with or without
" modification, are permized provided that the following conditions are met:
"
" 1. Redistributions of source code must retain the above copyright notice, this
" list of conditions and the following disclaimer.
"
" 2. Redistributions in binary form must reproduce the above copyright notice,
" this list of conditions and the following disclaimer in the documentation
" and/or other materials provided with the distribution.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" simple IDE setup by Chen Fang

" ==> notes {{{

" requirements 
" 1. neocomplete
" 2. omni
" 3. jedi
" vimrc load before plugins 

" }}}

" ==> options {{{
if exists("g:simple_ide_setup")
    finish
endif

let g:simple_ide_setup = 1
let s:select_first = 1
let b:completion = ''

let g:tags_interested_types = '\.\(asm\|c\|cpp\|cc\|h\|java\|py\|sh\|vim\)$'
let s:tags_files = ".files"
let s:ctags_db = ".ctags"
let s:cscope_db = ".cscope"
let s:tags_ctags_cmd = "ctags --fields=+ailS --c-kinds=+p --c++-kinds=+p --sort=no --extra=+q -L " . s:tags_files . " -f " . s:ctags_db 
let s:tags_cscope_cmd = "cscope -bq -i " . s:tags_files . " -f " . s:cscope_db
" <== END }}}

" ==> Functions for tags management {{{
function! z#find_project_root()
    if exists('b:project_root')     " cache
        "echo "cached b:project_root: [" . b:project_root . "]"
        return b:project_root
    endif

    exe "lcd " . expand("%:p:h")
    let tags = findfile(s:tags_files, ".;")
    if (empty(tags))
        let b:project_root = ''
    else
        let b:project_root = fnamemodify(tags, ":p:h")
    endif
    "echo "b:project_root: [" . b:project_root . "]"
    lcd -
    return b:project_root
endfunction

" load tags and cscope db
function! z#tags_load()
    if expand("%:p") =~? g:tags_interested_types 
        let root = z#find_project_root()
        if (empty(root))
            return
        else
            exe "lcd " . root
            if (filereadable(s:ctags_db))                     " load ctags db
                exe "set tags=" . root . "/" . s:ctags_db
            endif
            if (filereadable(s:cscope_db))                    " load cscope db
                set nocscopeverbose
                exe "cs add " . root . "/" . s:cscope_db . " " . root
                set cscopeverbose
            endif
            lcd -
        endif
    endif
endfunction

" create tags and cscope db
function! z#tags_create()
    let root = input("project root: ", expand("%:p:h"))         " project root
    exe "lcd " . root
    let files = glob("**", v:false, v:true)
    call filter(files, 'filereadable(v:val)')                   " filter out directory
    call filter(files, 'v:val =~? g:tags_interested_types')     " only interested files
    call writefile(files, root . "/" . s:tags_files)            " save list
    exe "silent !" . s:tags_ctags_cmd
    exe "silent !" . s:tags_cscope_cmd
    lcd -
    call z#tags_load()
endfunction

" update tags and cscope db if loaded
function! z#tags_update()
    let root = z#find_project_root()
    if (empty(root))
        return
    endif

    exe "lcd " . root
    let file = fnamemodify(expand("%:p"), ":.")                 " path related to project root
    if file =~? g:tags_interested_types 
        let files = readfile(s:tags_files)
        if match(files, file) < 0
            files+=file
            call writefile(files, s:tags_files)
        endif

        if (filewritable(s:ctags_db))                           " update ctags
            exe "silent !" . s:tags_ctags_cmd
            " no need to reload
        endif
        if (filewritable(s:cscope_db))                          " update cscope db and reload
            exe "silent !" . s:tags_cscope_cmd
            exe "silent cs reset"
        endif
    endif
    lcd -
endfunction

function! z#gettext_before_cursor()
    if col('.') > 1
        return strpart(getline('.'), 0, col('.') - 1)
    else
        return ''
    endif 
endfunction

" autocomplete 
" :h ins-completion 
" python    - jedi
" c/cpp     - omnicppcomplete
" *         - neocomplete
function! z#select_first()
    if exists('s:select_first') && s:select_first == 1
        if has("patch-8.2.1066") && b:completion == "neocomplete"
            "return "\<C-N>\<C-N>"
            return "\<C-N>"
        else
            return "\<C-N>"
        endif
    else
        return ""
    endif
endfunction

function! z#supertab()
    if pumvisible()
        " next candidate on pop list
        return "\<C-N>"
    else
        let word = z#gettext_before_cursor()
        if word =~? '\s\+$' || word =~? '^$'                    " spcaces or empty line
            return "\<TAB>"                                     " insert tab
        elseif b:completion == 'omnicpp'
            if !empty(&omnifunc) && (word =~? '\(\.\|->\|:\)$')
                return "\<C-X>\<C-O>" . z#select_first()        " using omni complete, by tags
            else
                return "\<C-N>" . z#select_first()              " :h i_CTRL-N
            endif
        elseif b:completion == 'neocomplete'
            " because of vim's issue, this may not working 
            " hzps://github.com/Shougo/neocomplete.vim/issues/334
            let s = neocomplete#complete_common_string()
            if empty(s)
                return neocomplete#start_manual_complete() . z#select_first()
            else 
                return s . z#select_first()
            endif
        elseif &omnifunc != ''
            return "\<C-X>\<C-O>" . z#select_first()            " using omni complete directly
        endif
    endif
    return "\<TAB>"
endfunction

function! z#superbs() 
    if pumvisible()                                             " undo & close popup
        if b:completion == 'neocomplete'
            return neocomplete#undo_completion()
        endif
        return "\<C-E>"
    endif
    return "\<BS>"
endfunction

function! z#superenter() 
    if pumvisible()
        return "\<C-Y>"
    else
        return "\<Enter>"
endfunction

function! z#setup_cpp_plugins()
    " omni cpp
    let g:OmniCpp_DefaultNamespaces = ['std']
    let g:OmniCpp_MayCompleteScope = 1
    call omni#cpp#settings#Init()
    " omni#cpp#complete#Main has weakness, only complete from tags
    setlocal omnifunc=omni#cpp#complete#Main

    let b:completion = 'omnicpp'
endfunction

function! z#setup_python_plugins()
    " jedi
    setlocal omnifunc=jedi#completions
    let g:jedi#show_call_signatures = 2
    call jedi#configure_call_signatures()
    nnoremap <silent> <buffer> <S-K> :call jedi#show_documentation()<CR>    " show doc
    " TODO: jump to assignment for variable, and definition for function/class
    nnoremap <silent> <buffer> <leader>l :call jedi#goto()<CR>              " goto
    " other sezings
    command! -nargs=0 -bar JediDebugInfo call jedi#debug_info()

    let b:completion = 'jedi'
endfunction

function! z#setup_neocomplete()
    " neocomplete 
    call neocomplete#commands#_unlock()
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_smart_case = 0
    let g:neocomplete#enable_debug = 0
    let g:neocomplete#disable_auto_complete = 1
    let g:neocomplete#auto_complete_delay = 200
    call neocomplete#initialize()
    "inoremap <silent> <buffer> <expr><C-L> neocomplete#complete_common_string()
    "inoremap <silent> <buffer> <expr><C-U> neocomplete#undo_completion()
    if !exists('g:neocomplete#keyword_pazerns')
        let g:neocomplete#keyword_pazerns = {}
    endif
    let g:neocomplete#keyword_pazerns['default'] = '\h\w*'

    let b:completion = 'neocomplete'
endfunction 

" setup plugins for file
function! z#setup_completion()
    " this options set should work in global
    " set completopt and preview window on the bottom
    set completeopt=menuone,longest,preview,popup
    set splitbelow
    " :h 'complete'
    set complete=.,w,b,u,t,i,d,k,s

    call neocomplete#commands#_lock()
    if &ft ==? 'python'
        call z#setup_python_plugins()
    elseif &ft ==? 'c' || &ft ==? 'cpp'
        call z#setup_cpp_plugins()
    elseif has("lua")
        call z#setup_neocomplete()
    endif
endfunction

" <== END }}}

" ==> Configurations {{{
augroup tagsmngr
    au!
    " load tags on BufEnter
    au BufReadPost * silent call z#tags_load()
    " update tags on :w
    au BufWritePost * silent call z#tags_update()
    " omni complete for c,cpp
    au FileType * call z#setup_completion()
augroup END

" supertab
inoremap <silent> <expr><TAB>   z#supertab()
inoremap <silent> <expr><BS>    z#superbs()
inoremap <silent> <expr><Enter> z#superenter()
nnoremap <silent> <TAB>         :bn<CR>             " next buffer
nnoremap <silent> <S-TAB>       :bp<CR>             " previous buffer

" set cscope key map
"set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-                          " ???
nnoremap <leader>j :cstag <C-R>=expand("<cword>")<CR><CR>           " junp with cscope tag
nnoremap <leader>fa :cs find a <C-R>=expand("<cword>")<CR><CR>      " a: find assignment to this symbol
nnoremap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>      " s: find this symbol
nnoremap <leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>      " g: find this definition
nnoremap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>      " c: find functions calling this function
nnoremap <leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>      " d: find functions called by this function
nnoremap <leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>      " f: find this file

" <== END }}}

" ==> Commands {{{
command! -nargs=0 -bar InitTags call z#tags_create()

" <== END }}}
