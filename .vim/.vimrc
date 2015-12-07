"""""""""""""""""""""""""""""""""
" peter.chen
"""""""""""""""""""""""""""""""""

" => General Options "{{{ 
set colorcolumn=80
set linespace=2

" Session 
set sessionoptions-=curdir
set sessionoptions+=sesdir

" 高亮当前行
set cursorline
set nocursorcolumn

" 使用非兼容模式
set nocompatible  

" 有关搜索的选项
set hls
set incsearch   
"set ic smartcase 

" 输入的命令显示出来
set showcmd

" 历史记录行数
set history=200

" 当文件在外部被修改时，自动读取
set autoread 

" 一直启动鼠标
set mouse=a

" 设置mapleader
let mapleader = ";"
let g:mapleader = ";"

" 快速重载配置文件
map <leader>s :source ~/.vimrc<cr> 
map <leader>e :e! ~/.vimrc<cr>

" 当.vimrc被修改时，重载之
autocmd! bufwritepost vimrc source ~/.vimrc 

" 自动跳转到上一次打开的位置
autocmd BufReadPost *
			\ if line("'\"") > 0 && line ("'\"") <= line("$") |
			\ exe "normal! g'\"" |
			\ endif 


"}}} 
" => Colors and Fonts "{{{ 
set t_Co=256
" 设置vim的本色方案
set background=dark
colorscheme solarized
"colorscheme desert

" 语法高亮
syntax on

" 字体
set guifont=Droid\ Sans\ Mono:h12
"set gfn=Vera\ Sans\ YuanTi\ Mono:h10
"set gfn=Droid\ Sans\ Fallback:h10
set antialias

" GUI
if has("gui_running")
	set guioptions-=T
	let psc_style='cool'
endif 

" 折叠相关
set foldmethod=marker
"}}}

" => other UI options"{{{
" Tab缩进
set smarttab
set tabstop=4 
set expandtab 

" 自动缩进 
set smartindent 
set shiftwidth=4
set autoindent 
set cindent 

" 显示行号
set number 

" 显示光标位置 
set ruler 

" wild菜单 
set wildmenu 

" 上下移动时，留3行
set so=3

" set backspace
set backspace=eol,start,indent

" Backspace and cursor keys wrap to
set whichwrap+=<,>,h,l

" set magic on 
set magic 

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

" 括号匹配
set showmatch 

" How many tenths of a second to blink
set mat=2

" 状态栏
set laststatus=2
function! CurDir()
	let curdir = substitute(getcwd(), '/home/peter', "~/", "g")
	return curdir
endfunction
set statusline=\ %f%m%r%h\ %w\ %<CWD:\ %{CurDir()}\ %=Pos:\ %l/%L:%c\ %p%%\ 


" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" 命令窗口大小
set cmdheight=1
"}}}

" => Files "{{{
" 文件编码 
set fileencoding=utf-8
set fileencodings=utf-8,gb18030,latin1

" 文件类型
set ffs=unix,dos
nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

" 不备份文件
set nobackup
set nowritebackup
"}}}

" => Plugin "{{{
"
" https://github.com/VundleVim/Vundle.vim
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'https://github.com/scrooloose/nerdtree.git'
Plugin 'bufexplorer.zip'
Plugin 'taglist.vim'
Plugin 'cscope.vim'
Plugin 'https://github.com/ervandew/supertab.git'
Plugin 'https://github.com/Shougo/neocomplete.vim.git'
Plugin 'echofunc.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

" for taglist
nmap <F10> :TlistToggle <CR> 
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1 
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
set tags=./tags;/

" NERDTreeToggle
nmap <F9> :NERDTreeToggle <CR> 

" SuperTab 
" scroll down the list
let g:SuperTabDefaultCompletionType = "<c-n>"

" Cscope
" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>

function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        exe "cs add " . db . " " . path
        set cscopeverbose
    endif
endfunction
au BufEnter /* call LoadCscope()

" neocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}
