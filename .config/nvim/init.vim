set backup
set undofile
set ruler
set showcmd
set number
set mouse=a
set clipboard+=unnamedplus
" highlight space
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<
" search
set incsearch
set ignorecase
set smartcase
set hlsearch

syntax on
filetype plugin indent on

"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
let base16colorspace=256
"colorscheme desert

" plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'SirVer/ultisnips'
Plug 'andreshazard/vim-freemarker'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
Plug 'freitass/todo.txt-vim'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-plug'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-fugitive', { 'on': [] }
Plug 'tpope/vim-sleuth'
Plug 'valloric/youcompleteme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
"Plug 'chriskempson/base16-vim'
"Plug 'gutenye/json5.vim'
"Plug 'jceb/vim-orgmode'
"Plug 'jnurmine/Zenburn'
"Plug 'python-rope/ropevim'
call plug#end()

" plugin config
"colorscheme base16-mocha
colorscheme onedark

let g:airline#extensions#tabline#enabled = 1
"let g:airline_theme = 'base16_mocha'
let g:airline_theme = 'onedark'

let NERDTreeShowHidden = 1

let g:ale_linters = {
\ 'javascript': ['eslint', 'flow'],
\}

let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'json': ['prettier'],
\ 'go': ['goimports']
\ }
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --no-semi --arrow-parens always'
"let g:ale_fix_on_save = 1

let g:go_fmt_command = "goimports"

if executable('rg')
  set grepprg=rg\ --color=never
endif

set wildignore+=*/.git/*,*/tmp/*,*.swp

" :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
" :Rg! - Start fzf in fullscreen and display the preview window above
let s:rg_command = 'rg --hidden --glob "!.git" --glob "!*~" --column --line-number --no-heading --color=always '
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   s:rg_command.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" grep word under cursor
command! -bang -nargs=0 RgCursorWord
  \ call fzf#vim#grep(
  \   s:rg_command.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=0 RgCursorWordExact
  \ call fzf#vim#grep(
  \   s:rg_command.shellescape('\b' . expand('<cword>') . '\b'), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

" https://github.com/junegunn/vim-plug/issues/164
command! Gstatus call LazyLoadFugitive('Gstatus')
command! Gdiff call LazyLoadFugitive('Gdiff')
command! Glog call LazyLoadFugitive('Glog')
command! Gblame call LazyLoadFugitive('Gblame')

function! LazyLoadFugitive(cmd)
  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction

" YouCompleteMe; enable lombok
let s:lombok_jar_path = expand('~/tools/opt/lombok.jar')
let $JAVA_TOOL_OPTIONS = '-javaagent:' . s:lombok_jar_path . ' -Xbootclasspath/p:' . s:lombok_jar_path

" plugin keymap
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" keymap
let maplocalleader = ","
let mapleader = ","

nnoremap <space><space> :<C-u>Commands<CR>

nnoremap [file] <Nop>
nmap <Space>f [file]
nnoremap <silent> [file]t :<C-u>NERDTreeTabsToggle<CR>
nnoremap <silent> [file]T :<C-u>NERDTreeFind<CR>
nnoremap <silent> [file]f :<C-u>Files<CR>
nnoremap <silent> [file]h :<C-u>History<CR>
nnoremap <silent> [file]g :<C-u>GitFiles<CR>

nnoremap [grep] <Nop>
nmap <Space>g [grep]
nnoremap [grep]g :<C-u>Rg 
nnoremap [grep]c :<C-u>RgCursorWord<CR>
nnoremap [grep]w :<C-u>RgCursorWordExact<CR>

nnoremap [buffer] <Nop>
nmap <Space>b [buffer]
nnoremap <silent> [buffer]b :<C-u>Buffers<CR>
nnoremap [buffer]d :<C-c> :bp\|bd #<CR>
"nnoremap [buffer]d :<C-u>bdelete<CR>

nnoremap [tab] <Nop>
nmap <Space>t [tab]
nnoremap [tab]e :<C-u>tabedit 
nnoremap <silent> [tab]n :<C-u>tabnew<CR>
nnoremap <silent> [tab]l :<C-u>tabnext<CR>
nnoremap <silent> [tab]h :<C-u>tabprevious<CR>
nnoremap <silent> [tab]t gt

nnoremap [window] <Nop>
nmap <Space>w [window]
nnoremap <silent> [window]s :<C-u>split<CR>
nnoremap <silent> [window]v :<C-u>vsplit<CR>
nnoremap <silent> [window]w <C-w><C-w>
nnoremap <silent> [window]o <C-w><C-o>
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

nnoremap [code] <Nop>
nmap <Space>c [code]
nnoremap [code]g :<C-u>YcmCompleter GoTo<CR>
nnoremap [code]j :<C-u>YcmCompleter GoToDefinition<CR>
nnoremap [code]d :<C-u>YcmCompleter GetDoc<CR>
nnoremap [code]t :<C-u>YcmCompleter GetType<CR>
nnoremap [code]r :<C-u>YcmCompleter GoToReferences<CR>
nnoremap [code]n :<C-u>YcmCompleter RefactorRename<CR>

autocmd FileType go nnoremap [code]i :<C-u>GoImport 
autocmd FileType go nnoremap [code]j :<C-u>GoDef<CR>
autocmd FileType go nnoremap [code]d :<C-u>GoDoc<CR>
autocmd FileType go nnoremap [code]tt :<C-u>GoTest<CR>
autocmd FileType go nnoremap [code]tf :<C-u>GoTestFunc<CR>
