setlocal foldmethod=syntax
execute feedkeys('zR')

if executable('jq')
  setlocal formatprg=jq\ .
elseif executable('python3')
  setlocal formatprg=python3\ -m\ json.tool\ --no-ensure-ascii\ --indent\ 2
endif
