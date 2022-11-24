;/---------------
;| IDE-Tool
;| Smart Indentation
;|
;| (c)HeX0R 2007-2022
;|
;| V1.19 (09.04.2022)
;|
;| Tool Settings in PB:
;| http://www.purebasic.fr/german/viewtopic.php?p=162665#p162665
;| https://hex0rs.coderbu.de/cgi-bin/hv.cgi?version=-1&id=112&ia=1071
;|
;| optional parameters
;| -rmempty              [-re]  => will remove whitespaces from empty lines
;| -nobackup             [-nb]  => will not use backup functionality
;| -noequalalign         [-ne]  => will not align the = characters
;| -nodbspacerem         [-nds] => will not remove multi occurances of spaces
;|
;/---------------
; ----------------------------------------------------------------------------
; "THE BEER-WARE LICENSE":
; <HeX0R@coderbu.de> wrote this file. as long as you retain this notice you
; can do whatever you want with this stuff. If we meet some day, and you think
; this stuff is worth it, you can buy me a beer in return
; (see address on https://hex0rs.coderbu.de/).
; Or just go out and drink a few on your own/with your friends ;)
;=============================================================================


EnableExplicit

#MAX_BACKUPS = 5        ;use 0 to deactivate backup functionality or -nobackup program parameter
#FIX_PB_BUG  = #True    ;PB Bug => https://www.purebasic.fr/english/viewtopic.php?p=581265#p581265
#CharSize    = SizeOf(Character)

EnumerationBinary
	#Option_RemoveWhiteSpacesInEmptyLines
	#Option_NoBackup
	#Option_NoEqualAlignment
	#Option_AltContinuedLine
	#Option_DontRemoveDoubleSpaces
EndEnumeration

Structure _TAGS_
	Before.i
	After.i
EndStructure

Structure _CHAR_ARRAY_
	c.c[0]
EndStructure

Global NewMap Tags._TAGS_()
Global NewList Lines$()
Global MyTab$, GlobalFlags, Backups
Global PB_Keywords$      ;Keywords which support line continuation

PB_Keywords$ = "|align|break|debug|define|dim|case|compilercase|compilerelseif|compilererror|compilerif|compilerwarning"
PB_Keywords$ + "|debug|debuglevel|elseif|end|enumeration|enumerationbinary|global|if|import|importc|includebinary"
PB_Keywords$ + "|includefile|includepath|newlist|newmap|protected|select|shared|static|step|threaded|until|while"
PB_Keywords$ + "|xincludefile|"       ;'data' and 'to' are handled separately

Macro M_HandleDQUOTES   ;Macro to find strings and escaped strings
	If *C\c = '~'
		If DQ = 0
			*Cnext = *C + #CharSize
			If *Cnext\c = '"'
				escaped = 1
				DQ      = 1
				*C      = *Cnext
			EndIf
		EndIf
	ElseIf *C\c = '\' And DQ And escaped
		*Cnext = *C + #CharSize
		If *Cnext\c = '"'
			*C = *Cnext
		EndIf
	ElseIf *C\c = '"'
		DQ ! 1
		If DQ = 0
			escaped = 0
		EndIf
	EndIf
EndMacro

Procedure.s AddTabs(Tabs, Indent$)
	ProcedureReturn RSet("", Tabs * Len(Indent$), Left(Indent$, 1))
EndProcedure

Procedure IsValidCharacter(c.c)
	
	Select c
		Case 'a' To 'z', 'A' To 'Z', '_'
			ProcedureReturn #True
	EndSelect
	
	ProcedureReturn #False
EndProcedure

