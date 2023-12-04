setlocal keywordprg=ansible-doc
setlocal iskeyword+=46

let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1

let b:ale_yaml_yamllint_options='-c '.$HOME.'/.config/yamllint/config.ansible.yml'
