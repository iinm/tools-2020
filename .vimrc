source $VIMRUNTIME/defaults.vim

set hidden
set undofile
set clipboard=unnamed,unnamedplus,autoselect
set wildmode=longest,full
set wildignore+=*/.git/*,*/tmp/*,*.swp
set number "relativenumber
"set statusline+=%F
set termguicolors
" search
set hlsearch
set ignorecase
set smartcase
" highlight space
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<
" mouse
if has('mouse_sgr')
  set ttymouse=sgr
endif
" cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


" --- plugins
" looks
packadd! onedark.vim
packadd! vim-airline

" snippet
packadd! ultisnips
packadd! vim-snippets

" language
packadd vim-go
packadd typescript-vim
packadd vim-javascript
packadd vim-jsx-pretty
packadd vim-toml
packadd nginx.vim
packadd logstash.vim
packadd Vim-Jinja2-Syntax
packadd vim-freemarker
packadd vim-systemd-syntax

" completion & lsp
packadd! asyncomplete.vim
packadd! async.vim
packadd! vim-lsp
packadd! asyncomplete-lsp.vim
packadd! asyncomplete-file.vim
packadd! asyncomplete-buffer.vim
packadd! asyncomplete-ultisnips.vim
packadd! ale

" tools
packadd! matchit
packadd! fzf
packadd! fzf.vim
packadd! emmet-vim
packadd! nerdcommenter
packadd! tabular
packadd! vim-multiple-cursors
packadd! auto-pairs
packadd! vim-surround
packadd! vim-sleuth
packadd! vim-livedown
packadd colorizer
packadd vCoolor.vim


" lazy load
function! s:load_nerdtree()
  packadd nerdtree
  "let g:NERDTreeShowHidden = 1
endfunction

function! s:load_fugitive()
  packadd vim-fugitive
  call fugitive#detect(expand('%:p'))
endfunction

augroup pack_loader
  autocmd!
  autocmd CmdUndefined NERDTree* call s:load_nerdtree()
  autocmd CmdUndefined Gblame,Gstatus,Glog,Gdiff call s:load_fugitive()
augroup END


" --- looks
colorscheme onedark
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'onedark'


" --- lsp
" https://github.com/prabirshrestha/vim-lsp/wiki
let g:lsp_async_completion = 1
let g:lsp_diagnostics_enabled = 0 " use ALE
augroup lsp_server_registration
  if executable('go-langserver')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'go-langserver',
          \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
          \ 'whitelist': ['go'],
          \ })
  endif
  if executable('typescript-language-server')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'javascript support using typescript-language-server',
          \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
          \ 'whitelist': ['javascript', 'javascript.jsx']
          \ })
  endif
  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript', 'typescript.tsx'],
          \ })
  endif
  if executable('css-languageserver')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'css-languageserver',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
          \ 'whitelist': ['css', 'less', 'sass'],
          \ })
  endif
  if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
          \ })
  endif
augroup END

" debug
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')


" --- etc.
let g:go_fmt_command = "goimports"

let g:ale_linters = {
\ 'javascript': ['eslint', 'flow'],
\}
let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'typescript': ['tslint'],
\ 'json': ['prettier'],
\ 'go': ['goimports']
\ }
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --no-semi --arrow-parens always'
"let g:ale_fix_on_save = 1

let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

let g:markdown_fenced_languages = ['go', 'python', 'sh', 'javascript', 'java', 'json', 'yaml']

augroup asyncomplete_source_registration
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        \ 'name': 'file',
        \ 'whitelist': ['*'],
        \ 'priority': 10,
        \ 'completor': function('asyncomplete#sources#file#completor')
        \ }))
  autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \ 'name': 'buffer',
        \ 'whitelist': ['*'],
        \ 'blacklist': ['go', 'javascript', 'javascript.jsx', 'typescript', 'python'],
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \ }))
augroup END


" --- search
if executable('rg')
  set grepprg=rg\ --color=never
endif

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


" --- functions
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
let maplocalleader = ","
let mapleader = ","

let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

nnoremap <space><space> :<C-u>Commands<CR>

nnoremap [file] <Nop>
nmap <Space>f [file]
nnoremap [file]t :<C-u>NERDTree<CR>
nnoremap [file]T :<C-u>NERDTreeFind<CR>
nnoremap [file]f :<C-u>Files<CR>
nnoremap [file]h :<C-u>History<CR>
nnoremap [file]g :<C-u>GitFiles<CR>

nnoremap [navi] <Nop>
nmap <Space>n [navi]
nnoremap [navi]b <C-o>
nnoremap [navi]f <C-i>
nnoremap [navi]j :<C-u>call GotoJump()<CR>
nnoremap [navi]l :<C-u>BLines<CR>

nnoremap [grep] <Nop>
nmap <Space>g [grep]
nnoremap [grep]g :<C-u>Rg 
nnoremap [grep]c :<C-u>RgCursorWord<CR>
nnoremap [grep]w :<C-u>RgCursorWordExact<CR>

nnoremap [buffer] <Nop>
nmap <Space>b [buffer]
nnoremap [buffer]b :<C-u>Buffers<CR>
nnoremap [buffer]d :<C-c> :bp\|bd #<CR>
"nnoremap [buffer]d :<C-u>bdelete<CR>

nnoremap [tab] <Nop>
nmap <Space>t [tab]
nnoremap [tab]e :<C-u>tabedit 
nnoremap [tab]n :<C-u>tabnew<CR>
nnoremap [tab]l :<C-u>tabnext<CR>
nnoremap [tab]h :<C-u>tabprevious<CR>
nnoremap [tab]t gt

nnoremap [window] <Nop>
nmap <Space>w [window]
nnoremap [window]s :<C-u>split<CR>
nnoremap [window]v :<C-u>vsplit<CR>
nnoremap [window]w <C-w><C-w>
nnoremap [window]o <C-w><C-o>
nnoremap [window]h <C-w>h
nnoremap [window]j <C-w>j
nnoremap [window]k <C-w>k
nnoremap [window]l <C-w>l
"nnoremap [window]_ <C-w>_
"nnoremap [window]| <C-w>|
nnoremap [window]= <C-w>=
nnoremap [window]> <C-w>>
nnoremap [window]< <C-w><
nnoremap [window]+ <C-w>+
nnoremap [window]- <C-w>-

nnoremap [code] <Nop>
nmap <Space>c [code]
nnoremap [code]a :<C-u>LspCodeAction<CR>
nnoremap [code]j :<C-u>LspDefinition<CR>
nnoremap [code]d :<C-u>LspHover<CR>
nnoremap [code]t :<C-u>LspTypeDefinition<CR>
nnoremap [code]r :<C-u>LspReference<CR>
nnoremap [code]n :<C-u>LspRename<CR>
nnoremap [code]s :<C-u>Snippets<CR>
nnoremap [code]f :<C-u>ALEFix<CR>
nnoremap [code]e :<C-u>ALENext<CR>

augroup keymap_go
  autocmd!
  autocmd FileType go nnoremap [code]i :<C-u>GoImport 
  "autocmd FileType go nnoremap [code]j :<C-u>GoDef<CR>
  "autocmd FileType go nnoremap [code]d :<C-u>GoDoc<CR>
  autocmd FileType go nnoremap [code]tt :<C-u>GoTest<CR>
  autocmd FileType go nnoremap [code]tf :<C-u>GoTestFunc<CR>
augroup END


" --- indent
augroup indent_config
  autocmd!
  autocmd Filetype go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd Filetype sh,zsh,vim setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd Filetype xml,html,css,javascript,json,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END


" --- filetype detect
augroup filetype_detect
  autocmd!
  autocmd BufNewFile,BufRead *.json5 setfiletype javascript
augroup END


" vim: tabstop=2 softtabstop=2 shiftwidth=2 expandtab
