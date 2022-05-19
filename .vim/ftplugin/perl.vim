let b:vimpipe_command='perl'

"let perl_include_pod   = 1   " Include pod.vim syntax file with perl.vim
let perl_extended_vars = 1   " Highlight complex expressions such as @{[$x, $y]}
let perl_sync_dist     = 250 " Use more context for highlighting
let perl_fold=1
let perl_nofold_packages=1
let perl_nofold_subs=1

" Deparse code
nnoremap <silent> <localleader>D :.!perl -MO=Deparse 2>/dev/null<CR>
vnoremap <silent> <localleader>D :!perl -MO=Deparse 2>/dev/null<CR>

" Define :PerlTidy command to run perltidy on a visual selection or
" the entire buffer.
command! -range=% -nargs=* PerlTidy <line1>,<line2>!perltidy -q

" Run :PerlTidy on entire buffer and return cursor to the approximate
" original position.
function! DoPerlTidy() abort
  let l = line('.')
  let c = col('.')
  :PerlTidy
  call cursor(l, c)
endfun

nnoremap <localleader>pt :call DoPerlTidy()<CR>
vnoremap <localleader>pt :PerlTidy<CR>
"nnoremap <localleader>pt :%!perltidy -q<CR>
"vnoremap <localleader>pt :!perltidy -q<CR>

" The following function will allow you to set your cursor over a Perl module
" name in the file that you are currently editing and type \pm to open the
" corresponding source file in a new buffer.
nnoremap <localleader>pm :call LoadPerlModule()<CR>
function! LoadPerlModule() abort
  execute 'e `perldoc -l ' . expand('<cWORD>') . '`'
endfunction

compiler perl
