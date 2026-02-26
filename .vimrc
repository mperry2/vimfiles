" vint: -ProhibitSetNoCompatible

" Normally this if-block is not needed, because `:set nocp` is done
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

" Check if $HOME/.viminfo is writable (if present) and warn if it's not. This
" file can change ownership to root if the user runs `sudo vim`. The sudoedit
" command should be used instead to avoid this problem.
if !empty(glob('~/.viminfo'))
  if !filewritable(expand('~/.viminfo'))
    echo "WARNING: ~/.viminfo is not writeable\n"
          \ "Exit the editor and fix the ownership of the file. This problem can occur\n"
          \ "when a user runs 'sudo vim' to edit a file as root. The 'sudoedit' command\n"
          \ "should be used in such cases to avoid this problem.\n"
  endif
endif

" Make Windows use ~/.vim too. I don't want to use _vimfiles
if has('win32') || has('win64')
  set packpath^=~/.vim
  set runtimepath^=~/.vim
endif


" Install minpac if it's not found
if empty(glob('~/.vim/pack/minpac/opt/minpac'))
  silent !echo "Vim plugin 'minpac' not found. Installing it from GitHub."
  silent !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
  if v:shell_error == 0
    let s:minpac_first_install = 1
    silent !echo "Installation of minpac is complete."
  else
    silent !echo "Error installing minpac."
  endif
endif

function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('Einenlum/yaml-revealer')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('bfrg/vim-jq')
  call minpac#add('bfrg/vim-jqplay')
  call minpac#add('bluz71/vim-mistfly-statusline')
  call minpac#add('bluz71/vim-nightfly-colors')
  call minpac#add('dense-analysis/ale')
  call minpac#add('editorconfig/editorconfig-vim')
  call minpac#add('hashivim/vim-terraform')
  call minpac#add('ludovicchabant/vim-gutentags')
  call minpac#add('micarmst/vim-spellsync')
  call minpac#add('pearofducks/ansible-vim')
  call minpac#add('preservim/tagbar')
  call minpac#add('rickhowe/wrapwidth')
  call minpac#add('sirver/ultisnips')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('tpope/vim-characterize')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-sensible')
  call minpac#add('tpope/vim-speeddating')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('wellle/context.vim')
endfunction


" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac  | call minpac#status()

function! MinpacInitNotice()
  call minpac#progress#add_msg('', '')
  call minpac#progress#add_msg('', 'Minpac has been installed automatically, and it has updated your plugins.')
  call minpac#progress#add_msg('', 'Please restart Vim to use the new configuration.')
endfunction

" Update all packages if minpac had to be installed
if exists('s:minpac_first_install')
  call PackInit()
  call minpac#update('', {'do': 'call MinpacInitNotice() | delfunction MinpacInitNotice'})
endif


