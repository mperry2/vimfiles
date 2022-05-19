" Normally this if-block is not needed, because `:set nocp` is done
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
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

  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('dense-analysis/ale')
  call minpac#add('editorconfig/editorconfig-vim')
  call minpac#add('hashivim/vim-terraform')
  call minpac#add('krisajenkins/vim-pipe')
  call minpac#add('pearofducks/ansible-vim')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-sensible')
endfunction


" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

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



" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']


scriptencoding utf-8



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! MyHighlights() abort
  highlight! link SignColumn LineNr
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme * call MyHighlights()
augroup END


colorscheme default
set background=dark  " I always work on dark terminals


if has("gui_running")
  "set guioptions-=m         " Remove menu bar
  "set guioptions-=T         " Remove toolbar
  "set guioptions-=r         " Remove right-hand scroll bar
  set guicursor=a:blinkon0  " Disable blinking cursor
  set guifont=DejaVu_Sans_Mono:h12,Lucida_Console:h12,Fixedsys:h9
  colorscheme xoria256

  if has("win32")
    " Maximize the initial Vim window under MS Windows
    augroup ms_windows
      autocmd!
      autocmd GUIEnter * simalt ~x
      autocmd GUIEnter * set number
    augroup END
  endif
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Statusline that matches the default when 'ruler' is set but includes
" %{fugitive#statusline()}
if exists('g:loaded_fugitive')
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set modeline

set softtabstop=2
set shiftwidth=2   " Indentation to use for auto-indent/un-indent
set expandtab

set nojoinspaces   " Insert one space (not two) after joined lines

set ignorecase
set smartcase
set hlsearch

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:¬

" Show line numbers if terminal width is at least 88 characters
if &columns >= 88
  set number
endif


" Use F2 to toggle paste mode
set pastetoggle=<F2>

" Toggle Tagbar window
nmap <F8> :TagbarToggle<CR>

" Use F11 to toggle display of unprintable characters
nnoremap <F11> :set nolist! list?<CR>

" Use F12 to toggle line numbering
nnoremap <F12> :set nonumber! number?<CR>


"set foldmethod=syntax
"set foldlevelstart=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Perl settings
augroup perl
  autocmd!
  autocmd BufRead,BufNewFile *.tt setfiletype html
augroup END



" Nagios settings
augroup nagios
  autocmd!
  autocmd BufNewFile,BufRead /usr/local/nagios/etc/*.cfg,/*etc/nagios/*.cfg,*sample-config/template-object/*.cfg{,.in},/var/lib/nagios/objects.cache set filetype=nagios
  autocmd FileType nagios setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
  autocmd FileType nagios setlocal autowrite
  autocmd FileType nagios compiler nagios
augroup END


" Ansible
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
augroup ansible
  autocmd!
  au BufRead,BufNewFile */playbooks/*.yml,*/ansible/*.yml set filetype=yaml.ansible
  au BufRead,BufNewFile */playbooks/*.yml,*/ansible/*.yml let b:ale_yaml_yamllint_options='-c '.$HOME.'/.config/yamllint/config.ansible.yml'
augroup END
