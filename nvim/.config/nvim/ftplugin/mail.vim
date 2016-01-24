" ftplugin/mail.vim
function IsReply()
    if line('$') > 1
        :1
        :put! =\"\n\n\"
        :1
	:exe 'startinsert'
    endif
endfunction

augroup mail_filetype
    autocmd!
    autocmd! VimEnter /tmp/mutt* :call IsReply()
augroup END

setl tw=72
setl fo=aw
