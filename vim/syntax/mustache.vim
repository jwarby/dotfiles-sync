" Mustache & Handlebars syntax
" Language:	Mustache, Handlebars
" Maintainer:	Juvenn Woo <machese@gmail.com>
" Screenshot:   http://imgur.com/6F408
" Version:	2
" Last Change:  Mar 24th 2013
" Remark:
"   It lexically hilights embedded mustaches (exclusively) in html file.
"   While it was written for Ruby-based Mustache template system, it should
"   work for Google's C-based *ctemplate* as well as Erlang-based *et*. All
"   of them are, AFAIK, based on the idea of ctemplate.
" References:
"   [Mustache](http://github.com/defunkt/mustache)
"   [Handlebars](https://github.com/wycats/handlebars.js)
"   [ctemplate](http://code.google.com/p/google-ctemplate/)
"   [ctemplate doc](http://google-ctemplate.googlecode.com/svn/trunk/doc/howto.html)
"   [et](http://www.ivan.fomichev.name/2008/05/erlang-template-engine-prototype.html)
" TODO: Feedback is welcomed.


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

syntax match mustacheError '}}}\?'
syntax match mustacheInsideError '{{[{#<>=!\/]\?' containedin=@mustacheInside
syntax region mustacheVariable matchgroup=mustacheMarker start=/{{/ end=/}}/ containedin=@htmlMustacheContainer
syntax region mustacheVariableUnescape matchgroup=mustacheMarker start=/{{{/ end=/}}}/ containedin=@htmlMustacheContainer
"syntax region mustacheSection matchgroup=mustacheMarker start='{{[#/]' end=/}}/ containedin=@htmlMustacheContainer
syntax region mustachePartial matchgroup=mustacheMarker start=/{{[<>]/ end=/}}/
syntax region mustacheMarkerSet matchgroup=mustacheMarker start=/{{=/ end=/=}}/
syntax region mustacheComment start=/{{!/ end=/}}/ contains=Todo containedin=htmlHead
syntax match customHandlebarsOperator /[#/][a-zA-Z]*/ containedin=@mustacheInside
syntax match handlebarsOperator /[#/]\(if\|unless\|with\|each\)/ containedin=@mustacheInside


" Clustering
syntax cluster mustacheInside add=mustacheVariable,mustacheVariableUnescape,mustacheSection,mustachePartial,mustacheMarkerSet
syntax cluster htmlMustacheContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlLink,htmlBold,htmlUnderline,htmlItalic

" Hilighting
" mustacheInside hilighted as Number, which is rarely used in html
" you might like change it to Function or Identifier
HtmlHiLink mustacheVariable Number
HtmlHiLink mustacheVariableUnescape Number
HtmlHiLink mustachePartial Normal
HtmlHiLink mustacheSection Number
HtmlHiLink mustacheMarkerSet Number
HtmlHiLink customHandlebarsOperator diffAddedBright
HtmlHiLink handlebarsOperator PreProc

HtmlHiLink mustacheComment Comment
HtmlHiLink mustacheMarker Special
HtmlHiLink mustacheError Error
HtmlHiLink mustacheInsideError Error

syn region mustacheScriptTemplate start=+<script [^>]*type *=[^>]*text/mustache[^>]*>+
\                       end=+</script>+me=s-1 keepend
\                       contains=mustacheError,mustacheInsideError,mustacheVariable,mustacheVariableUnescape,mustacheSection,mustachePartial,mustacheMarkerSet,mustacheComment,htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlTag,htmlEndTag,htmlTagName,htmlSpecialChar,htmlLink,htmlBold,htmlUnderline,htmlItalic

let b:current_syntax = "mustache"
delcommand HtmlHiLink
