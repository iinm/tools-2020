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
"Plug 'ternjs/tern_for_vim'
Plug 'SirVer/ultisnips'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'freitass/todo.txt-vim'
Plug 'godlygeek/tabular'
Plug 'gutenye/json5.vim'
Plug 'honza/vim-snippets'
Plug 'jceb/vim-orgmode'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'jnurmine/Zenburn'
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
Plug 'valloric/youcompleteme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
call plug#end()

" plugin config
colorscheme base16-mocha

let NERDTreeShowHidden = 1

let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\}

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'base16_mocha'

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

set wildignore+=*/.git/*,*/tmp/*,*.swp

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" plugin keymap
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" keymap
let maplocalleader = ","
let mapleader = ","

nnoremap [file] <Nop>
nmap <Space>f [file]
nnoremap <silent> [file]t :<C-u>NERDTreeTabsToggle<CR>
"nnoremap <silent> [file]f :<C-u>Denite file_rec<CR>
"nnoremap <silent> [file]p :<C-u>DeniteProjectDir file_rec<CR>
"nnoremap <silent> [file]b :<C-u>DeniteBuffer file_rec<CR>
"nnoremap <silent> [file]m :<C-u>Denite file_mru<CR>

nnoremap [buffer] <Nop>
nmap <Space>b [buffer]
"nnoremap <silent> [buffer]b :<C-u>Denite buffer<CR>
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
