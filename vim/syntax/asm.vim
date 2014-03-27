" Vim syntax file
" Language:	NESASM (NES Assembler 6502)
" Maintainer:	James Warwood <james.duncan.1991@googlemail.com>
" Last Change:	2014 Feb 11

" For version 5.x: Clear all syntax items
" For version 6.0 and later: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

" storage types
syn match asmType "\.dw"
syn match asmType "\.org"
syn match asmType "\.rs"
syn match asmType "\.rsset"
syn match asmType "\.bank"
syn match asmType "\.db"

syn match asmLabel		"[a-z_][a-z0-9_]*:"he=e-1
syn match asmIdentifier		"[a-z_][a-z0-9_]*"

" Numbers, hex, binary or constant:
syn match asmSection	"#\{0,1\}$[0-9a-fA-F]\+"
syn match asmSection "#\{0,1\}%[0-1]\{8\}"
syn match asmSection "#[A-Z_]\+"

syn keyword asmTodo		contained TODO

" Comments are semi-colon (;) delimited
syn match asmComment		"[;].*" contains=asmTodo

syn match asmInclude		"\.incbin"

syn match asmDirective "\.inesprg"
syn match asmDirective "\.ineschr"
syn match asmDirective "\.inesmir"
syn match asmDirective "\.inesmap"

" Load/transfer ops
syn match asmDirective "LDA"
syn match asmDirective "LDY"
syn match asmDirective "LDX"
syn match asmDirective "TAX"
syn match asmDirective "TAY"
syn match asmDirective "TXA"
syn match asmDirective "TYA"
syn match asmDirective "TSX"
syn match asmDirective "TXS"

" Arithmetic & logic ops
syn match hexNumber "CLC"
syn match hexNumber "ADC"
syn match hexNumber "SEC"
syn match hexNumber "SBC"
syn match hexNumber "AND"
syn match hexNumber "EOR"
syn match hexNumber "ORA"
syn match hexNumber "NOT"
syn match hexNumber "BIT"
syn match hexNumber "DEC"
syn match hexNumber "DEX"
syn match hexNumber "DEY"
syn match hexNumber "INC"
syn match hexNumber "INX"
syn match hexNumber "INY"
syn match hexNumber "ROR"
syn match hexNumber "ROL"
syn match hexNumber "ASL"
syn match hexNumber "LSR"

" Compare
syn match asmSection "CMP"
syn match asmSection "CPX"
syn match asmSection "CPY"

" Store ops (normal)

" Branch ops
syn match asmInclude "BEQ"
syn match asmInclude "BNE"
syn match asmInclude "BPL"
syn match asmInclude "BMI"
syn match asmInclude "BCC"
syn match asmInclude "BCS"
syn match asmInclude "BVC"
syn match asmInclude "BVS"
syn match asmInclude "JSR"
syn match asmInclude "JMP"
syn match asmInclude "RTS"
syn match asmInclude "RTI"

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_asm_syntax_inits")
  if version < 508
    let did_asm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink asmSection	Special
  HiLink asmLabel	Label
  HiLink asmComment	Comment
  HiLink asmTodo	Todo
  HiLink asmDirective	Statement

  HiLink asmInclude	Include
  HiLink asmCond	PreCondit
  HiLink asmMacro	Macro

  HiLink hexNumber	Number
  HiLink decNumber	Number
  HiLink octNumber	Number
  HiLink binNumber	Number

  HiLink asmIdentifier	Identifier
  HiLink asmType	Type
  HiLink asmNormal Normal

  delcommand HiLink
endif

let b:current_syntax = "asm"

let &cpo = s:cpo_save
unlet s:cpo_save
