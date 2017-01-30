set encoding=utf-8    " character encoding used inside Vim
scriptencoding utf-8  " character encoding used in this script

" --- character encoding -----------------------
set fileencoding=utf-8  " encoding for file
" encodings considered when starting to edit an existing file
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,latin1
set fileformats=unix,dos,mac  " end-of-line (<EOL>) formats
"set ambiwidth=double

" --- clipboard -----------------------
set clipboard+=autoselect      " visual selection -> clipboard
set clipboard+=unnamed         " yank -> clipboard

" --- status-line -----------------------
set laststatus=2  " always a status line
set showmode
set showcmd
set ruler

" --- command-line -----------------------
set wildmenu
set history=5000

" --- tab & indent -----------------------
filetype plugin indent on
"set expandtab
"set tabstop=4
"set softtabstop=4
set autoindent
set smartindent
"set shiftwidth=4

" --- search -----------------------
set incsearch
set ignorecase
set smartcase
set hlsearch

" --- mouse -----------------------
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" --- etc -----------------------
set t_Co=256
syntax enable
set backspace=indent,eol,start
set showmatch
source $VIMRUNTIME/macros/matchit.vim

" --- packages -----------------------
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/neocomplete'  "requires lua
"NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'honza/vim-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
"NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'mattn/emmet-vim'
"NeoBundle 'pangloss/vim-javascript'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
"NeoBundle 'ctrlpvim/ctrlp.vim'
"NeoBundle 'tacahiroy/ctrlp-funky'
"NeoBundle 'suy/vim-ctrlp-commandline'
NeoBundle 'fatih/vim-go'
NeoBundle 'altercation/vim-colors-solarized'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" --- neocomplete -----------------------
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" --- neosnippet -----------------------
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" --- Unite -----------------------
let g:unite_source_history_yank_enable = 1

" --- keymap -----------------------
" Unite
nnoremap [unite] <Nop>
nmap <Space>u [unite]
nnoremap <silent> [unite]u :<C-u>Unite -start-insert<CR>
nnoremap <silent> [unite]c :<C-u>Unite -start-insert command<CR>
nnoremap <silent> [unite]ff :<C-u>Unite -start-insert file<CR>
nnoremap <silent> [unite]fr :<C-u>Unite -start-insert file_rec/async:!<CR>
nnoremap <silent> [unite]fg :<C-u>Unite -start-insert file_rec/git<CR>
nnoremap <silent> [unite]fs :<C-u>Unite -tab -no-quit find<CR>
nnoremap <silent> [unite]fm :<C-u>Unite -start-insert file_mru<CR>
nnoremap <silent> [unite]g :<C-u>Unite -tab -no-quit grep<CR>
nnoremap <silent> [unite]b :<C-u>Unite -start-insert buffer<CR>
nnoremap <silent> [unite]t :<C-u>Unite -start-insert tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite -start-insert window<CR>
nnoremap <silent> [unite]h :<C-u>Unite -start-insert history/unite<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>

" file
"nnoremap [file] <Nop>
"nmap <Space>f [file]
"nnoremap <silent> [file]f :<C-u>Unite -start-insert file<CR>
"nnoremap <silent> [file]r :<C-u>Unite -start-insert file_rec/async:!<CR>
"nnoremap <silent> [file]g :<C-u>Unite -start-insert file_rec/git<CR>

" buffer
nnoremap [buffer] <Nop>
nmap <Space>b [buffer]
"nnoremap <silent> [buffer]l :<C-u>Unite -start-insert buffer<CR>
nnoremap [buffer]d :<C-u>bdelete<CR>

"tab
nnoremap [tab] <Nop>
nmap <Space>t [tab]
"nnoremap <silent> [tab]l :<C-u>Unite -start-insert tab<CR>
nnoremap [tab]e :<C-u>tabedit 
nnoremap <silent> [tab]c :<C-u>tabnew<CR>
nnoremap <silent> [tab]t :<C-u>tabnext<CR>
nnoremap <silent> [tab]n :<C-u>tabnext<CR>
nnoremap <silent> [tab]p :<C-u>tabprevious<CR>

" window
nnoremap [window] <Nop>
nmap <Space>w [window]
nnoremap <silent> [window]s :<C-u>split<CR>
nnoremap <silent> [window]v :<C-u>vsplit<CR>
nnoremap <silent> [window]w <C-w><C-w>
nnoremap <silent> [window]h <C-w>h
nnoremap <silent> [window]j <C-w>j
nnoremap <silent> [window]k <C-w>k
nnoremap <silent> [window]l <C-w>l
"nnoremap <silent> [window]_ <C-w>_
"nnoremap <silent> [window]| <C-w>|
nnoremap <silent> [window]= <C-w>=
nnoremap <silent> [window]> <C-w>>
nnoremap <silent> [window]< <C-w><
nnoremap <silent> [window]+ <C-w>+
nnoremap <silent> [window]- <C-w>-
