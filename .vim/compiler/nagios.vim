" Vim Compiler File
" Compiler:     Nagios syntax checks (nagios -v)
" Maintainer:   Matt Perry <matt@mattperry.com>
" Last Change:  2011 Jan 26

if exists("current_compiler")
  finish
endif
let current_compiler = "nagios"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" Clear errorformat
let s:nagiosErrFmt  = ''

let s:nagiosErrFmt .= "%tarning: %m (config file \'%f\'\\, %.%# %l)" . ','

let s:nagiosErrFmt .= "%trror: %m in file '%f' on line %l." . ','

let s:nagiosErrFmt .= "%trror: %m (config file \'%f\'\\, %.%# %l)" . ','

let s:nagiosErrFmt .= "%CError: %m in file '%f' on line %l." . ','
let s:nagiosErrFmt .= '%EError: %m' . ','

" Get rid of non-matching lines
let s:nagiosErrFmt .= '%-G%.%#'

"let s:nagiosErrFmt  = '%m'

CompilerSet makeprg=nagios\ -v\ nagios.cfg
CompilerSet errorformat=$s:nagiosErrFmt

