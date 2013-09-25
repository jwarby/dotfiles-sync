" Begin ~/.vim/filetype.vim
" Contains additional file extension to file type mappings so
" that correct syntax highlighting is used.

" Check if the filetype was already detected
if exists("did_load_filetypes")
    finish
endif

" Otherwise check if we have a custom mapping
augroup filetypedetect
    au! BufRead,BufNewFile *.bash_*     setfiletype sh
    au! BufRead,BufNewFile *.less     setfiletype css
    au! BufRead,BufNewFile *.html setfiletype mustache
    au! BufRead,BufNewFile *.ejs setfiletype javascript.html
    au! BufRead,BufNewFile *.ejs set syn=ejs
    au! BufRead,BufNewFile *.handlebars set filetype=mustache
    au! FileType git,diff setlocal modified!
augroup END

" End ~/.vim/filetype.vim
