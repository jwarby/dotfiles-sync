" Open mdn page for keyword
function! OpenMdnPage(keyword)
    execute "silent !sensible-browser 'http://www.google.com/search?btnI&q=mdn+'" . a:keyword . ">/dev/null 2>&1"
    :silent !wmctrl -a Google Chrome
    redraw!
endfunction
command! -nargs=+ -complete=command OpenMdnPage call OpenMdnPage(<q-args>)

nnoremap <F7> :OpenMdnPage <c-r><c-w><cr>
