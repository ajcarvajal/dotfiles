hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "photon"

hi Normal ctermbg=234 ctermfg=251 cterm=NONE 
	

set background=dark

hi NonText ctermbg=NONE ctermfg=237 cterm=NONE 
hi Comment ctermbg=NONE ctermfg=102 cterm=NONE 
hi Constant ctermbg=NONE ctermfg=181 cterm=NONE 
hi String ctermbg=NONE ctermfg=180 cterm=NONE
hi Identifier ctermbg=NONE ctermfg=251 cterm=NONE 
hi Statement ctermbg=NONE ctermfg=138 cterm=NONE
hi Operator ctermbg=NONE ctermfg=251 cterm=bold 
hi PreProc ctermbg=NONE ctermfg=253 cterm=NONE 
hi Type ctermbg=NONE ctermfg=103 cterm=NONE 
hi Boolean ctermbg=NONE ctermfg=131 cterm=NONE
hi Function ctermbg=NONE ctermfg=109 cterm=NONE
hi Special ctermbg=NONE ctermfg=243 cterm=NONE 
hi Error ctermbg=NONE ctermfg=132 cterm=NONE 
hi Warning ctermbg=NONE ctermfg=136 cterm=NONE 
hi ModeMsg ctermbg=NONE ctermfg=243 cterm=NONE 
hi Todo ctermbg=NONE ctermfg=167 cterm=bold 
hi Underlined ctermbg=NONE ctermfg=251 cterm=underline 
hi StatusLine ctermbg=237 ctermfg=140 cterm=NONE 
hi StatusLineNC ctermbg=236 ctermfg=243 cterm=NONE 
hi WildMenu ctermbg=236 ctermfg=167 cterm=NONE 
hi VertSplit ctermbg=236 ctermfg=236 cterm=NONE 
hi Title ctermbg=NONE ctermfg=243 cterm=bold 
hi LineNr ctermbg=NONE ctermfg=241 cterm=NONE 
hi CursorLineNr ctermbg=236 ctermfg=140 cterm=NONE 
hi Cursor ctermbg=140 ctermfg=251 cterm=NONE 
hi CursorLine ctermbg=236 ctermfg=NONE cterm=NONE 
hi ColorColumn ctermbg=234 ctermfg=NONE cterm=NONE 
hi SignColumn ctermbg=NONE ctermfg=243 cterm=NONE 
hi Visual ctermbg=237 ctermfg=NONE cterm=NONE 
hi VisualNOS ctermbg=238 ctermfg=NONE cterm=NONE 
hi Pmenu ctermbg=237 ctermfg=NONE cterm=NONE 
hi PmenuSbar ctermbg=236 ctermfg=NONE cterm=NONE 
hi PmenuSel ctermbg=236 ctermfg=140 cterm=NONE 
hi PmenuThumb ctermbg=167 ctermfg=NONE cterm=NONE 
hi FoldColumn ctermbg=NONE ctermfg=241 cterm=NONE 
hi Folded ctermbg=234 ctermfg=243 cterm=NONE 
hi SpecialKey ctermbg=NONE ctermfg=243 cterm=NONE 
hi IncSearch ctermbg=167 ctermfg=235 cterm=NONE 
hi Search ctermbg=140 ctermfg=235 cterm=NONE 
hi Directory ctermbg=NONE ctermfg=140 cterm=NONE 
hi MatchParen ctermbg=NONE ctermfg=167 cterm=bold 
hi SpellBad ctermbg=NONE ctermfg=132 cterm=underline 
hi SpellCap ctermbg=NONE ctermfg=108 cterm=underline 
hi SpellLocal ctermbg=NONE ctermfg=68 cterm=underline 
hi SpellRare ctermbg=NONE ctermfg=136 cterm=underline 
hi QuickFixLine ctermbg=234 ctermfg=NONE cterm=NONE 
hi DiffAdd ctermbg=NONE ctermfg=108 cterm=NONE 
hi DiffChange ctermbg=NONE ctermfg=136 cterm=NONE 
hi DiffDelete ctermbg=NONE ctermfg=132 cterm=NONE 
hi DiffText ctermbg=NONE ctermfg=167 cterm=NONE 

hi! link Character Constant
hi! link Number Constant
hi! link Float Number
"hi! link Boolean Constant
"hi! link Function Identifier
hi! link Conditonal Statement
hi! link Repeat Statement
hi! link Label Statement
hi! link Keyword Statement
hi! link Exception Statement
hi! link Include PreProc
hi! link Define PreProc
hi! link Macro PreProc
hi! link PreCondit PreProc
hi! link StorageClass Type
hi! link Structure Type
hi! link Typedef Type
hi! link SpecialChar Special
hi! link Tag Special
hi! link Delimiter Special
hi! link SpecialComment Special
hi! link Debug Special
hi! link ErrorMsg Error
hi! link WarningMsg Warning
hi! link MoreMsg ModeMsg
hi! link Question ModeMsg
hi! link Ignore NonText
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLine StatusLineNC
hi! link TabLineFill StatusLineNC
hi! link TabLineSel StatusLine
hi! link CursorColumn CursorLine
hi! link diffAdded DiffAdd
hi! link diffRemoved DiffDelete


