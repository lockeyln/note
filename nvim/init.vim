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
set wildmenu "输入命令的时候Tab显示提示
set cursorline "高亮显示当前行
set termguicolors
set t_Co=256

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab  "将Tab自动转化成空格
set autoindent  "自动与上一行缩进保持一致
set smartindent 
set ruler "显示当前行号列号
set showcmd "在状态栏显示正在输入的命令

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight  
"colorscheme molokai
"colorscheme onedark 

map <F5> :call RunPython()<CR>
func! RunPython()
	exec "w"
	if &filetype=='python'
		exec "!time python3.9 %"
	endif
endfunc

autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>

"vim-plug配置
call plug#begin('~/.config/nvim/plugged')
Plug 'ghifarit53/tokyonight-vim'
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
Plug 'tpope/vim-surround' 
Plug 'honza/vim-snippets' "代码片段库
Plug 'tell-k/vim-autopep8'
call plug#end()

" 设置leader键
let mapleader=","
nnoremap <leader>ev :e $MYVIMRC<cr> " 打开我的配置文件

autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>

let g:airline_theme='desertink' 
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
"let g:coc_global_extensions=['coc-json', 'coc-vimlsp', 'coc-marketplace']

"coc默认设置

" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
 
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=100
 
" don't give |ins-completion-menu| messages.
set shortmess+=c
 
" always show signcolumns
set signcolumn=yes
 
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
 
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
 
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
 
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
 
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
 
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
 
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
 
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
 
" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
 
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
 
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
 
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
 
" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
 
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
 
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
 
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
