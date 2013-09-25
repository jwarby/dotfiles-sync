" EJS
" " Language:	EJS
" Maintainer:	James Warwood <james.duncan.1991@googlemail.com>
" Version:	2
" Last Change:  Jul 9th 2013
" Remark:
"  Lexical highlighting for ejs delimiters
" References:
" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Standard HiLink will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax region ejsVariable matchgroup=ejsMarker start='<%=' end='%>' containedin=@htmlEjsContainer
syntax region ejsVariableUnescape matchgroup=ejsMarker start='<%==' end='%>' containedin=@htmlEjsContainer
syntax region ejsString matchgroup=ejsMarker start="'\|\"" end="'\|\"" containedin=@ejsInside
syntax region ejsMarkerSet matchgroup=ejsMarker start='<%[=]*' end='%>'

" Clustering
syntax cluster ejsInside add=ejsVariable,ejsVariableUnescape,ejsMarkerSet
syntax cluster htmlEjsContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlLink,htmlBold,htmlUnderline,htmlItalic

" Hilighting
" mustacheInside hilighted as Number, which is rarely used in html
" you might like change it to Function or Identifier
HtmlHiLink ejsVariable PreProc
HtmlHiLink ejsVariableUnescape PreProc
HtmlHiLink ejsMarkerSet PreProc
HtmlHiLink ejsString String

let b:current_syntax = "ejs"
delcommand HtmlHiLink
