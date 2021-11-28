set nocompatible "关闭与vi兼容模式
filetype on
filetype plugin on " 允许加载文件类型插件
set number
set relativenumber "设置所在光标行的相对行号
set wrap"自动换行
set linebreak
syntax on
set showmatch
set scrolloff=3 "距顶部和底部3行
set mouse=
filetype on "检测文件类型
set ambiwidth=double "设置为双字宽显示，否则有些符号无法完整显示如：☆
set clipboard+=unnamed "共享剪贴板
set cursorline "高亮显示当前行
set termguicolors
set t_Co=256
colorscheme molokai

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab  "将Tab自动转化成空格
set autoindent  "自动与上一行缩进保持一致
set smartindent 
set ruler "显示当前行号列号
set showcmd "在状态栏显示正在输入的命令



map <F5> :call RunPython()<CR>
func! RunPython()
	exec "w"
	if &filetype=='python'
		exec "!time python3.9 %"
	endif
endfunc

"vim-plug配置
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'neoclide/coc.nvim'
Plug 'luochen1990/rainbow'
Plug 'mhinz/vim-startify'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' "airline 的主题
Plug 'Yggdroot/indentLine' "可视化缩进
Plug 'Shougo/context_filetype.vim' "根据内容自动获取文件类型
Plug 'tyru/caw.vim' "自动进行注释
Plug 'jistr/vim-nerdtree-tabs' " 可以使 nerdtree 的 tab 更加友好些
Plug 'preservim/tagbar' " 查看当前代码文件中的变量和函数列表的插件
Plug 'Yggdroot/LeaderF' "模糊查询文件
call plug#end()

" 设置leader键
let mapleader=","
nnoremap <leader>ev :e $MYVIMRC<cr> " 打开我的配置文件

let g:airline_theme='molokai' 
set laststatus=2  "永远显示状态栏
" 显示窗口tab和buffer
let g:airline#extensions#tabline#enabled = 1 
"tabline中buffer显示编号
let g:airline#extensions#tabline#buffer_nr_show = 1


let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\   'ctermfgs': ['lightyellow', 'lightcyan','lightblue', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\   }
\}
" rainbow设置结束

" caw.vim注释快捷键修改
"  -- ctrl+/设置为打开、关闭注释
" 注意！Unix操作系统中的ctrl+/会被认为是ctrl+_，所以下面有这样一条if判断
if has('win32')
    nmap <C-/> gcc
    vmap <C-/> gcc
else
    nmap <C-_> gcc
    vmap <C-_> gcc
endif

" NERDTree settings                                         
" open a NERDTree automatically when vim starts up if no files were specified    
"autocmd StdinReadPre * let s:std_in=1    
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif    
                             
" open NERDTree automatically when vim starts up on opening a directory    
autocmd StdinReadPre * let s:std_in=1    
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" map a specific key or shortcut to open NERDTree
map <leader>t :NERDTreeToggle<CR>

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Let NERDTree igonre files
let NERDTreeIgnore = ['\.pyc$', '\.swp$']
" nerdtree设置结束

nnoremap <F4> :TagbarToggle<CR>
let g:tagbar_ctags_bin='/usr/bin/ctags'
let g:tagbar_width=30

" 管理coc.nvim插件
let g:coc_global_extensions=['coc-json', 'coc-vimlsp', 'coc-marketplace']
" 设置coc
" 允许未保存文件时跳转文件
set hidden
" 增加响应
set updatetime=100
" 让弹窗栏更加简洁
set shortmess+=c
" 让我们的tab作为切换扩展的按键
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" 按下ctrl+space键跳出或关闭自动补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" 当使用enter键作为补全选择时，它将不会自动切换到下一行
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 使用[g或者]g来查找上一个或者下一个代码报错
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" 使用gd来跳转到函数定义处、gy获取类型定义，
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" 共用行号
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" 通过gh来显示文档
nnoremap gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" 高亮相同的词汇
autocmd CursorHold * silent call CocActionAsync('highlight')

" 符号重命名
nmap <leader>rn <Plug>(coc-rename)

" 格式化插件
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" 共用行号
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.1") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
