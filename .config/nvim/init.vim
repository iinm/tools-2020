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
Plug 'junegunn/vim-plug'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'ternjs/tern_for_vim'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'gutenye/json5.vim'
Plug 'mattn/emmet-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jnurmine/Zenburn'
Plug 'chriskempson/base16-vim'
call plug#end()

" plugin config
colorscheme base16-mocha

let g:deoplete#enable_at_startup = 1

let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\}

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'base16_mocha'

call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '--smart-case', '--ignore-dir', 'node_modules', '--ignore-dir', '.git', '--ignore-dir', '.idea', '--ignore', '*~', '--ignore', '*.swp', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])

"call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
"      \ [ '*~', '*.o', '*.exe', '*.bak',
"      \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
"      \ '.hg/', '.git/', '.bzr/', '.svn/',
"      \ 'node_modules/', 'bower_components/', 'tmp/', 'log/', 'vendor/ruby',
"      \ '.idea/', 'dist/',
"      \ 'tags', 'tags-*'])

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
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/snippets/snippets'

" keymap
let maplocalleader = ","
let mapleader = ","

nnoremap [denite] <Nop>
nmap <Space>d [denite]
nnoremap [denite]d :<C-u>Denite 
nnoremap [denite]b :<C-u>DeniteBufferDir 
nnoremap [denite]p :<C-u>DeniteProjectDir 
nnoremap [denite]w :<C-u>DeniteCursorWord 
nnoremap <silent> [denite]c :<C-u>Denite command<CR>
nnoremap <silent> [denite]g :<C-u>Denite -auto_preview grep<CR>
nnoremap <silent> [denite]j :<C-u>Denite jump<CR>
nnoremap <silent> [denite]h :<C-u>Denite help<CR>

call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

nnoremap [file] <Nop>
nmap <Space>f [file]
nnoremap <silent> [file]t :<C-u>NERDTreeTabsToggle<CR>
nnoremap <silent> [file]f :<C-u>Denite file_rec<CR>
nnoremap <silent> [file]p :<C-u>DeniteProjectDir file_rec<CR>
nnoremap <silent> [file]b :<C-u>DeniteBuffer file_rec<CR>
nnoremap <silent> [file]m :<C-u>Denite file_mru<CR>

nnoremap [buffer] <Nop>
nmap <Space>b [buffer]
nnoremap <silent> [buffer]b :<C-u>Denite buffer<CR>
nnoremap [buffer]d :<C-u>bdelete<CR>

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
