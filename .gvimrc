set guicursor=a:blinkon0  "stop blink
set guioptions-=T
set guioptions-=r
set guioptions-=L
"colorscheme desert
set background=light
colorscheme solarized
if has('unix')
  set guifont=Ubuntu\ Mono\ 12
endif
if has('macunix')
  set guifont=Ubuntu\ Mono:h14
  set transparency=10
endif
