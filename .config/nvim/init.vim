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
  autocmd Filetype sql          setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype markdown     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
augroup END

augroup filetypedetect
  autocmd!
  autocmd BufNewFile,BufRead *.json5 setfiletype javascript
augroup END

augroup highlighttodostate
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyTodo', 'TODO:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyWip',  'WIP:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyDone', 'DONE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyTodo guibg=LightRed    guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyWip  guibg=LightYellow guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyDone guibg=LightGreen  guifg=Black
augroup END

augroup highlightkeywords
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyDue',  'DUE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyNote', 'NOTE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyDue  guibg=White     guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyNote guibg=LightBlue guifg=Black
augroup END

if executable('rg')
  set grepprg=rg\ --vimgrep\ --glob\ '!*~'\ --glob\ '!.git'
endif

" http://vim.wikia.com/wiki/Jumping_to_previously_visited_locations
function! GotoJump()
  jumps
  let j = input("Select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction

function! RotateTodoState()
  let current = expand('<cword>')
  if current =~ 'TODO'
    s/TODO:/WIP:/
  elseif current =~ 'WIP'
    s/WIP:/DONE:/
  elseif current =~ 'DONE'
    s/DONE:/TODO:/
  endif
endfunction

let mapleader = "\<Space>"
nnoremap <Leader>j :<C-u>call GotoJump()<CR>
nnoremap <Leader>t :<C-u>call RotateTodoState()<CR>
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
nnoremap gr :grep! <cword> <CR>
nnoremap gR :grep! '\b<cword>\b' <CR>

" vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

" Cheat Sheet
" :e **/main.go
" :enew -> :r! find . -t f
" :jumps -> [N] Ctrl-O (older location) or Ctrl-I (newer location)
" :browse oldfiles
" :browse filter /pattern/ oldfiles
" gf (goto file), gx (xdg-open)
" :grep! hoge -> :cw
" :grep! hoge %
