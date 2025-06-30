setlocal foldmethod=syntax
setlocal foldlevel=99
setlocal nofoldenable

if executable('jq')
  setlocal formatprg=jq\ .
elseif executable('python3')
  setlocal formatprg=python3\ -m\ json.tool\ --no-ensure-ascii\ --indent\ 2
endif
