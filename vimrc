" Begin .vimrc
color hybrid

" Turn filetype plugin on
filetype on
filetype plugin on

" Make scrolling not rubbish
set ttyfast
set lazyredraw

set hlsearch
" Not compatible with vi
set nocompatible

" Tabs to spaces
set expandtab

" 4 spaces per tab, not 8
set tabstop=2

" Treat spaced tabs as normal tabs (i.e.: backspace deletes the 4 spaces)
set softtabstop=2

" Line numbers
set nu

" Auto indent and smart indent
set autoindent
set smartindent

" Colors
set t_Co=256

" Auto indent spaces per step
set shiftwidth=2

" Syntax highlighting
syntax on

" No swap files or backups
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
let g:vim_json_syntax_conceal = 0

" Incremental search
set incsearch

"""""""""""""""""""""""""""""""""""
" Remap increment/decrement keys. "
" """""""""""""""""""""""""""""""""""
nnoremap <C-Up> <C-a>
nnoremap <C-Down> <C-x>


""""""""""""""""""""
" Plugin settings. "
""""""""""""""""""""

"indentLines
let g:indentLine_color_term = 240
let g:indentLine_char = '┆'
""""""""""""""""""
" Auto commands. "
""""""""""""""""""
" Git commit overrides
" Make sure editing starts at first line
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
" Override stupid default text width
autocmd FileType gitcommit set tw=80
autocmd FileType gitcommit silent :setlocal spell spelllang=en_gb
autocmd FileType gitcommit silent call DisplayGitChanges()

" Compile LESS files on save
autocmd BufWritePost *.less execute '! if [ -f %:r.css ]; then type lessc && lessc % > %:r.css; fi'
" Lint XML on save
autocmd BufWritePost *.xml execute '!type xmllint &> /dev/null && if xmllint % &> /dev/null; then echo -e "\E[32m$3XML OK ✔\033[0m"; else echo -e "\E[31m$3XML invalid ✘\033[0m"; fi'
" Close gitchanges buffers
autocmd BufLeave * call CloseGitChanges()
""""""""""""""""""""
" Custom commands. "
" """"""""""""""""""
" Git blame current file
command! Wtf execute "!git blame %"
" Git history of current file
command! History execute "!git log -p -- % | vim -"
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
function! DisplayGitChanges()
  let changes = system("git diff --cached")
  bo vnew
  :silent! file gitchanges
  put=changes
  set syntax=diff
  :normal ggdd
  set nomodified
endfunction
command! -nargs=+ -complete=command DisplayGitChanges call DisplayGitChanges()

function! CloseGitChanges()
  if buflisted('gitchanges') != 0
    :bunload! gitchanges
    :exit
  endif
endfunction
command! -nargs=+ -complete=command CloseGitChanges call CloseGitChanges()

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

" Open mdn page
function! OpenMdnPage(page)
    execute '!' . '$BROWSER "http://www.google.com/search?q=mdn+' . a:page .'&btnI"'
endfunction
command! -nargs=+ -complete=command Mdn call OpenMdnPage(<q-args>)

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

" Display tag list
nmap <F7> :TlistToggle <CR>

" Toggle NERDTree
nmap <F12> :NERDTreeToggle <CR>

" Save (Ctrl+S)
nmap <C-s> :w<CR>
" Save (insert mode)
imap <C-s> <Esc>:w<CR>
" Save (visual mode)
vmap <C-s> <Esc>:w<CR>

" Comment/uncomment shortcut
imap <C-Right> <Esc>:Commentary<CR>
vmap <C-Right> <Esc>:'<,'>Commentary<CR>
nmap <C-Right> <Esc>:Commentary<CR>

" Select all
nmap <C-a> <Esc>gg <S-v><S-g><CR>

"""""""""""""""""""""
" Hex file editing. "
"""""""""""""""""""""

" Toggle hex mode keys
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Move the rest of the line contents to a newline
nnoremap go i<CR><Esc>
"""""""""""""""""""""""""
" Highlight long lines. "
"""""""""""""""""""""""""
function! HighlightLongLines()
    " Return if buffer variable set
    if exists('b:noHighlightLongLines')
        return
    endif
    " Add highlight group for 80+ column lines
    highlight LongLines ctermbg=52 ctermfg=188
    call matchadd('LongLines', '\%>80v.\+', -1)
    " Add highlight group for 120+ column lines
    highlight VeryLongLines ctermbg=124 ctermfg=188
    call matchadd('VeryLongLines', '\%>120v.\+', -1)
endfunction

" Set no highlight option for diff buffers
autocmd FileType git let b:noHighlightLongLines=1
" Call highlight long lines to add match groups for files without
" noHighlightLongLines set
autocmd BufWinEnter * call HighlightLongLines()
""""""""""""""""""""""""""
" Filetype autocommands. "
""""""""""""""""""""""""""
" Don't continue single line comments onto the next line
au FileType javascript setlocal comments-=:// comments+=f://
" When editing a commit message, make sure the cursor starts in the right place
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
" Wrap commit messages at 80 characters
autocmd FileType gitcommit set tw=80
" Always use 2 space tabs for assembly files
autocmd FileType asm set tabstop=2
autocmd FileType asm set softtabstop=2
autocmd FileType asm set shiftwidth=2
"""""""""""""""""""""""""""""
" Highlight comment @ tags. "
"""""""""""""""""""""""""""""
" Define highlight group
highlight Debug ctermbg=93 ctermfg=193
au BufWinEnter * call matchadd('Debug', '@DEBUG\|@TODO\|@fixme\c', -1)

highlight Hack ctermbg=124
au BufWinEnter * call matchadd('Hack', '@HACK\|@WITCHCRAFT\|@HURTALERT\c', -1)

highlight Deprecated ctermbg=57 ctermfg=159
au BufWinEnter * call matchadd('Deprecated', '@deprecated\c', -1)
"""""""""""""""""""""""""""""""""""""""""
" Command abbreviations (i.e. aliases). "
"""""""""""""""""""""""""""""""""""""""""
cabbrev hres vertical res
cabbrev vres res

" let g:syntastic_javascript_jshint_args = '--config /home/james/.jshintrc'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_javascript_checkers = ["eslint"]

"""""""""""""
" Pathogen. "
"""""""""""""
" Pathogen
execute pathogen#infect()
"call pathogen#helptags() " generate helptags for everything in 'runtimepath'
" End .vimrc
