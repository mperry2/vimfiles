set nocompatible
scriptencoding utf-8

" Make Windows use ~/.vim too. I don't want to use _vimfiles
if has('win32') || has('win64')
    set runtimepath^=~/.vim
endif

" Set up Pathogen and load all packages in ~/.vim/bundle
execute pathogen#infect()

"filetype plugin indent on

"syntax on        " Turn on syntax highlighting
hi! link SignColumn LineNr

"colorscheme mayansmoke
colorscheme default
set background=dark  " I always work on dark terminals

" Show line numbers if terminal width is at least 88 characters
if &columns >= 88
    set number
endif

set nojoinspaces   " Insert one space (not two) after joined lines
set expandtab      " Insert tabs as spaces
set tabstop=4
set shiftwidth=4   " Indentation to use for auto-indent/un-indent

set hlsearch

" Statusline that matches the default when 'ruler' is set but includes
" %{fugitive#statusline()}
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:¬


if has("gui_running")
    "set guioptions-=m         " Remove menu bar
    "set guioptions-=T         " Remove toolbar
    "set guioptions-=r         " Remove right-hand scroll bar
    set guicursor=a:blinkon0  " Disable blinking cursor
    set guifont=DejaVu_Sans_Mono:h12,Lucida_Console:h12,Fixedsys:h9
    colorscheme xoria256

    if has("win32")
        " Maximize the initial Vim window under MS Windows
        au GUIEnter * simalt ~x
        au GUIEnter * set number
    endif
endif

" Source .vimrc or .gvimrc if it's written from Vim. This will let any changes
" take effect immediately.
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END


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


" Syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Use tabs at 8 chars in makefiles
au FileType make setlocal noexpandtab tabstop=8 shiftwidth=8



"
" JavaScript settings
"
au BufNewFile,BufReadPost *.json setlocal filetype=javascript.json



"
" Perl settings
"
au BufRead,BufNewFile *.tt setfiletype html

au FileType perl compiler perl
"let perl_include_pod   = 1   " Include pod.vim syntax file with perl.vim
let perl_extended_vars = 1   " Highlight complex expressions such as @{[$x, $y]}
let perl_sync_dist     = 250 " Use more context for highlighting

let perl_fold=1
let perl_nofold_packages=1
let perl_nofold_subs=1


"define :PerlTidy command to run perltidy on visual selection || entire buffer
command! -range=% -nargs=* PerlTidy <line1>,<line2>!perltidy -q

"run :PerlTidy on entire buffer and return cursor to (approximate) original position
function! DoPerlTidy()
    let l = line(".")
    let c = col(".")
    :PerlTidy
    call cursor(l, c)
endfun

au Filetype perl nnoremap <localleader>pt :call DoPerlTidy()<CR>
au Filetype perl vnoremap <localleader>pt :PerlTidy<CR>

"au FileType perl nnoremap <localleader>pt :%!perltidy -q<CR>
"au FileType perl vnoremap <localleader>pt :!perltidy -q<CR>


" The following function will allow you to set your cursor over a Perl module
" name in the file that you are currently editing and type \pm to open the
" corresponding source file in a new buffer. 
au FileType perl nnoremap <localleader>pm :call LoadPerlModule()<CR>
function! LoadPerlModule()
    execute 'e `perldoc -l ' . expand("<cWORD>") . '`'
endfunction

" Deparse code
au Filetype perl nnoremap <silent> <localleader>D :.!perl -MO=Deparse 2>/dev/null<CR>
au Filetype perl vnoremap <silent> <localleader>D :!perl -MO=Deparse 2>/dev/null<CR>



"
" Nagios settings
"
au BufNewFile,BufRead /usr/local/nagios/etc/*.cfg,/*etc/nagios/*.cfg,*sample-config/template-object/*.cfg{,.in},/var/lib/nagios/objects.cache set filetype=nagios

au FileType nagios setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
au FileType nagios setlocal autowrite
au FileType nagios compiler nagios