" Open a terminal window at the directory of a specified plugin. If you
" execute `:PackOpenDir minpac`, it will open a terminal window at
" `~/.vim/pack/minpac/opt/minpac` (or the directory where minpac is
" installed).
function! PackList(...)
  call PackInit()
  return join(sort(keys(minpac#getpluglist())), "\n")
endfunction

command! -nargs=1 -complete=custom,PackList
      \ PackOpenDir call PackInit() | call term_start(&shell,
      \    {'cwd': minpac#getpluginfo(<q-args>).dir,
      \     'term_finish': 'close'})


scriptencoding utf-8

set modeline
set softtabstop=2
set shiftwidth=2
set expandtab
set nojoinspaces
set ignorecase
set smartcase
set hlsearch
set updatetime=100
set spelllang=en_us
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:¬
set splitright

" Show line numbers if terminal width is at least 88 characters
if &columns >= 88
  set number
endif

" Statusline that matches the default when 'ruler' is set but includes
" %{FugitiveStatusline()}
set statusline=%<%f\ %h%m%r%{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P


if (has('termguicolors'))
  if &term =~# 'direct' || $COLORTERM ==? 'truecolor' || $COLORTERM ==? '24bit'
    set termguicolors
  endif
endif

silent! colorscheme nightfly

if has('gui_running')
  set guicursor=a:blinkon0  " Disable blinking cursor
  set guifont=DejaVu_Sans_Mono:h12,Lucida_Console:h12,Fixedsys:h9
  colorscheme xoria256

  if has('win32')
    " Maximize the initial Vim window under MS Windows
    augroup ms_windows
      autocmd!
      autocmd GUIEnter * simalt ~x
      autocmd GUIEnter * set number
    augroup END
  endif
endif


" Enable filetype detection when run from sudoedit
" from https://github.com/tpope/vim-eunuch/commit/4087a5463ff1d9e779dace6fddbdad10e072c1ea
if $SUDO_COMMAND =~# '^sudoedit '
  let files = split($SUDO_COMMAND, ' ')[1:-1]
  if len(files) ==# argc()
    for i in range(argc())
      execute 'autocmd BufEnter' fnameescape(argv(i))
            \ 'if empty(&filetype) || &filetype ==# "conf"'
            \ '|doautocmd filetypedetect BufReadPost '.fnameescape(files[i])
            \ '|endif'
    endfor
  endif
endif


" Close location list when quitting its associated buffer
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END


" Open :help in a vertical split instead of horizontal, but only if the
" current window is wide enough to accomodate it.
augroup vertical_help
  au!
  au WinNew * au BufEnter *.txt ++once
        \ if &bt ==? 'help' && winwidth(winnr('#')) >= 180 |
        \   exe 'wincmd ' . (&splitright ? 'L' : 'H') |
        \   vert resize 80 |
        \ endif
augroup END

" Open :help as the only window if a second window exists but is empty. Useful
" for running :help after starting Vim without needing to maximize the window.
augroup maximize_vim_help
  autocmd!
  autocmd WinNew * autocmd BufEnter *.txt ++once
        \ if &buftype ==? 'help'
        \   && winnr('$') ==# 2
        \   && getbufvar(bufnr('#'), 'buftype') ==# ''
        \   && getbufline(bufnr('#'),1,'$') ==# ['']
        \ | only
        \ | endif
augroup END


" Open :Man in a vertical split instead of horizontal, but only if the current
" window is wide enough to accommodate it.
augroup vertical_manpage
  autocmd!
  autocmd WinNew * autocmd BufEnter * ++once
        \ if &buftype ==? 'man' && winwidth(winnr('#')) >= 180 |
        \     execute 'wincmd ' . (&splitright ? 'L' : 'H') |
        \     vertical resize 80 |
        \ endif
augroup END

" Refresh and reflow the man page text if its window is resized.
augroup ManPageRefreshOnResize
  autocmd!
  " Refresh and maintain position on window move/resize
  autocmd WinResized,WinEnter * if &ft == 'man' |
        \ let $MANWIDTH = (winwidth(0) > 120 ? 120 : winwidth(0)) |
        \ let save_view = winsaveview() |
        \ silent! call dist#man#GetPage('horizontal', '', expand('%:t:r')) |
        \ call winrestview(save_view) |
        \ endif
augroup END


" Map gO to :HelpToc specifically for help and man pages
packadd helptoc
augroup HelpTocMappings
  autocmd!
  autocmd FileType help nnoremap <buffer> gO :HelpToc<CR>
  autocmd FileType man  nnoremap <buffer> gO :HelpToc<CR>
augroup END


" context.vim plugin settings
let g:context_highlight_tag = '<hide>'


" EditorConfig plugin settings
let g:EditorConfig_exclude_patterns = [
      \ 'fugitive://.*',
      \ 'quickrun://.*',
      \ 'scp://.*'
      \ ]


" Mistfly Statusline plugin settings
set noshowmode
let g:mistflyWithSearchCount = v:true
let g:mistflyWithSpellStatus = v:true
let g:mistflyWithIndentStatus = v:true
let g:mistflyExcludePatterns = [
      \ 'fugitive://.*',
      \ 'jq-filter://.*',
      \ 'jq-output://.*',
      \ 'quickrun://.*',
      \ 'scp://.*',
      \ ]


" QuickRun plugin settings
nnoremap <silent> <Leader>r :QuickRun -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun -mode v<CR>
" No-op command to prevent accidental running of QuickRun
command! QuickRu :
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.python = { 'command': 'python3' }


" Source local changes
if filereadable(expand('~/.vimrc-local'))
  source ~/.vimrc-local
endif
