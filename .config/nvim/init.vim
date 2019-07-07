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
"set list
"set listchars=tab:>-,trail:·,extends:>,precedes:<
set clipboard+=unnamedplus
set mouse=a
set termguicolors
set completeopt=menuone,preview,noinsert,noselect


" --- plugin
" fuzzy finder
packadd! fzf
packadd! fzf.vim

" color scheme
packadd! base16-vim

" language client
packadd! async.vim
packadd! vim-lsp

" snippets
packadd! ultisnips
packadd! vim-snippets

" utilities
packadd! emmet-vim
packadd! nerdcommenter
packadd! delimitmate
packadd! vim-multiple-cursors
packadd! tabular
packadd! BufOnly.vim


" --- looks
colorscheme base16-zenburn
let g:netrw_liststyle=3  " tree style
let g:markdown_fenced_languages = ['sh']


" --- language client
let g:lsp_virtual_text_enabled = 0

if executable('gopls')
  augroup lsp_go
    autocmd!
    au User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
          \ 'whitelist': ['go'],
          \ })
    autocmd Filetype go setlocal omnifunc=lsp#complete
    autocmd BufWritePre *.go LspDocumentFormatSync
  augroup END
endif

if executable('pyls')
  augroup lsp_python
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ })
    autocmd Filetype python setlocal omnifunc=lsp#complete
  augroup END
endif


" --- indent
augroup config_indent
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

augroup detect_filetyle
  autocmd!
  autocmd BufNewFile,BufRead *.json5 setfiletype javascript
augroup END


" --- highlight todo
augroup highlight_todostate
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyTodo', 'TODO:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyWip',  'WIP:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyDone', 'DONE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyTodo guibg=LightRed    guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyWip  guibg=LightYellow guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyDone guibg=LightGreen  guifg=Black
augroup END

augroup highlight_keywords
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyDue',  'DUE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('MyNote', 'NOTE:')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyDue  guibg=White     guifg=Black
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight MyNote guibg=LightBlue guifg=Black
augroup END

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


" --- grep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --glob\ '!*~'\ --glob\ '!.git'
endif


" --- jump
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


" --- keymap
let mapleader = ","

let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

"nnoremap <Leader>j :<C-u>call GotoJump()<CR>
nnoremap <Leader>t :<C-u>call RotateTodoState()<CR>
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
inoremap <C-Space> <C-x><C-o>

nnoremap <Leader><Leader> :<C-u>Commands<CR>

nnoremap [file] <Nop>
nmap <Leader>f [file]
nnoremap [file]e :<C-u>Explore<CR>
nnoremap [file]f :<C-u>Files<CR>
nnoremap [file]h :<C-u>History<CR>
nnoremap [file]g :<C-u>GitFiles<CR>

nnoremap [jump] <Nop>
nmap <Leader>j [jump]
nnoremap [jump]j :<C-u>call GotoJump()<CR>
nnoremap [jump]l :<C-u>BLines<CR>

nnoremap [grep] <Nop>
nmap <Leader>g [grep]
nnoremap [grep]g :<C-u>grep! 
nnoremap [grep]c :grep! <cword><CR>
nnoremap [grep]w :grep! '\b<cword>\b'<CR>

nnoremap [buffer] <Nop>
nmap <Leader>b [buffer]
nnoremap [buffer]b :<C-u>Buffers<CR>
nnoremap [buffer]o :<C-u>BufOnly<CR>

nnoremap [code] <Nop>
nmap <Leader>c [code]
nnoremap [code]a :<C-u>LspCodeAction<CR>
nnoremap [code]j :<C-u>LspDefinition<CR>
nnoremap [code]d :<C-u>LspHover<CR>
nnoremap [code]t :<C-u>LspTypeDefinition<CR>
nnoremap [code]r :<C-u>LspReference<CR>
nnoremap [code]n :<C-u>LspRename<CR>
nnoremap [code]s :<C-u>Snippets<CR>

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
