" Matt's ~/.exrc
"
" Note: ex and vi will stop processing at the first blank line.
"
set autoindent
set ignorecase
set showmatch
set showmode
set shiftwidth=4
set tabstop=4
"
" Always report the number of lines modified by a command.
set report=0
"
" Allow arrow keys for movement in insert mode when using traditional Unix vi.
map! OA ka
map! OB ja
map! OD i
map! OC la
