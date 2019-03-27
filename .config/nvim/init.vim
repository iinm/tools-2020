set hidden
set nobackup
set undofile
set wildmenu
set wildmode=full
set wildoptions=pum
set wildignore=*~,*.swp,.git,*.class,*.o,*.pyc,node_modules
set hlsearch
set ignorecase
set smartcase
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<
set clipboard+=unnamedplus
set mouse=a
set termguicolors

colorscheme desert
let g:netrw_liststyle=3  " tree style
let g:markdown_fenced_languages = ['sh']

augroup indentconfig
  autocmd!
  autocmd Filetype go           setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype python       setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype sh,zsh,vim   setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype xml,html,css setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype javascript   setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype json,yaml    setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
augroup END

augroup filetypedetect
  autocmd!
  autocmd BufNewFile,BufRead *.json5 setfiletype javascript
augroup END

augroup highlighttodo
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('Todo', 'TODO')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight Todo guibg=Red guifg=White
augroup END

if executable('rg')
  set grepprg=rg\ --vimgrep\ --glob\ '!*~'\ --glob\ '!.git'
endif

" vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

" Cheat Sheet
" :e **/main.go
" :enew -> :r! find . -t f
" :jumps -> [N] Ctrl-O (older location) or Ctrl-I (newer location)
" :browse oldfiles
" :browse filter /pattern/ oldfiles
" gf (goto file), gx (xdg-open)
" :grep hoge -> :cw
" :grep hoge %
