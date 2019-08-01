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
set listchars=tab:\⇥\ ,trail:·,extends:>,precedes:<,nbsp:+
set clipboard+=unnamedplus
set mouse=a
set termguicolors
set completeopt=menuone,preview,noinsert,noselect
set exrc
set secure


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

" language
packadd! vim-go
packadd! dbext.vim
packadd! vim-jsx-pretty
packadd! vim-styled-jsx

" plantuml
packadd plantuml-syntax
packadd! open-browser.vim
packadd! plantuml-previewer.vim

" utility
packadd! emmet-vim
packadd! nerdcommenter
packadd! delimitmate
packadd! vim-multiple-cursors
packadd! tabular
packadd! BufOnly.vim
packadd! goyo.vim
packadd! gtags.vim
packadd! vim-preview
packadd! todo.txt-vim
packadd! markdown-preview.nvim  " cd app & yarn install
packadd! vim-surround

function! s:load_fugitive()
  packadd vim-fugitive
  call fugitive#detect(expand('%:p'))
endfunction

augroup pack_loader
  autocmd!
  autocmd CmdUndefined Gblame,Gstatus,Glog,Gdiff,Ggrep call s:load_fugitive()
augroup END


" --- looks
colorscheme base16-eighties
let g:netrw_liststyle = 3  " tree style
let g:markdown_fenced_languages = ['sh']
let g:goyo_width = 120
let g:goyo_height = '100%'


" --- vim-go
"let g:go_def_mode = 'godef'
let g:go_fmt_command = "goimports"


" --- language client
if !empty($vim_lsp_debug)
  let g:lsp_log_verbose = 1
  let g:lsp_log_file = expand('~/vim-lsp.log')
endif

let g:lsp_virtual_text_enabled = 0

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

if executable('java') && !empty($jdt_project_root)
  augroup lsp_java
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'jdt.ls',
          \ 'cmd': {server_info->['jdt.ls']},
          \ 'root_uri': {server_info->'file://' . $jdt_project_root},
          \ 'whitelist': ['java'],
          \ })
    autocmd Filetype java setlocal omnifunc=lsp#complete
  augroup END
endif

if executable('typescript-language-server')
  augroup lsp_javascript
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'javascript support using typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
          \ 'whitelist': ['javascript', 'javascript.jsx'],
          \ })
  augroup END
endif


" --- omnifunc
"augroup set_omnifunc
"  autocmd!
"  autocmd Filetype java setlocal omnifunc=syntaxcomplete#Complete
"augroup END
"

"let s:omnifunc_on_typing_language = []
let s:omnifunc_on_typing_language = ['go', 'python']

function! OpenCompletion()
  if !empty(&omnifunc)
        \ && !pumvisible()
        \ && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z') || v:char == '.')
    call feedkeys("\<C-x>\<C-o>", "n")
  endif
endfunction

augroup trigger_omnifunc
  autocmd!
  autocmd InsertCharPre * if count(s:omnifunc_on_typing_language, &filetype) | call OpenCompletion() | endif
augroup END


" --- fzf
let g:fzf_tags_command = 'ctags -R'

" preview with '?'
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

"command! -bang -nargs=? -complete=dir Files
"  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" --- tags
command! CtagsUpdate call system('ctags -R')
command! GtagsUpdate call system('gtags -iv')
command! GtagsRefCursor execute 'normal :Gtags -r ' . expand('<cword>') . '<CR>'


" --- delimitmate
augroup config_delimitmate
  autocmd!
  autocmd Filetype markdown let b:delimitMate_expand_cr = 2
  autocmd Filetype markdown let b:delimitMate_expand_inside_quotes = 1
  autocmd Filetype markdown let b:delimitMate_expand_space = 0
  autocmd Filetype markdown let b:delimitMate_nesting_quotes = ['`']
augroup END

" --- quickfix
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

augroup config_quickfix
  autocmd!
  autocmd FileType qf call AdjustWindowHeight(3, 15)
  autocmd FileType qf setlocal nowrap
  autocmd QuickFixCmdPost *grep* cwindow
augroup END


" --- indent
augroup config_indent
  autocmd!
  autocmd Filetype go           setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype python       setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype java,groovy  setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype sh,zsh,vim   setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype xml,html,css setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype javascript   setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype json,yaml    setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype sql          setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype markdown     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype plantuml     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
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
  if current =~# 'TODO'
    s/TODO:/WIP:/
  elseif current =~# 'WIP'
    s/WIP:/DONE:/
  elseif current =~# 'DONE'
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

let g:UltiSnipsExpandTrigger = "<c-k>"
let g:UltiSnipsJumpForwardTrigger = "<c-f>"
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
let g:NERDCreateDefaultMappings = 0

"nnoremap <Leader>t :<C-u>call RotateTodoState()<CR>
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>
" omnifunc
inoremap <C-Space> <C-x><C-o>
" preview quickfix
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<CR>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<CR>

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

nnoremap [tags] <Nop>
nmap <Leader>t [tags]
nnoremap [tags]t :<C-u>Gtags 
nnoremap [tags]d :<C-u>GtagsCursor<CR>
nnoremap [tags]r :<C-u>GtagsRefCursor<CR>
nnoremap [tags]f :<C-u>Gtags -f %<CR>

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

nnoremap <Leader>cc :<C-u>call NERDComment('n', 'toggle')<CR>
vnoremap <Leader>cc :<C-u>call NERDComment('x', 'sexy')<CR>

augroup keymap_go
  autocmd!
  autocmd FileType go nnoremap [code]i :<C-u>GoImport 
  autocmd FileType go nnoremap [code]j :<C-u>GoDef<CR>
  autocmd FileType go nnoremap [code]d :<C-u>GoDoc<CR>
  autocmd FileType go nnoremap [code]t :<C-u>GoTestFunc<CR>
augroup END

" vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

" --- Cheat Sheet
" open file            :e **/main.go
" open new buffer      :enew -> :r! find . -t f
" jump                 :jumps -> [N] Ctrl-O (older location) or Ctrl-I (newer location)
" recent files         :browse oldfiles
" recent files         :browse filter /pattern/ oldfiles
" open path            gf (goto file), gx (xdg-open)
" grep current dir     :grep! hoge -> :cw
" grep current buffer  :grep! hoge %
" expand emmet         <C-y>
" expand snippets      <C-k> -> <C-f> or <C-b>
