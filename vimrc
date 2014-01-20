" Begin .vimrc
color xoria256

" Not compatible with vi
set nocompatible

" Tabs to spaces
set expandtab

" 4 spaces per tab, not 8
set tabstop=4

" Treat spaced tabs as normal tabs (i.e.: backspace deletes the 4 spaces)
set softtabstop=4

" Line numbers
set nu

" Auto indent and smart indent
set autoindent
set smartindent

" Auto indent spaces per step
set shiftwidth=4

" Syntax highlighting
syntax on

" No backups
set nobackup
" Set directory for swap files
set dir=~/tmp,/var/tmp,/tmp

" Enable modelines when root
set modeline

" Show command at bottom
set showcmd

" No wrapping of long lines
set nowrap

" Show matching brackets
set showmatch

" Backspace behaviour
set backspace=eol,start,indent

" Show filename in terminal title
set title

" Fix vim-airline plugin on startup
set laststatus=2
set noshowmode
set ttimeoutlen=50
let g:airline_powerline_fonts = 1

" Incremental search
set incsearch

" Turn filetype plugin on
filetype on
filetype plugin on

""""""""""""""""""""
" Plugin settings. "
""""""""""""""""""""

"indentLines
let g:indentLine_color_term = 240
let g:indentLine_char = '┆'

"""""""""""
" Macros. "
"""""""""""
" Comment and uncomment line
let comment_string = "//"
let @c='0|i'.comment_string.''
let @u=':s/\/\///:noh'
" Insert semi colon at EOL
let @s='iOF;'
" Console log
let @l='iconsole.log();ODOD'
let @f='<80>kh/var<80>kr<80>kr<80>kr<80>krvy<80>kri = 0; p<80>kri <<80>kD<80>kD<80>kD/)i.length; p<80>kri++'
""""""""""""""""""
" Auto commands. "
""""""""""""""""""
" Git commit overrides
" Make sure editing starts at first line
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
" Override stupid default text width
autocmd FileType gitcommit set tw=200
" Compile LESS files on save
autocmd BufWritePost *.less execute '!type lessc && lessc % > %:r.css'
""""""""""""""""""""
" Custom commands. "
" """"""""""""""""""
" Git blame current file
command! Wtf execute "!git blame %"
"""""""""""""""""
" Highlighting. "
"""""""""""""""""
" Highlight trailing EOL white space
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
""""""""""""""
" Functions. "
""""""""""""""
" Display git commit for revision
function! DisplayGitCommit(revision)
  let commit = system("git show ".a:revision)
  tabnew
  put=commit
  set syntax=diff
  :normal ggdd
  set nomodified
endfunction
command! -nargs=+ -complete=command DisplayGitCommit call DisplayGitCommit(<q-args>)
"""""""""""""""""
" Key mappings. "
" """""""""""""""
" Switch between splits
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Vertically split open file under cursor
nmap <F9> :botright vertical wincmd f<CR>

" Show revision under cursor in new tab
nmap <F8> :DisplayGitCommit <c-r><c-w><cr>

" Save (Ctrl+S)
nmap <C-s> :w<CR>
" Save (insert mode)
imap <C-s> <Esc>:w<CR>
" Save (visual mode)
vmap <C-s> <Esc>:w<CR>

" Comment/uncomment shortcut
imap <C-Right> <Esc>:norm @c<CR>
vmap <C-Right> <Esc>:'<,'>norm @c<CR>
nmap <C-Right> <Esc>:norm @c<CR>
imap <C-Left> <Esc>:norm @u<CR>
vmap <C-Left> <Esc>:'<,'>norm @u<CR>
nmap <C-Left> <Esc>:norm @u<CR>

" Select all
nmap <C-a> <Esc>gg <S-v><S-g><CR>
""""""""""""""""""""""""""
" Add and remove quotes. "
""""""""""""""""""""""""""
" `qs` Quote with singles
nnoremap qs :silent! normal mpea'<Esc>bi'<Esc>`pl
" `qd` Quote with doubles
nnoremap qd :silent! normal mpea"<Esc>bi"<Esc>`pl
" `rq` Remove quotes from a word
nnoremap rq :silent! normal mpeld bhd `ph<CR>
"""""""""""""""""""""""""
" Highlight long lines. "
"""""""""""""""""""""""""
function! HighlightLongLines()
    " Return if buffer variable set
    if exists('b:noHighlightLongLines')
        return
    endif
    " Add highlight group for 80+ column lines
    highlight LongLines ctermbg=167 ctermfg=188
    call matchadd('LongLines', '\%>80v.\+', -1)
    " Add highlight group for 120+ column lines
    highlight VeryLongLines ctermbg=124 ctermfg=188
    call matchadd('VeryLongLines', '\%>120v.\+', -1)
endfunction

" Set no highlight option for diff buffers
autocmd FileType diff let b:noHighlightLongLines=1
" Call highlight long lines to add match groups for files without
" noHighlightLongLines set
autocmd BufWinEnter * call HighlightLongLines()
"""""""""""""""""""""""""""""
" Highlight comment @ tags. "
"""""""""""""""""""""""""""""
" Define highlight group
highlight Debug ctermbg=93 ctermfg=193
au BufWinEnter * call matchadd('Debug', '@DEBUG\|@TODO\|@fixme\c', -1)

highlight Hack ctermbg=124
au BufWinEnter * call matchadd('Hack', '@HACK\|@WITCHCRAFT\|@HURTALERT\c', -1)
"""""""""""""""""""""""""""""""""""""""""
" Command abbreviations (i.e. aliases). "
"""""""""""""""""""""""""""""""""""""""""
cabbrev hres vertical res
cabbrev vres res
"""""""""""""
" Pathogen. "
"""""""""""""
" Pathogen
execute pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
" End .vimrc