Procedure.s GetIndent(*C.CHARACTER)                 ;get the indentation part of an existing line
	Protected Result$
	
	While *C\c And (*C\c = ' ' Or *C\c = #TAB)
		Result$ + Chr(*C\c)
		*C + #CharSize
	Wend
	
	ProcedureReturn Result$
EndProcedure

Procedure FindContinueToken(*C.Character, *Start)   ;check if at the end of the line is a continuation token (whitespaces are removed already)
	Protected *CA._CHAR_ARRAY_ = *Start
	Protected Pos = (*C - *Start) / #CharSize
	Protected Result = -1
	
	If *CA\c[Pos] = ','
		Result = 0
	ElseIf *CA\c[Pos] = '+' Or *CA\c[Pos] = '|'
		Result = 1
	ElseIf Pos > 1 And (*CA\c[Pos] = 'r' Or *CA\c[Pos] = 'R') And (*CA\c[Pos - 1] = 'o' Or *CA\c[Pos - 1] = 'O')
		If *CA\c[Pos - 2] = ' '
			Result = 2
		ElseIf Pos > 2 And (*CA\c[Pos - 2] = 'x' Or *CA\c[Pos - 2] = 'X') And *CA\c[Pos - 3] = ' '
			Result = 2
		EndIf
	ElseIf Pos > 2 And (*CA\c[Pos] = 'd' Or *CA\c[Pos] = 'D') And (*CA\c[Pos - 1] = 'n' Or *CA\c[Pos - 1] = 'N') And
	       (*CA\c[Pos - 2] = 'a' Or *CA\c[Pos - 2] = 'A') And *CA\c[Pos - 3] = ' '
		Result = 2
	EndIf
	
	ProcedureReturn Result
EndProcedure

;from the IDE (slightly changed): https://github.com/fantaisie-software/purebasic/blob/afa069a5ed304204963ba1e8ffd2714c1dad61bd/PureBasicIDE/ScintillaHighlighting.pb#L1464
Procedure.s GetIndentContinuationPrefix(PreviousLine$)
	Protected *C.Character, *Start, Token, Brackets, *ExpressionStart.Character
	Protected *WordEnd, *WordStart.Character, Word$, Prefix$, *LineStart.Character
	
	; Use this for a simple "block mode" indentation
	
	; the code below assumes a non-empty string
	If PreviousLine$ = ""
		ProcedureReturn ""
	EndIf
	
	; first block out any comments, as they cannot be read
	; backward. further, replace Strings or char constants
	; by 'a' to mark them as a token so we can later ignore them
	*C = @PreviousLine$
	Repeat
		Select *C\c
				
			Case 0
				Break
				
			Case '"'
				*C\c = 'a'
				*C + #CharSize
				While *C\c And *C\c <> '"' And *C\c <> #LF
					*C\c = 'a'
					*C + #CharSize
				Wend
				If *C\c = '"'
					*C\c = 'a'
					*C + #CharSize
				EndIf
				
			Case '~'
				If PeekC(*C + #CharSize) = '"'
					*C\c = 'a'
					*C + #CharSize
					*C\c = 'a'
					*C + #CharSize
					While *C\c And *C\c <> '"' And *C\c <> #LF
						If *C\c = '\' And PeekC(*C + #CharSize) <> 0 And PeekC(*C + #CharSize) <> #LF
							*C\c = 'a'
							*C + #CharSize
							*C\c = 'a'
							*C + #CharSize
						Else
							*C\c = 'a'
							*C + #CharSize
						EndIf
					Wend
					If *C\c = '"'
						*C\c = 'a'
						*C + #CharSize
					EndIf
				Else
					*C + #CharSize
				EndIf
				
			Case 39               ; -> '
				*C\c = 'a'
				*C + #CharSize
				While *C\c And *C\c <> 39 And *C\c <> #LF
					*C\c = 'a'
					*C + #CharSize
				Wend
				If *C\c = 39
					*C\c = 'a'
					*C + #CharSize
				EndIf
				
			Case ';'
				While *C\c And *C\c <> #LF
					*C\c = ' '
					*C + #CharSize
				Wend
				Break
			Default
				*C + #CharSize
				
		EndSelect
	ForEver
	
	; now scan backwards
	*C     = @PreviousLine$ + (Len(PreviousLine$) - 1) * #CharSize
	*Start = @PreviousLine$
	
	; skip whitespace
	While *C > *Start And (*C\c = ' ' Or *C\c = #TAB)
		*C - #CharSize
	Wend
	
	
	Token = FindContinueToken(*C, *Start)
	If Token = 0 Or Token = 1
		*C - #CharSize
	ElseIf Token = 2
		While *C > *Start And IsValidCharacter(*C\c)
			*C - #CharSize
		Wend
	Else
		;no line continuation
		ProcedureReturn ""
	EndIf
	
	; parse backwards until the beginning of the expression that is cut in half
	; track braced expressions properly
	Brackets         = 0
	*ExpressionStart = 0
	
	While *C > *Start
		
		; skip space
		While *C > *Start And (*C\c = ' ' Or *C\c = #TAB)
			*C - #CharSize
		Wend
		
		; check token
		Select *C\c
				
			Case ')', ']', '}'
				Brackets + 1
				*C - #CharSize
				
			Case '(', '[', '{'
				If Brackets = 0
					*ExpressionStart = *C + #CharSize
					Break ; beginning of the expression
				EndIf
				Brackets - 1
				*C - #CharSize
				
			Case ','
				If Brackets = 0 And Token <> 0
					*ExpressionStart = *C + #CharSize
					Break ; beginning of the expression
				EndIf
				*C - #CharSize
				
			Case ':'
				If *C > *Start And PeekC(*C - #CharSize) = ':'
					; a module separator. keep going beyond this
					*C - #CharSize * 2
				Else
					; an expression separator. this is always the beginning of the expression
					*ExpressionStart = *C + #CharSize
					Break
				EndIf
				
			Case '='
				If Brackets = 0 And Token = 1
					*ExpressionStart = *C + #CharSize
					Break ; for + or |, an '=' is considered the start
				EndIf
				*C - #CharSize
				
			Case '+', '-', '*', '/', '|', '&', '!'
				If Brackets = 0 And Token = 1
					; keep on searching, but use this as a fallback, so in case of lines like
					; 'a + b +' (no = in the line), the first '+' is used as the expression start
					*ExpressionStart = *C + #CharSize
				EndIf
				*C - #CharSize
				
			Default
				If IsValidCharacter(*C\c)
					; a word. isolate it
					*WordEnd = *C
					While *C > *Start And IsValidCharacter(*C\c)
						*C - #CharSize
					Wend
					*WordStart = *C
					If IsValidCharacter(*WordStart\c) = 0
						*WordStart + #CharSize
					EndIf
					
					; check if the word is preceded by a '\' or a '.' or a '#' (then it is never a keyword)
					While *C > *Start And (*C\c = ' ' Or *C\c = #TAB)
						*C - #CharSize
					Wend
					
					If *C\c <> '\' And *C\c <> '.' And *C\c <> '#' And *C\c <> '*'
						; identify the keyword
						Word$ = LCase(PeekS(*WordStart, (*WordEnd - *WordStart) / #CharSize + 1))
						
						If FindString(PB_Keywords$, "|" + Word$ + "|")
							*ExpressionStart = *WordEnd + #CharSize
							Break
							
						ElseIf Word$ = "to"
							; Special case. We want all these results to work:
							;
							;   Case 1 To 10,
							;        20 To 30
							;
							;   Case 1 To 10 +
							;             1
							;
							;   For i = 1 To 1 +
							;                1
							;
							; In one case we can't to ignore the "To" in the other case it is the stop keyword.
							; Fortunately, in one case, the token is "," and in the other it is "+" or "|" and there is
							; no overlap. So just check what continuation token we have to decide whether to ignore the To
							; or not.
							;
							If Token <> 0
								*ExpressionStart = *WordEnd + #CharSize
								Break
							EndIf
							
						ElseIf Word$ = "data"
							; special case as it can be "Data$ or Data.i"
							; note that "Data.s{10}" is not allowed which makes this simpler
							*ExpressionStart = *WordEnd + #CharSize
							If *ExpressionStart\c = '$'
								*ExpressionStart + #CharSize
							Else
								; skip whitespace
								While *ExpressionStart\c = ' ' Or *ExpressionStart\c = #TAB
									*ExpressionStart + #CharSize
								Wend
								; skip type
								If *ExpressionStart\c = '.'
									*ExpressionStart + #CharSize
									While *ExpressionStart\c = ' ' Or *ExpressionStart\c = #TAB
										*ExpressionStart + #CharSize
									Wend
									While IsValidCharacter(*ExpressionStart\c)
										*ExpressionStart + #CharSize
									Wend
								EndIf
							EndIf
							Break
							
							; if not an expression start, just continue
						EndIf
						
					Else
						*C - #CharSize
					EndIf
				Else
					; any other character
					*C - #CharSize
				EndIf
				
		EndSelect
		
	Wend
	
	; no start found
	If *ExpressionStart = 0
		;simply use the old line indentation
		ProcedureReturn GetIndent(*Start)
	ElseIf GlobalFlags & #Option_AltContinuedLine = 0
		;expression found, alternative continuation mode only adds single TABs then
		ProcedureReturn GetIndent(*Start) + AddTabs(1, MyTab$)
	EndIf
	
	; skip any further whitespace until the first expression token
	While *ExpressionStart\c = ' ' Or *ExpressionStart\c = #TAB
		*ExpressionStart + #CharSize
	Wend
	
	If *ExpressionStart\c = #LF
		*ExpressionStart + #CharSize
		
		; skip more whitespace
		While *ExpressionStart\c = ' ' Or *ExpressionStart\c = #TAB
			*ExpressionStart + #CharSize
		Wend
	EndIf
	
	; find the start of this line
	*LineStart = *ExpressionStart
	While *LineStart > *Start And *LineStart\c <> #LF
		*LineStart - #CharSize
	Wend
	If *LineStart\c = #LF
		*LineStart + #CharSize
	EndIf
	
	
	; get the prefix
	Prefix$ = PeekS(*LineStart, (*ExpressionStart - *LineStart) / #CharSize)
	
	; in the prefix, replace anything that is not whitespace with spaces
	*C = @Prefix$
	While *C\c
		If *C\c <> #TAB
			*C\c = ' '
		EndIf
		*C + #CharSize
	Wend
	
	; done
	ProcedureReturn Prefix$
EndProcedure

Procedure CreateBackup(File$)         ;create backups of the files, before indentation is initiated (just in case...)
	Protected Path$, i
	If GlobalFlags & #Option_NoBackup Or Backups < 1
		ProcedureReturn
	EndIf
	
	Path$ = GetTemporaryDirectory() + "smartindent" + #PS$
	If FileSize(Path$) <> -2
		CreateDirectory(Path$)
	EndIf
	
	For i = Backups To 1 Step - 1
		If FileSize(Path$ + "backup_" + Str(i) + ".pb") > 0
			If i = Backups
				DeleteFile(Path$ + "backup_" + Str(i) + ".pb")
			Else
				RenameFile(Path$ + "backup_" + Str(i) + ".pb", Path$ + "backup_" + Str(i + 1) + ".pb")
			EndIf
		EndIf
	Next i
	CopyFile(File$, Path$ + "backup_1.pb")
	
EndProcedure

Procedure.s AddSpacesToParameters(Line.s)
	;Smart indentation procedure part 1.
	;changes constructs like A(a,b,c,d) into: A(a, b, c, d)
	
	Protected *C.CHARACTER = @Line, Result$, DQ, escaped, *Cnext.CHARACTER, NeedSpace, CheckForNegativeSign
	Protected v, CharSequence, IsMultiSign, *Cprev.CHARACTER
	
	*Cprev = *C  ;to avoid 0 pointer at start
	While *C\c
		If *C\c <> ' ' And DQ = 0 And CharSequence = 0 ; no space, outside of a string and not inside a 'abcd' sequence
			Select NeedSpace
				Case 1                              ; NeedSpace 1 means: needs a space here in any case
					Result$ + " "
				Case 2                              ; NeedSpace 2 means: add space only if NO number follows
																						;                    especially for negative numbers, we don't want - 2.12, but -2.12
					If *C\c < '0' Or *C\c > '9'       ; not a number (< '0' or > '9')
						Result$ + " "
					EndIf
				Case 3                              ; NeedSpace 3 means: add space only if no double chars like <> <= are here
					If *C\c <> '=' And *C\c <> '<' And *C\c <> '>'    ; no '=', '<', '>'
						Result$ + " "
					EndIf
			EndSelect
		EndIf
		NeedSpace = 0
		
		;M_HandleDQOUTES expanded, because I need it slightly changed here
		;check if we are in the middle of a string
		If CharSequence = 0
			If *C\c = '~'
				If DQ = 0
					*Cnext = *C + #CharSize
					If *Cnext\c = '"'
						escaped = 1
						DQ      = 1
						Result$ + Chr(*C\c)
						*C = *Cnext
					EndIf
				EndIf
			ElseIf *C\c = '\' And DQ And escaped
				*Cnext = *C + #CharSize
				If *Cnext\c = '"'
					Result$ + Chr(*C\c)
					*C = *Cnext
				EndIf
			ElseIf *C\c = '"'
				DQ ! 1
				If DQ = 0
					escaped = 0
				EndIf
			EndIf
		EndIf
		If *C <> @Line
			*Cprev = *C - #CharSize                                                    ; keep previous character
		EndIf
		If DQ = 0 And *C\c = 39   ;'
			If CharSequence = 0 And *Cprev\c <> ' '
				Result$ + " "
			EndIf
			CharSequence ! 1
		EndIf
		If DQ Or CharSequence
			Result$ + Chr(*C\c)                                                         ; within string or char sequences, simply add the character to the result
		ElseIf *C\c = ';'                                                            ; this is a comment
			Result$ + Mid(Line, 1 + (*C - @Line) / #CharSize)                           ; add the whole comment to the result and freak out
			Break
		Else                                                                         ; not within a string, let's take a closer look now
			If *C\c = ','                                                              ; comma delimiter
				RTrim(Result$)                                                            ; we don't want something like proc(aa , bb, cc) but proc(aa, bb, cc)
																																								 ; therefore we remove the space(s) in front of the comma
				NeedSpace            = 1                                                 ; take note, that we need a space in the next round
				CheckForNegativeSign = #True                                             ; if the next character will be a - (e.g. proc(12, -10)) then don't add space)
			ElseIf *C\c = '!' Or *C\c = '+' Or *C\c = '/' Or *C\c = '%' Or *C\c = '|' Or *C\c = '&'
				                                                                         ; math operators
				If *Cprev\c <> ' '                                                       ; missing a space in front, we don't want To have A+B, but A + B
					Result$ + " "
				EndIf
				NeedSpace            = 1
				CheckForNegativeSign = 0
			ElseIf *C\c = '=' Or *C\c = '<' Or *C\c = '>'                              ; go on with '=', '<' and '>'
				CheckForNegativeSign = #True
				; make sure it is not something like '<>' '<=', and add a space before that character
				If *Cprev\c <> ' ' And *Cprev\c <> '=' And *Cprev\c <> '<' And *Cprev\c <> '>'
					Result$ + " "
				EndIf
				NeedSpace = 3                                                            ; Don't add spaces between <> <= ...
			ElseIf *C\c = '*'                                                          ; Star (*) handling
				*Cnext               = *C + #CharSize                                    ; check next character
				IsMultiSign          = #False
				CheckForNegativeSign = 0
				If *Cnext\c = '*'                                                        ; next character is *, but ** is not allowed, this must be a multiplication sign
					IsMultiSign = #True
				ElseIf (*Cnext\c >= 'a' And *Cnext\c <= 'z') Or (*Cnext\c >= 'A' And *Cnext\c <= 'Z') Or *Cnext\c = '_'
					                                                                       ; buffers can only start with those characters, but variables also, go on checking
					Select *Cprev\c
						Case ')', '_', 'a' To 'z', 'A' To 'Z'                                ; seems to be a variable, or the end of a procedure, therefore -> add spaces
							IsMultiSign = #True
					EndSelect
				Else
					IsMultiSign = #True
				EndIf
				If IsMultiSign
					If *Cprev\c <> ' '
						Result$ + " "
					EndIf
					NeedSpace            = 1
					CheckForNegativeSign = 1
				EndIf
			ElseIf *C\c = '-'                                                          ; Now check the '-'
				If Right(RemoveString(LCase(Result$), " "), 2) <> ".p"                    ; ignore pseudotypes, like var.p-utf8
					If *Cprev\c <> ' '                                                     ; add missing space, if needed
						Result$ + " "
					EndIf
					If CheckForNegativeSign
						NeedSpace = 2
					Else
						NeedSpace = 1
					EndIf
				EndIf
				CheckForNegativeSign = 0
			ElseIf *C\c = ' ' Or *C\c = #TAB                                           ; ignore existing spaces, we'll indent them anyway
																																								 ; should be checked later
			Else
				CheckForNegativeSign = 0
			EndIf
			Result$ + Chr(*C\c)
		EndIf
		
		*C + #CharSize
	Wend
	
	ProcedureReturn Result$
EndProcedure

Procedure EqualSignPos(Line$)                                                   ; find the '=' character
	Protected *C.CHARACTER, Result, DQ, escaped, *Cnext.CHARACTER, a$, Pos, i
	
	a$ = LCase(Line$)
	*C = @a$
	i  = 1
	While *C\c And (*C\c = ' ' Or *C\c = #TAB)
		i + 1
		*C + #CharSize
	Wend
	a$ = Mid(a$, i)
	*C = @Line$
	If Left(a$, 9) = "protected" Or Left(a$, 6) = "shared" Or Left(a$, 8) = "threaded" Or Left(a$, 6) = "static" Or Left(a$, 7) = "declare"
		;ignore them
	Else
		
		;Find '='
		While *C\c
			M_HandleDQUOTES
			If DQ = 0
				If *C\c = ';'
					Break
				ElseIf *C\c = '='
					Result = Pos
					Break
				EndIf
			EndIf
			Pos + 1
			*C + #CharSize
		Wend
	EndIf
	
	ProcedureReturn Result
EndProcedure

Procedure ReplaceTabs(*C.CHARACTER)
	;Replace Tabs inside Lines by Spaces (but not inside Strings!)
	;Makes handling much easier afterwards
	Protected DQ, escaped, *Cnext.CHARACTER
	
	While *C\c
		
		M_HandleDQUOTES
		If DQ = 0
			If *C\c = #TAB
				*C\c = ' '
			EndIf
		EndIf
		
		*C + #CharSize
	Wend
	
EndProcedure

Procedure.s ReplaceDoubleSpaces(*C.CHARACTER)
	;Replace double occurances of spaces (but not inside Strings!)
	Protected DQ, escaped, *Cnext.CHARACTER, Result$
	
	While *C\c
		
		If *C\c = '~'
			If DQ = 0
				*Cnext = *C + #CharSize
				If *Cnext\c = '"'
					escaped = 1
					DQ      = 1
					*C      = *Cnext
					Result$ + "~"
				EndIf
			EndIf
		ElseIf *C\c = '\' And DQ And escaped
			*Cnext = *C + #CharSize
			If *Cnext\c = '"'
				*C = *Cnext
				Result$ + "\"
			EndIf
		ElseIf *C\c = '"'
			DQ ! 1
			If DQ = 0
				escaped = 0
			EndIf
		EndIf
		If DQ = 0
			If *C\c = ' '
				*Cnext = *C + #CharSize
				While *Cnext\c = ' '
					*Cnext + #CharSize
				Wend
				If *Cnext\c = ';'
					Result$ + Space((*Cnext - *C) / #CharSize)
				Else
					Result$ + " "
				EndIf
				*C = *Cnext - #CharSize
			Else
				Result$ + Chr(*C\c)
			EndIf
		Else
			Result$ + Chr(*C\c)
		EndIf
		
		*C + #CharSize
	Wend
	
	ProcedureReturn Result$
EndProcedure

Procedure.s MyTrim(Line$)
	;Normal Trim() doesn't handle Tabs correctly, so i had to write my own
	;(think about constructs like TAB SPACE TAB SPACE Procedure Test() TAB TAB SPACE TAB SPACE, no R/L/Trim could handle that in one run)
	
	
	Protected *C.CHARACTER, Start = 1, _End, Result$
	
	If Line$ = ""
		ProcedureReturn ""
	EndIf
	
	*C = @Line$
	;find the first non white space
	Repeat
		If (*C\c <> ' ' And *C\c <> #TAB) Or *C\c = 0
			Break
		EndIf
		Start + 1
		*C + #CharSize
	ForEver
	If *C\c = 0
		;only whitespaces!
		ProcedureReturn ""
	EndIf
	
	;go on
	_End = Len(Line$)
	*C   = @Line$ + (_End - 1) * #CharSize
	_End - Start
	;find the first non white space from the end
	Repeat
		If *C\c <> ' ' And *C\c <> #TAB
			Break
		EndIf
		_End - 1
		*C - #CharSize
	ForEver
	Result$ = Mid(Line$, Start, _End + 1)
	
	ProcedureReturn Result$
EndProcedure

Procedure EqualLines(*PosSaved, MaxPos)
	Protected *Index, i, a$, TabsStored$
	
	;set all '=' to the same position, starting from *PosSaved element up to the current one
	;we have found MaxPos already, that is the position we will set our '=' character in that whole block
	
	*Index = @Lines$()                              ;keep the current element as end marker
	If *PosSaved
		ChangeCurrentElement(Lines$(), *PosSaved)     ;start from *PosSaved line
		Repeat
			a$          = Lines$()
			TabsStored$ = GetIndent(@a$)                ;all lines before *Index have been indented already,
			                                            ;therefore we store the indentation whitespaces
			a$ = Mid(a$, Len(TabsStored$) + 1)          ;a$ contains anything beside the indentation whitespaces now
			i  = EqualSignPos(a$)                       ;find the position of '='
			                                            ;and rebuild the whole line:
			Lines$() = TabsStored$ + Left(a$, i - 1) + RSet(" ", MaxPos - i, " ") + " = " + MyTrim(Mid(a$, i + 2))
			NextElement(Lines$())
		Until @Lines$() = *Index
	EndIf
	
EndProcedure

Procedure.s GetCommand(Line$)
	Protected *C.CHARACTER = @Line$, Pos, Result$
	
	;Line comes in as lcase and whitespaces left and right are removed already
	
	Repeat
		If Result$
			While *C\c = 9 Or *C\c = 32
				*C + #CharSize
			Wend
			Result$ = ""
		EndIf
		While *C\c
			If (*C\c < 'a' Or *C\c > 'z') And *C\c <> '_'   ;not a-z and no _ (commands can only start with those characters)
				If Pos = 0                                    ;this was the first character, it can't be a command
					Break
				ElseIf *C\c < '0' Or *C\c > '9'               ;now check for 0...9
					Break                                       ;no? not a command
				Else
					Result$ + Chr(*C\c)
				EndIf
			Else
				Result$ + Chr(*C\c)
			EndIf
			*C + #CharSize
			Pos + 1
		Wend
	Until Result$ <> "runtime"
	
	ProcedureReturn Result$
EndProcedure

Procedure.s FindCommand(Line$, Index = -1)
	;find next command in this line
	;when user wrote more then
	;just one command in one line via ':'
	;for example
	;While WindowEvent() : Wend
	;if Index = -1 it will return the last command
	
	Protected i, DQ, *C.CHARACTER, escaped, *Cnext.CHARACTER, Result$
	
	If Line$ = ""
		ProcedureReturn ""
	EndIf
	
	i  = 1
	*C = @Line$
	While *C\c <> 0
		M_HandleDQUOTES
		If *C\c = ':' And DQ = 0
			*Cnext = *C + #CharSize
			If *Cnext\c = ':'   ; module no command separator!
				If Index = -1 Or Index = i
					Result$ + "::"
				EndIf
				*C = *Cnext
			ElseIf Index <> -1 And i = Index
				Break
			Else
				Result$ = ""
				i + 1
			EndIf
		ElseIf DQ = 0 And *C\c = ';'
			Break
		ElseIf Index = -1 Or Index = i
			Result$ + Chr(*C\c)
		EndIf
		*C + #CharSize
	Wend
	
	ProcedureReturn MyTrim(Result$)
EndProcedure

Procedure GetLineIndent(Line$, *Before.INTEGER, *After.INTEGER)
	Protected i = 1, Commands, a$, b$
	
	*Before\i = 0
	*After\i  = 0
	
	Repeat
		a$ = FindCommand(Line$, i)
		If a$
			b$ = GetCommand(LCase(a$))
			If b$ And FindMapElement(Tags(), b$)
				Commands + 1
				If i = 1
					*Before\i = Tags()\Before
					*After\i  = Tags()\After
				Else
					*After\i + Tags()\Before + Tags()\After
				EndIf
			EndIf
		EndIf
		i + 1
	Until a$ = ""
	
	ProcedureReturn Commands
EndProcedure

Procedure IsJustComment(Line$)
	Protected *C.Character = @Line$
	
	;check if that whole line is nothing but a comment
	While *C\c And (*C\c = ' ' Or *C\c = #TAB)
		*C + #CharSize
	Wend
	
	If *C\c = ';'
		ProcedureReturn #True
	EndIf
	ProcedureReturn #False
	
EndProcedure

Procedure IndentationAndAlignment()
	Protected Tabs, After, After2, Before, Before2, CommandCount, MaxPos, NumberOfLines
	Protected EqualPos, IsComment, *PosSaved, LastLine$, ContLinePrefix$
	
	ForEach Lines$()
		CommandCount    = GetLineIndent(Lines$(), @Before, @After)
		IsComment       = #False
		ContLinePrefix$ = GetIndentContinuationPrefix(LastLine$)
		
		If CommandCount = 0                             ;it doesn't make sense to handle the '=' character,
																									  ;when this line contains one of the indentation commands (like if, else, elseif, ...)
			If IsJustComment(Lines$())                    ;comments are not re-indented and end an indentation block
				If NumberOfLines > 1
					EqualLines(*PosSaved, MaxPos)
				EndIf
				NumberOfLines = 0
				MaxPos        = 0
				*PosSaved     = 0
				IsComment     = #True
			ElseIf ContLinePrefix$
				;Lines that continue stop equal sign positioning
				If NumberOfLines > 1
					EqualLines(*PosSaved, MaxPos)
				EndIf
				NumberOfLines = 0
				MaxPos        = 0
				*PosSaved     = 0
			ElseIf NumberOfLines = 0                     ;no lines found until now, let's check if this line has a '=' character
				MaxPos = EqualSignPos(Lines$())
				If MaxPos And GlobalFlags & #Option_NoEqualAlignment = 0
					                                         ;yes, store it for later indentation
					*PosSaved     = @Lines$()
					NumberOfLines = 1
				EndIf
			ElseIf Before2 = Before And After2 = After   ;we are still on the same indentation level, anything else doesn't need to be considered
				EqualPos = EqualSignPos(Lines$())
				If EqualPos = 0                            ;no '=' here
					If NumberOfLines > 1                     ;but we have an old block waiting for indentation
						EqualLines(*PosSaved, MaxPos)          ;indent the '=' for the waiting block
					EndIf
					NumberOfLines = 0                        ;block finished, clear variables
					MaxPos        = 0
					*PosSaved     = 0
				Else
					NumberOfLines + 1                        ;yes, there is a '=' and we are in the middle of an indentation block
					If EqualPos > MaxPos                     ;get the max space we need to indent the '='
						MaxPos = EqualPos
					EndIf
				EndIf
			Else
				If NumberOfLines > 1                       ;this is a different indentation level, but we seem to have a block waiting
					EqualLines(*PosSaved, MaxPos)            ;go go go
				EndIf
				NumberOfLines = 0
				MaxPos        = 0
				*PosSaved     = 0
			EndIf
		Else                                           ;there is one of the indentation commands in that line
			If NumberOfLines > 1                         ;finish the waiting block
				EqualLines(*PosSaved, MaxPos)
			EndIf
			NumberOfLines = 0
			MaxPos        = 0
			*PosSaved     = 0
		EndIf
		Before2 = Before                             ;used to find out, if we are still on the same indentation level
		After2  = After
		If IsComment
			;keep as is, don't touch
		Else
			Tabs + Before
			If Lines$() Or GlobalFlags & #Option_RemoveWhiteSpacesInEmptyLines = 0
				If ContLinePrefix$
					Lines$() = ContLinePrefix$ + Lines$()
				Else
					Lines$() = AddTabs(Tabs, MyTab$) + Lines$()
				EndIf
			EndIf
			Tabs + After
		EndIf
		
		If ContLinePrefix$
			LastLine$ + #LF$ + Lines$()
		Else
			LastLine$ = Lines$()
		EndIf
		
	Next
	
	ProcedureReturn Tabs
EndProcedure

Procedure Main()
	Protected i, j, File$, a$, b$, Tabs, Found, UTF_Flag, Prefs$, PB_Settings_Start
	
	;get indentation settings from PureBasic.prefs
	CompilerIf #PB_Compiler_Debugger
		Prefs$ = GetUserDirectory(#PB_Directory_ProgramData) + "PureBasic" + #PS$ + "PureBasic.prefs"
	CompilerElse
		Prefs$ = GetEnvironmentVariable("PB_TOOL_Preferences")
	CompilerEndIf
	OpenPreferences(Prefs$)
	PreferenceGroup("Global")
	If ReadPreferenceLong("RealTab", 0)
		MyTab$ = #TAB$
	Else
		MyTab$ = Space(ReadPreferenceLong("TabLength", 2))
	EndIf
	If ReadPreferenceLong("UseTabIndentForSplittedLines", 0) = 0
		GlobalFlags = GlobalFlags | #Option_AltContinuedLine
	EndIf
	
	PreferenceGroup("Indentation")
	j = ReadPreferenceInteger("NbKeywords", 0) - 1
	For i = 0 To j
		AddMapElement(Tags(), LCase(ReadPreferenceString("Keyword_" + Str(i), "")))
		Tags()\Before = ReadPreferenceInteger("Before_" + Str(i), 0)
		Tags()\After  = ReadPreferenceInteger("After_" + Str(i), 0)
	Next i
	ClosePreferences()
	Backups = #MAX_BACKUPS
	
	CompilerIf #PB_Compiler_Debugger And Defined(D_FILENAME, #PB_Constant)
		File$ = #D_FILENAME
	CompilerElse
		j = CountProgramParameters()
		For i = 0 To j - 1
			a$ = ProgramParameter(i)
			Select LCase(a$)
				Case "-rmempty", "-re"       ;remove whitespaces in empty lines
					GlobalFlags = GlobalFlags | #Option_RemoveWhiteSpacesInEmptyLines
				Case "-nobackup", "-nb"      ;don't use backups
					GlobalFlags = GlobalFlags | #Option_NoBackup
					Backups     = 0
				Case "-noequalalign", "-ne"  ;don't do equal sign alignment
					GlobalFlags = GlobalFlags | #Option_NoEqualAlignment
				Case "-nodbspacerem", "-nds" ;do not remove multi occurances of spaces
					GlobalFlags = GlobalFlags | #Option_DontRemoveDoubleSpaces
				Default
					If FileSize(a$) > 0
						File$ = a$
					EndIf
			EndSelect
		Next i
	CompilerEndIf
	
	If File$ = "" Or ReadFile(0, File$) = 0
		MessageRequester("Error!", "File '" + File$ + "' not found!")
		ProcedureReturn
	EndIf
	UTF_Flag = ReadStringFormat(0)
	If UTF_Flag <> #PB_UTF8
		UTF_Flag = #PB_Ascii
	EndIf
	
	
	;now read the whole file into Lines() list and do some basic action here already
	While Eof(0) = 0
		AddElement(Lines$())
		a$ = ReadString(0, UTF_Flag)
		If IsJustComment(a$)
			; Remove whitespaces from the end of comments
			Lines$() = RTrim(a$)
			CompilerIf #FIX_PB_BUG ; => https://www.purebasic.fr/english/viewtopic.php?p=581265#p581265
				If Left(Lines$(), 25) = "; IDE Options = PureBasic"
					PB_Settings_Start = #True
				ElseIf PB_Settings_Start And Left(Lines$(), 10) = "; Constant"
					DeleteElement(Lines$())
				EndIf
			CompilerEndIf
		Else
			;Remove all whitespaces at the beginning and at the end
			b$ = MyTrim(a$)
			;Replace Tabs inside line with space (but not inside Strings!)
			ReplaceTabs(@b$)
			If GlobalFlags & #Option_DontRemoveDoubleSpaces = 0
				b$ = ReplaceDoubleSpaces(@b$)
			EndIf
			;First indentation
			Lines$() = AddSpacesToParameters(b$)
		EndIf
	Wend
	CloseFile(0)
	Tabs = IndentationAndAlignment()
	
	
	Found = #PB_MessageRequester_Yes
	If Tabs <> 0
		;Something wrong with the code...
		Found = MessageRequester("Error!", "Something seems to be wrong with your Code!" + #LF$ + "Would you like to parse it anyway ?", #PB_MessageRequester_YesNo)
	EndIf
	If Found = #PB_MessageRequester_Yes
		CompilerIf #PB_Compiler_Debugger
			ForEach Lines$()
				Debug Lines$()
			Next
		CompilerElse
			CreateBackup(File$)
			If CreateFile(0, File$)
				WriteStringFormat(0, UTF_Flag)
				ForEach Lines$()
					WriteStringN(0, Lines$(), UTF_Flag)
				Next
				CloseFile(0)
			EndIf
		CompilerEndIf
		
	EndIf
EndProcedure

Main()
End

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -----------------------
; EnableXP
; Executable = indent.app