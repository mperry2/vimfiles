setlocal foldmethod=syntax
execute feedkeys('zR')

if executable('jq')
  setlocal equalprg=jq\ .
elseif executable('python3')
  setlocal equalprg=python3\ -m\ json.tool\ --no-ensure-ascii\ --indent\ 2
endif
