" Open :Man in a vertical split instead of horizontal, but only if the current
" window is wide enough to accommodate it.
if winwidth(winnr('#')) >= 180
    execute 'wincmd ' . (&splitright ? 'L' : 'H')
    vertical resize 80
endif
