" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufRead /usr/local/nagios/etc/*.cfg                setf nagios
autocmd BufNewFile,BufRead /*etc/nagios/*.cfg                         setf nagios
autocmd BufNewFile,BufRead *sample-config/template-object/*.cfg{,.in} setf nagios
autocmd BufNewFile,BufRead /var/lib/nagios/objects.cache              setf nagios
