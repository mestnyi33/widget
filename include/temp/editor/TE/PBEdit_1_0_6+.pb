XIncludeFile "../../../../widgets.pbi"

UseLib(widget)

; -=PBEdit 1.0.6=-
; ----------------------------------------------------------------------------------
; a canvas-based Texteditor -> PureBasic only <- no external libraries
;
; Features
;	- Basic editing
;	- Mouse support
;	- Multicursor
;	- Split view (needs improvement when resizing)
;	- Syntax highlighting
;	- Indentation (none, block, automatic)
;	- Autocomplete
;	- Folding
;	- Case correction
;	- Linenumbers
;	- "real" tabs or spaces
;	- Undo / Redo
;	- Drag & Drop
;	- Find / Replace Dialog (Regular Expressions supported)
;	- Bookmarks
;	- Zooming
;	- Repeated selections
;	- Horizontal / Vertical Scrollbars (optional)
;	- Customizable (via xml)
;	- DPI aware (not sure about that) - check compiler option!
;	- should run on Windows and Linux (Mac not tested)	
;
;	Experimental (or under construction):
;	- Mark matching or missiong keywords and brackets
;	- Line continuation
;	- Beautify textline after return
;
;	v1.0.1
;	added:		multilanguage support (language.cfg file)
;
;	v1.0.2
;	added:		settings file (PBEdit.xml)
;
;	v1.0.3 		some bugs fixed
;
;	v1.0.4
;	fixed:		bug in horizontal scroll (last chars of long textline not visible)
;				bug when inserting text with multiple cursors
;				missing colors in settings.xml
;				beautify procedure removed indentation when in block-mode
;
;	changed:	redraw of cursor only if needed (avoid flickering)
;				default style is black/white
;				tokenizing and styling simplified
;
;	added:		enhanced character table (use all 65535 characters instead of only 255)
;				if needed, set #TE_CharRange to 65536
;
;	v1.0.5
;	changed:	the cursor now has its own timer and the scroll timer is only activated if needed
;	added:		french translation (thx, Mesa!)
;
;	v1.0.6
;	fixed:		a few scrolling related issues
;	changed:	removed the "ID" Parameter from the Procedure "Editor_New". The return value now is a pointer to the TE_STRUCT (not the canvas ID anymore)
;	added:		PostEvent to signal cursor changes (#TE_Event_Cursor) or selection changes (#TE_Event_Selection)				
;				
; ----------------------------------------------------------------------------------
;
;	MIT License
;	
;	Copyright (c) 2020 Mr.L
;	
;	Permission is hereby granted, free of charge, to any person obtaining a copy
;	of this software and associated documentation files (the "Software"), to deal
;	in the Software without restriction, including without limitation the rights
;	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;	copies of the Software, and to permit persons to whom the Software is
;	furnished to do so, subject to the following conditions:
;	
;	The above copyright notice and this permission notice shall be included in all
;	copies or substantial portions of the Software.
;	
;	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;	SOFTWARE.

DeclareModule _PBEdit_
	
	#TE_CharSize = SizeOf(Character)
	#TE_VectorDrawAdjust = 0.5
	#TE_VectorDrawWidth = 1.0
	#TE_CharRange = 256;65536
	#TE_MaxScrollbarHeight = 10000
	#TE_MaxCursors = 2500
	#TE_Ignore = 0
	
	Enumeration #PB_Event_FirstCustomValue
		#TE_Event_Cursor
		#TE_Event_Selection
		
		#TE_EventType_Add
		#TE_EventType_Change
		#TE_EventType_Remove
	EndEnumeration
	
	EnumerationBinary
		#TE_Redraw_ChangedLined
		#TE_Redraw_All
	EndEnumeration
	
	Enumeration 1
		#TE_Style_None
		#TE_Style_Keyword
		#TE_Style_Function
		#TE_Style_Structure
		#TE_Style_Text
		#TE_Style_String
		#TE_Style_Quote
		#TE_Style_Comment
		#TE_Style_Number
		#TE_Style_Pointer
		#TE_Style_Address
		#TE_Style_Constant
		#TE_Style_Operator
		#TE_Style_Backslash
		#TE_Style_Comma
		#TE_Style_Bracket
		#TE_Style_Highlight
		#TE_Style_CodeMatch
		#TE_Style_CodeMismatch
		#TE_Style_BracketMatch
		#TE_Style_BracketMismatch
		#TE_Style_Label
	EndEnumeration
	Global Dim StyleEnumName.s(64)
	StyleEnumName(#TE_Style_None) = "None"
	StyleEnumName(#TE_Style_Keyword) = "Keyword"
	StyleEnumName(#TE_Style_Function) = "Function"
	StyleEnumName(#TE_Style_Structure) = "Structure"
	StyleEnumName(#TE_Style_Text) = "Text"
	StyleEnumName(#TE_Style_String) = "String"
	StyleEnumName(#TE_Style_Quote) = "Quote"
	StyleEnumName(#TE_Style_Comment) = "Comment"
	StyleEnumName(#TE_Style_Number) = "Number"
	StyleEnumName(#TE_Style_Pointer) = "Pointer"
	StyleEnumName(#TE_Style_Address) = "Address"
	StyleEnumName(#TE_Style_Constant) = "Constant"
	StyleEnumName(#TE_Style_Operator) = "Operator"
	StyleEnumName(#TE_Style_Backslash) = "Backslash"
	StyleEnumName(#TE_Style_Comma) = "Comma"
	StyleEnumName(#TE_Style_Bracket) = "Bracket"
	StyleEnumName(#TE_Style_Highlight) = "Highlight"
	StyleEnumName(#TE_Style_CodeMatch) = "CodeMatch"
	StyleEnumName(#TE_Style_CodeMismatch) = "CodeMismatch"
	StyleEnumName(#TE_Style_BracketMatch) = "BracketMatch"
	StyleEnumName(#TE_Style_BracketMismatch) = "BracketMismatch"
	StyleEnumName(#TE_Style_Label) = "Label"
		
	Enumeration
		#TE_Token_Unknown
		#TE_Token_Whitespace			;  space or tab
		#TE_Token_Text
		#TE_Token_Number
		#TE_Token_Operator				;  + - / & | ! ~
		#TE_Token_Compare				;  < >
		#TE_Token_Backslash
		#TE_Token_Point
		#TE_Token_Equal
		#TE_Token_Comma
		#TE_Token_Colon					;  :
		#TE_Token_BracketOpen			;  ( [ {
		#TE_Token_BracketClose			;  ) ] }
		#TE_Token_String				;  "..."
		#TE_Token_Quote					;  '...'
		#TE_Token_Comment				;  ;...
		#TE_Token_EOL					; End of line
	EndEnumeration
	
	Global Dim TokenEnumName.s(64)
	TokenEnumName(#TE_Token_Unknown) = "unknown"
	TokenEnumName(#TE_Token_Whitespace) = "whiteSpace"
	TokenEnumName(#TE_Token_Text) = "text"
	TokenEnumName(#TE_Token_Number) = "number"
	TokenEnumName(#TE_Token_Operator) = "operator"
	TokenEnumName(#TE_Token_Compare) = "compare"
	TokenEnumName(#TE_Token_Backslash) = "backslash"
	TokenEnumName(#TE_Token_Point) = "point"
	TokenEnumName(#TE_Token_Equal) = "equal"
	TokenEnumName(#TE_Token_Comma) = "comma"
	TokenEnumName(#TE_Token_Colon) = "colon"
	TokenEnumName(#TE_Token_BracketOpen) = "bracketOpen"
	TokenEnumName(#TE_Token_BracketClose) = "bracketClose"
	TokenEnumName(#TE_Token_String) = "string"
	TokenEnumName(#TE_Token_Quote) = "quote"
	TokenEnumName(#TE_Token_Comment) = "comment"
	TokenEnumName(#TE_Token_EOL) = "EOL"
	
	EnumerationBinary
		#TE_Styling_UpdateFolding
		#TE_Styling_UpdateIndentation
		#TE_Styling_UnfoldIfNeeded
		#TE_Styling_CaseCorrection
		#TE_Styling_All = #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation | #TE_Styling_UnfoldIfNeeded | #TE_Styling_CaseCorrection
	EndEnumeration
	
	EnumerationBinary
		#TE_Find_Next
		#TE_Find_Previous
		#TE_Find_StartAtCursor
		#TE_Find_CaseSensitive
		#TE_Find_WholeWords
		#TE_Find_NoComments
		#TE_Find_NoStrings
		#TE_Find_RegEx
		#TE_Find_InsideSelection
		#TE_Find_Replace
		#TE_Find_ReplaceAll
	EndEnumeration
	
	Enumeration
		#TE_Indentation_None
		#TE_Indentation_Block
		#TE_Indentation_Auto
	EndEnumeration
	
	Enumeration
		#TE_Folding_Unfolded = 1
		#TE_Folding_Folded = 2
		#TE_Folding_End = -1
	EndEnumeration
	
	Enumeration
		#TE_Text_LowerCase
		#TE_Text_UpperCase
	EndEnumeration
	
	Enumeration 1
		#TE_Undo_Start
		#TE_Undo_AddText
		#TE_Undo_DeleteText
	EndEnumeration
	
	Enumeration 1
		#TE_MousePosition_LineNumber
		#TE_MousePosition_FoldState
		#TE_MousePosition_TextArea
	EndEnumeration
	
	Enumeration
		#TE_View_SplitHorizontal
		#TE_View_SplitVertical
	EndEnumeration
	
	Enumeration 1
		#TE_Cursor_Normal
		#TE_Cursor_DragDrop
	EndEnumeration
	
	Enumeration
		#TE_Timer_CursorBlink
		#TE_Timer_Scroll
	EndEnumeration
	
	Enumeration
		#TE_CursorState_Idle = -1
		#TE_CursorState_DragMove = 1
		#TE_CursorState_DragCopy = 2
	EndEnumeration
	
	Enumeration
		#TE_Autocomplete_FindAtBegind
		#TE_Autocomplete_FindAny
	EndEnumeration
	
	Enumeration 100
		#TE_Menu_Cut
		#TE_Menu_Copy
		#TE_Menu_Paste
		#TE_Menu_InsertComment
		#TE_Menu_RemoveComment
		#TE_Menu_FormatIndentation
		#TE_Menu_ToggleFold
		#TE_Menu_ToggleAllFolds
		#TE_Menu_SelectAll
		#TE_Menu_SplitViewHorizontal
		#TE_Menu_SplitViewVertical
		#TE_Menu_UnsplitView
		
		#TE_Menu_ReturnKey
		#TE_Menu_EscapeKey
	EndEnumeration
	
	EnumerationBinary
		#TE_Marker_Bookmark
		#TE_Marker_Breakpoint
	EndEnumeration
	
	EnumerationBinary 1
		#TE_Flag_Start
		#TE_Flag_End
		#TE_Flag_Container
		#TE_Flag_Procedure
		#TE_Flag_Return
		#TE_Flag_Loop
		#TE_Flag_Break
		#TE_Flag_Continue
		#TE_Flag_Compiler
		#TE_Flag_Multiline
		#TE_Flag_NoWhiteSpace
		#TE_Flag_NoBlankLines
		#TE_Flag_Foldable
	EndEnumeration
	
	EnumerationBinary
		#TE_Parser_State_EOL
		#TE_Parser_State_EOF
	EndEnumeration
	
	Enumeration
		#TE_ScrollbarEnabled = 1
		#TE_ScrollbarAlwaysOn = 2
	EndEnumeration
	
	Structure TE_COLORSCHEME
		defaultTextColor.i
		selectedTextColor.i
		cursor.i
		inactiveBackground.i
		currentBackground.i
		selectionBackground.i
		currentLine.i
		currentLineBackground.i
		inactiveLineBackground.i
		indentationGuides.i
		repeatedSelections.i
		lineNr.i
		currentLineNr.i
		lineNrBackground.i
		foldIcon.i
		foldIconBorder.i
		foldIconBackground.i
	EndStructure
	
	Structure TE_TEXTSTYLE
		fColor.i
		bColor.i
		fontNr.i
		underlined.i
	EndStructure
	
	Structure TE_TOKEN
		type.b
		charNr.l
		*text.Character
		size.l
	EndStructure
	
	Structure TE_FONT
		name.s
		nr.i
		id.i
		size.i
		height.i
		style.i
		Array width.i(#TE_CharRange)
	EndStructure
	
	Structure TE_PARSER
		*textline.TE_TEXTLINE
		*token.TE_TOKEN
		Array tokenType.c(#TE_CharRange)
		lineNr.i
		tokenIndex.i
		state.i
	EndStructure
	
	Structure TE_SYNTAX
		keyword.s
		flags.i
		Map before.TE_SYNTAX()
		Map after.TE_SYNTAX()
	EndStructure
	
	Structure TE_KEYWORD
		name.s
		style.b
		foldState.b
		indentationBefore.b
		indentationAfter.b
		caseCorrection.b
	EndStructure
	
	Structure TE_KEYWORDITEM
		name.s
		length.i
	EndStructure
	
	Structure TE_INDENTATIONPOS
		*textLine.TE_TEXTLINE
		charNr.i
	EndStructure
	
	Structure TE_POSITION
		*textline.TE_TEXTLINE
		lineNr.i
		visibleLineNr.i
		charNr.i
		charX.i
		currentX.i
		width.i
	EndStructure
	
	Structure TE_RANGE
		pos1.TE_POSITION
		pos2.TE_POSITION
	EndStructure
	
	Structure TE_CURSORSTATE
		overwrite.i
		compareMode.i
		
		blinkDelay.i
		blinkSuspend.i
		blinkState.i
		
		buttons.i
		modifiers.i
		
		clickSpeed.i				; in Event_Mouse
		clickCount.i				; in Event_Mouse:	used to detect 'double/tripple/... -click'
		firstClickTime.i			; in Event_Mouse
		firstClickX.i				; in Event_Mouse:	first x-position of the mouse
		firstClickY.i				; in Event_Mouse:	first y-position of the mouse
		firstSelection.TE_RANGE		; in Event_Mouse:	first selection
		lastSelection.TE_RANGE
		lastPosition.TE_POSITION	; in Event_Mouse:	previous position
		
		state.i
		dragStart.i
		dragText.s
		dragTextPreview.s
		dragPosition.TE_POSITION
		
		mouseX.i					; mouse Position inside Canvas
		mouseY.i
		windowMouseX.i				; mouse Position inside Window
		windowMouseY.i
		desktopMouseX.i				; mouse Position inside Desktop
		desktopMouseY.i
		deltaX.i					; mouse movement
		deltaY.i
	EndStructure
	
	Structure TE_CURSOR
		firstPosition.TE_POSITION
		lastPosition.TE_POSITION
		position.TE_POSITION
		
		lastSelection.TE_POSITION
		selection.TE_POSITION
		
		visible.i
		number.i
	EndStructure
	
	Structure TE_SCROLL
		visibleLineNr.i
		charX.i
		scrollTime.i
		scrollDelay.i
		autoScroll.i				; activated, when the mouse is in upper or lower canvas position
	EndStructure
	
	Structure TE_SCROLLBAR
		*gadget.structures::_s_widget
		enabled.i
		isHidden.i
		scale.d
	EndStructure
	
	Structure TE_FIND
		wnd_findReplace.i
		cmb_search.i
		txt_search.i
		chk_replace.i
		cmb_replace.i
		frm_0.i
		chk_caseSensitive.i
		chk_wholeWords.i
		chk_insideSelection.i
		chk_noComments.i
		chk_noStrings.i
		chk_regEx.i
		btn_findNext.i
		btn_findPrevious.i
		btn_replace.i
		btn_replaceAll.i
		btn_close.i
		
		text.s
		replace.s
		replaceCount.i
		flags.i
		startPos.TE_POSITION
		endPos.TE_POSITION
		
		regEx.i
		
		isVisible.i
	EndStructure
	
	Structure TE_AUTOCOMPLETE
		wnd_autocomplete.i
		lst_listBox.i
		
		font.TE_FONT
		
		minCharacterCount.i
		maxRows.i
		
		isVisible.i
		enabled.i
		
		mode.i
	EndStructure
	
	Structure TE_UNDOENTRY
		action.b
		startPos.TE_POSITION
		endPos.TE_POSITION
		text.s
	EndStructure
	
	Structure TE_UNDO
		List entry.TE_UNDOENTRY()
		
		start.i
		index.i
		clearRedo.i
	EndStructure
	
	Structure TE_SYNTAXHIGHLIGHT
		style.i
		*textline.TE_TEXTLINE
		startCharNr.i
		EndCharNr.i
	EndStructure
	
	Structure TE_TEXTBLOCK
		firstVisibleLineNr.i
		firstLineNr.i
		firstCharNr.i
		lastVisibleLineNr.i
		lastLineNr.i
		lastCharNr.i
		*firstLine.TE_TEXTLINE
		*lastLine.TE_TEXTLINE
	EndStructure
	
	Structure TE_TEXTLINE
		text.s
		textWidth.d
		
		Array style.b(0)
		Array syntaxHighlight.b(0)
		Array token.TE_TOKEN(0)
		
		tokenCount.i
		
		foldState.b				; #TE_Folding_Folded		start of textblock (folded)
		; #TE_Folding_Unfolded		start of textblock (unfolded)
		; #TE_Folding_End			end of textblock
		foldCount.l
		foldSum.l
		
		indentationBefore.b
		indentationAfter.b
		
		needRedraw.b
		needStyling.b
		marker.b
	EndStructure
	
	Structure TE_VIEW
		*editor.TE_STRUCT
		canvas.i
		
		x.i
		y.i
		width.i
		height.i
		zoom.d
		
		pageHeight.i
		pageWidth.i
		
		firstVisibleLineNr.i
		lastVisibleLineNr.i
		
		scroll.TE_SCROLL
		
		scrollBarH.TE_SCROLLBAR
		scrollBarV.TE_SCROLLBAR
		
		*parent.TE_VIEW
		*child.TE_VIEW[2]
	EndStructure
	
	Structure TE_LANGUAGE
		fileName.s
		
		errorTitle.s
		errorRegEx.s
		errorNotFound.s
		
		warningTitle.s
		warningLongText.s
		
		gotoTitle.s
		gotoMessage.s
		
		messageTitleFindReplace.s
		messageNoMoreMatches.s
		messageNoMoreMatchesStart.s
		messageNoMoreMatchesEnd.s
		messageReplaceComplete.s
	EndStructure
	
	Structure TE_STRUCT
		*view.TE_VIEW
		*currentView.TE_VIEW
		
		List textLine.TE_TEXTLINE()
		List textBlock.TE_TEXTBLOCK()
		List syntaxHighlight.TE_SYNTAXHIGHLIGHT()
		List lineHistory.i()
		
		Map keyWord.TE_KEYWORD()
		Map keyWordLineContinuation.s()
		Map autoCompleteList.s()
		Map syntax.TE_SYNTAX()
		
		Array font.TE_FONT(8)
		fontName.s
		
		laguage.TE_LANGUAGE
		
		x.i
		y.i
		width.i
		height.i
		
		lineHeight.i
		
		parser.TE_PARSER
		
		visibleLineCount.i
		
		window.i
		popupMenu.i
		autocomplete.TE_AUTOCOMPLETE
		
		maxLineWidth.i
		maxTextWidth.i
		
		scrollbarWidth.i
		leftBorderOffset.i
		leftBorderSize.i
		topBorderSize.i
		
		cursorState.TE_CURSORSTATE
		List cursor.TE_CURSOR()
		*currentCursor.TE_CURSOR
		*maincursor.TE_CURSOR
		
		undo.TE_UNDO
		redo.TE_UNDO
		
		find.TE_FIND
		
		needScrollUpdate.i
		needFoldUpdate.i
		redrawMode.i
		
		highlightSyntax.i
		highlightSelection.s
		highlightMode.i
		
		Array textStyle.TE_TEXTSTYLE(255)
		
		indentationMode.i
		
		useRealTab.i
		tabSize.i
		
		commentChar.s
		uncommentChar.s
		
		newLineText.s
		newLineChar.c
		
		colors.TE_COLORSCHEME
		
		enableScrollBarHorizontal.b
		enableScrollBarVertical.b
		enableStyling.b
		enableLineNumbers.b
		enableShowCurrentLine.b
		enableFolding.b
		enableIndentation.b
		enableCaseCorrection.b
		enableIndentationLines.b
		enableShowWhiteSpace.b
		enableAutoComplete.b
		enableDictionary.b
		enableSyntaxCheck.b
		enableBeautify.b
		enableMultiCursor.b
		enableSplitScreen.b
		enableSelectPastedText.b
		enableHighlightSelection.b
	EndStructure
	
	;-
	;- ------------ DECLARE -----------
	;-
	
	Declare Editor_New(window, x, y, width, height, languageFile.s = "")
	
	Declare View_Add(*te.TE_STRUCT, x, y, width, height, *parent.TE_VIEW, *view.TE_VIEW = #Null)
	Declare View_Split(*te.TE_STRUCT, x, y, splitMode = #TE_View_SplitHorizontal)
	Declare View_Unsplit(*te.TE_STRUCT, x, y)
	Declare View_FromMouse(*te.TE_STRUCT, *view.TE_VIEW, x, y)
	
	Declare Max(a, b)
	Declare Min(a, b)
	Declare Clamp(value, min, max)
	Declare.s TokenName(*token.TE_TOKEN)
	Declare.s TokenText(*token.TE_TOKEN)
	Declare LineNr_from_VisibleLineNr(*te.TE_STRUCT, visibleLineNr)
	Declare LineNr_to_VisibleLineNr(*te.TE_STRUCT, lineNr)
	Declare BorderSize(*te.TE_STRUCT)
	Declare Position_InsideRange(*pos.TE_POSITION, *range.TE_RANGE, includeBorder = #True)
	Declare Position_Equal(*pos1.TE_POSITION, *pos2.TE_POSITION)
	Declare Position_Changed(*pos1.TE_POSITION, *pos2.TE_POSITION)
	
	Declare.s Text_Get(*te.TE_STRUCT, startLineNr, startCharNr, endLineNr, endCharNr)
	
	Declare Undo_Start(*undo.TE_UNDO)
	Declare Undo_Add(*undo.TE_UNDO, action, startLineNr = 0, startCharNr = 0, endLineNr = 0, endCharNr = 0, text.s = "")
	Declare Undo_Do(*te.TE_STRUCT, *undo.TE_UNDO, *redo.TE_UNDO)
	Declare Undo_Update(*te.TE_STRUCT)
	Declare Undo_Clear(*undo.TE_UNDO)
	
	Declare Syntax_Add(*te.TE_STRUCT, text.s, flags = #TE_Flag_Multiline)
	
	Declare Style_Textline(*te.TE_STRUCT, *textLine.TE_TEXTLINE, flags = 0)
	Declare Style_LoadFont(*te.TE_STRUCT, *font.TE_FONT, fontName.s, fontSize, fontStyle = 0)
	Declare Style_SetFont(*te.TE_STRUCT, fontName.s, fontSize, fontStyle = 0)
	Declare Style_Set(*te.TE_STRUCT, styleNr, fontNr, color, bColor = #TE_Ignore, underlined = #False)
	Declare Style_SetDefaultStyle(*te.TE_STRUCT)
	Declare Style_FromCharNr(*textLine.TE_TEXTLINE, charNr, scanWholeLine = #False)
	
	Declare Parser_Initialize(*parser.TE_PARSER)
	Declare Parser_Clear(*parser.TE_PARSER)
	Declare Parser_TokenAtCharNr(*te.TE_STRUCT, *textLine.TE_TEXTLINE, charNr, testBounds = #False, startIndex = 1)
	Declare Parser_NextToken(*te.TE_STRUCT, direction, flags = #TE_Flag_NoWhiteSpace)
	
	Declare KeyWord_Add(*te.TE_STRUCT, key.s, style = #TE_Ignore, caseCorrection = #TE_Ignore)
	Declare KeyWord_LineContinuation(*te.TE_STRUCT, key.s)
	Declare KeyWord_Folding(*te.TE_STRUCT, key.s, foldState)
	Declare KeyWord_Indentation(*te.TE_STRUCT, key.s, indentationBefore, indentationAfter)
	
	Declare Folding_Update(*te.TE_STRUCT, firstLine, lastLine)
	Declare Folding_UnfoldTextline(*te.TE_STRUCT, lineNr)
	Declare Folding_GetTextBlock(*te.TE_STRUCT, lineNr)
	
	Declare.s Indentation_Clear(*textLine.TE_TEXTLINE)
	
	Declare Textline_Add(*te.TE_STRUCT)
	Declare Textline_FromLine(*te.TE_STRUCT, lineNr)
	Declare Textline_FromVisibleLineNr(*te.TE_STRUCT, visibleLineNr)
	Declare Textline_TopLine(*te.TE_STRUCT)
	Declare Textline_BottomLine(*te.TE_STRUCT)
	Declare Textline_AddChar(*te.TE_STRUCT, *cursor.TE_CURSOR, c.c, overwrite, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
	Declare Textline_AddText(*te.TE_STRUCT, *cursor.TE_CURSOR, *c.Character, textLength, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
	Declare Textline_SetText(*te.TE_STRUCT, *textLine.TE_TEXTLINE, text.s, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
	Declare Texlint_IsEmpty(*textline.TE_TEXTLINE)
	Declare Textline_LineNr(*te.TE_STRUCT, *textline.TE_TEXTLINE)
	Declare Textline_LineNrFromScreenPos(*te.TE_STRUCT, *view.TE_VIEW, screenY)
	Declare Textline_Length(*textLine.TE_TEXTLINE)
	Declare Textline_LastCharNr(*te.TE_STRUCT, lineNr)
	Declare Textline_NextTabSize(*te, *textline.TE_TEXTLINE, charNr)
	Declare Textline_Width(*te.TE_STRUCT, *textLine.TE_TEXTLINE)
	Declare Textline_CharNrFromScreenPos(*te.TE_STRUCT, *textLine.TE_TEXTLINE, screenX)
	Declare Textline_ColumnFromCharNr(*te.TE_STRUCT, *view.TE_VIEW, *textLine.TE_TEXTLINE, charNr)
	Declare Textline_CharNrToScreenPos(*te.TE_STRUCT, *textLine.TE_TEXTLINE, charNr)
	Declare Textline_FindText(*textline.TE_TEXTLINE, find.s, *result.TE_RANGE, ignoreWhiteSpace = #False)
	Declare Textline_HasLineContinuation(*te.TE_STRUCT, *textline.TE_TEXTLINE)
	
	Declare SyntaxHighlight_Clear(*te.TE_STRUCT)
	Declare SyntaxHighlight_Update(*te.TE_STRUCT)
	
	Declare Selection_Get(*cursor.TE_CURSOR, *range.TE_RANGE)
	Declare Selection_SetRange(*te.TE_STRUCT, *cursor.TE_CURSOR, lineNr, charNr, highLight = #True, checkOverlap = #True)
	Declare Selection_SelectAll(*te.TE_STRUCT)
	Declare Selection_Clear(*te.TE_STRUCT, *cursor.TE_CURSOR)
	Declare Selection_ClearAll(*te.TE_STRUCT, deleteCursors = #False)
	Declare Selection_Delete(*te.TE_STRUCT, *cursor.TE_CURSOR, *undo.TE_UNDO = #Null)
	Declare.s Selection_Text(*te.TE_STRUCT, delimiter.s = "")
	Declare Selection_Unfold(*te.TE_STRUCT, startLine, endLine)
	Declare Selection_IsAnythingSelected(*te.TE_STRUCT)
	Declare Selection_Overlap(*sel1.TE_RANGE, *sel2.TE_RANGE)
	Declare Selection_HighlightClear(*te.TE_STRUCT)
	
	Declare Cursor_Add(*te.TE_STRUCT, lineNr, charNr, checkOverlap = #True, startSelection = #True)
	Declare Cursor_Delete(*te.TE_STRUCT, *cursor.TE_CURSOR)
	Declare Cursor_Update(*te.TE_STRUCT, *cursor.TE_CURSOR, updateLastX)
	Declare Cursor_DeleteOverlapping(*te.TE_STRUCT, *cursor.TE_CURSOR, joinSelections = #False)
	Declare Cursor_Clear(*te.TE_STRUCT, *maincursor.TE_CURSOR)
	Declare Cursor_Sort(*te.TE_STRUCT, sortOrder = #PB_Sort_Ascending)
	Declare Cursor_Move(*te.TE_STRUCT, *cursor.TE_CURSOR, dirY, dirX)
	Declare Cursor_MoveMulti(*te.TE_STRUCT, *cursor.TE_CURSOR, previousLineNr, dirY, dirX)
	Declare Cursor_Position(*te.TE_STRUCT, *cursor.TE_CURSOR, lineNr, charNr, ensureVisible = #True, updateLastX = #True)
	Declare Cursor_HasSelection(*cursor.TE_CURSOR)
	Declare Cursor_FromScreenPos(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, x, y, addCursor = #False)
	Declare Cursor_InsideComment(*te.TE_STRUCT, *cursor.TE_CURSOR)
	
	Declare Scroll_Line(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, visibleLineNr, keepCursor = #True, updateGadget = #True)
	Declare Scroll_Char(*te.TE_STRUCT, *view.TE_VIEW, charX)
	Declare Scroll_Update(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, previousVisibleLineNr, previousCharNr, updateNeeded = #True)
	Declare Scroll_UpdateAllViews(*te.TE_STRUCT, *view.TE_VIEW, *currentView.TE_VIEW, *cursor.TE_CURSOR)
	Declare Scroll_HideScrollBarH(*te.TE_STRUCT, *view.TE_VIEW, isHidden)
	Declare Scroll_HideScrollBarV(*te.TE_STRUCT, *view.TE_VIEW, isHidden)
	
	Declare Draw(*te.TE_STRUCT, *view.TE_VIEW, cursorBlinkState = -1, redrawMode = 0)
	Declare Draw_Textline(*te.TE_STRUCT, *view.TE_VIEW, *textLine.TE_TEXTLINE, lineNr, x.d, y.d, backgroundColor, *cursor.TE_CURSOR)
	
	Declare Marker_Add(*te.TE_STRUCT, *textline.TE_TEXTLINE, style)
	
	Declare Find_Next(*te.TE_STRUCT, lineNr, charNr, endLineNr, endCharNr, flags)
	Declare Find_Flags(*te.TE_STRUCT)
	Declare Find_Close(*te.TE_STRUCT)
	Declare Find_SetSelectionCheckbox(*te.TE_STRUCT)
	
	Declare Autocomplete_Hide(*te.TE_STRUCT)
	
	Declare Event_Gadget()
	Declare Event_Keyboard(*te.TE_STRUCT, *view.TE_VIEW, eventType)
	Declare Event_Mouse(*te.TE_STRUCT, *view.TE_VIEW, event_type)
	Declare Event_MouseWheel(*te.TE_STRUCT, *view.TE_VIEW, eventType)
	Declare Event_ScrollBar()
	Declare Event_Timer()
	Declare Event_Autocomplete()
	Declare Event_FindReplace()
	Declare Event_Resize(*te.TE_STRUCT, x, y, width, height)
	Declare Event_Window()
	Declare Event_Menu()
	Declare Event_Drop()
	; 	Declare		Event_DropCallback(TargetHandle, State, Format, Action, x, y)
	
	Declare Tokenizer_All(*te.TE_STRUCT)
	Declare Tokenizer_Textline(*te, *textline)
	
	Declare Settings_OpenXml(*te.TE_STRUCT, fileName.s)
	Declare Styling_OpenXml(*te.TE_STRUCT, fileName.s)
	
	Macro ProcedureReturnIf(cond_, retVal_ = 0)
		If cond_
			ProcedureReturn retVal_
		EndIf
	EndMacro
	
	Macro PreferenceString(key_, defaultValue_)
		UnescapeString(ReadPreferenceString((key_), (defaultValue_)))
	EndMacro
	
EndDeclareModule

Module _PBEdit_
	
	EnableExplicit
	
	Procedure DebugPosition(text.s, *position.TE_POSITION)
		If *position
			Debug text + #TAB$ + "lineNr: " + Str(*position\lineNr) + "   charNr: " + Str(*position\charNr)
		EndIf
	EndProcedure
	
	Procedure DebugRange(text.s, *range.TE_RANGE)
		If *range
			DebugPosition(text + " ", DebugPosition("pos1: ", *range\pos1))
			DebugPosition(text + " ", DebugPosition("pos2: ", *range\pos2))
		EndIf
	EndProcedure
	
	;-
	;- ------------ INITIALIZATION -----------
	;-
	
	Procedure Language_Initialize(*te.TE_STRUCT, languageFile.s = "")
		ProcedureReturnIf(*te = #Null)
		
		If languageFile = ""
			languageFile = "language_EN.cfg"
		EndIf
		
		*te\laguage\fileName = languageFile
		
		OpenPreferences(languageFile)
		PreferenceGroup("Messages")
		*te\laguage\warningTitle = PreferenceString("WarningTitle", "Warning")
		*te\laguage\warningLongText = PreferenceString("WarningLongText", "Very long text (%N1 characters) at %N2 locations.\n Insert anyway ?")
		
		*te\laguage\errorTitle = PreferenceString("ErrorTitle", "Error")
		*te\laguage\errorRegEx = PreferenceString("ErrorRegEx", "Error in Regular Expression")
		
		*te\laguage\errorNotFound = PreferenceString("ErrorNotFound", "%N1\nnot found")
		
		
		*te\laguage\gotoTitle = PreferenceString("GotoTitle", "Goto...")
		*te\laguage\gotoMessage = PreferenceString("GotoMessage", "Line number")
		
		*te\laguage\messageTitleFindReplace = PreferenceString("MessageTitleFindReplace", "Find/Replace")
		*te\laguage\messageNoMoreMatches = PreferenceString("MessageNoMoreMatches", "No more matches found.")
		*te\laguage\messageNoMoreMatchesEnd = PreferenceString("MessageNoMoreMatchesEnd", "No more matches found.\nDo you want To search from the end of the file?")
		*te\laguage\messageNoMoreMatchesStart = PreferenceString("MessageNoMoreMatchesStart", "No more matches found.\nDo you want To search from the start of the file?")
		*te\laguage\messageReplaceComplete = PreferenceString("MessageReplaceComplete", "Find/Replace complete.\n%N1 matches found.")
		ClosePreferences()
	EndProcedure
	
	;-
	
	Procedure Editor_New_AutocompleteWindow(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\window) = 0))
		
		With *te\autocomplete
			; Style_LoadFont(*te, \font, *te\font(0)\name, *te\font(0)\height)
			\enabled = #True
			\font = *te\font(0)
			\wnd_autocomplete = OpenWindow(#PB_Any, 0, 0, 250, 200, "PBEdit_Autocomplete", #PB_Window_BorderLess | #PB_Window_Invisible, WindowID(*te\window))
			\lst_listBox = ListViewGadget(#PB_Any, 0, 0, 250, 200)
			\minCharacterCount = 3
			\maxRows = 15
			\mode = #TE_Autocomplete_FindAny
			
			SetGadgetData(\lst_listBox, *te)
			StickyWindow(\wnd_autocomplete, #True)
			
			If \font\id And IsFont(\font\nr)
				SetGadgetFont(\lst_listBox, \font\id)
			EndIf
			
			BindEvent(#PB_Event_Gadget, @Event_Autocomplete(), \wnd_autocomplete, \lst_listBox)
		EndWith
	EndProcedure
	
	Procedure Editor_New_FindWindow(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		OpenPreferences(*te\laguage\fileName)
		PreferenceGroup("FindReplace")
		
		With *te\find
			\wnd_findReplace = OpenWindow(#PB_Any, 0, 0, 545, 205, PreferenceString("wnd_findReplace", "Find/Replace"), #PB_Window_SystemMenu | #PB_Window_Invisible, WindowID(*te\window))
			\cmb_search = ComboBoxGadget(#PB_Any, 150, 10, 380, 20, #PB_ComboBox_Editable)
			\txt_search = TextGadget(#PB_Any, 10, 10, 130, 20, PreferenceString("txt_search", "Search for") + ":", #PB_Text_Right)
			\chk_replace = CheckBoxGadget(#PB_Any, 10, 40, 130, 20, PreferenceString("chk_replace", "Replace with") + ":")
			\cmb_replace = ComboBoxGadget(#PB_Any, 150, 40, 380, 20, #PB_ComboBox_Editable)
			\frm_0 = FrameGadget(#PB_Any, 10, 75, 520, 75, "", #PB_Frame_Single)
			\chk_caseSensitive = CheckBoxGadget(#PB_Any, 20, 85, 180, 20, PreferenceString("chk_caseSensitive", "Case Sensitive"))
			\chk_wholeWords = CheckBoxGadget(#PB_Any, 20, 105, 180, 20, PreferenceString("chk_wholeWords", "Whole Words only"))
			\chk_insideSelection = CheckBoxGadget(#PB_Any, 20, 125, 180, 20, PreferenceString("chk_insideSelection", "Search inside Selection only"))
			\chk_noComments = CheckBoxGadget(#PB_Any, 280, 85, 180, 20, PreferenceString("chk_noComments", "Don't search in Comments"))
			\chk_noStrings = CheckBoxGadget(#PB_Any, 280, 105, 180, 20, PreferenceString("chk_noStrings", "Don't search in Strings"))
			\chk_regEx = CheckBoxGadget(#PB_Any, 280, 125, 180, 20, PreferenceString("chk_regEx", "Regular Expression"))
			\btn_findNext = ButtonGadget(#PB_Any, 10, 160, 80, 25, PreferenceString("btn_findNext", "Find Next"))
			\btn_findPrevious = ButtonGadget(#PB_Any, 115, 160, 80, 25, PreferenceString("btn_findPrevious", "Find Previous"))
			\btn_replace = ButtonGadget(#PB_Any, 245, 160, 70, 25, PreferenceString("btn_replace", "Replace"))
			\btn_replaceAll = ButtonGadget(#PB_Any, 340, 160, 110, 25, PreferenceString("btn_replaceAll", "Replace All"))
			\btn_close = ButtonGadget(#PB_Any, 455, 160, 80, 25, PreferenceString("btn_close", "Close"))
			\isVisible = #False
			
			RemoveKeyboardShortcut(\wnd_findReplace, #PB_Shortcut_All)
			AddKeyboardShortcut(\wnd_findReplace, #PB_Shortcut_Return, #TE_Menu_ReturnKey)
			AddKeyboardShortcut(\wnd_findReplace, #PB_Shortcut_Escape, #TE_Menu_EscapeKey)
			
			SetWindowData(\wnd_findReplace, *te)
			
			DisableGadget(\cmb_replace, 1)
			DisableGadget(\btn_replace, 1)
			DisableGadget(\btn_replaceAll, 1)
			DisableGadget(\chk_insideSelection, 1)
			
			BindEvent(#PB_Event_CloseWindow, @Event_FindReplace(), \wnd_findReplace)
			BindEvent(#PB_Event_Menu, @Event_FindReplace(), \wnd_findReplace, #PB_All, #PB_All)
			BindEvent(#PB_Event_Gadget, @Event_FindReplace())
		EndWith
		ClosePreferences()
	EndProcedure
	
	Procedure Editor_New_PopupMenu(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected separator.s = "\t\t\t\t\t"
		
		*te\popupMenu = CreatePopupImageMenu(#PB_Any)
		If *te\popupMenu
			OpenPreferences(*te\laguage\fileName)
			PreferenceGroup("PopupMenu")
			
			MenuItem(#TE_Menu_Cut, PreferenceString("Cut", "Cut" + separator + "Ctrl+X"))
			MenuItem(#TE_Menu_Copy, PreferenceString("Copy", "Copy" + separator + "Ctrl+C"))
			MenuItem(#TE_Menu_Paste, PreferenceString("Paste", "Paste" + separator + "Ctrl+V"))
			MenuBar()
			MenuItem(#TE_Menu_InsertComment, PreferenceString("InsertComments", "Insert comments" + separator + "Ctrl+B"))
			MenuItem(#TE_Menu_RemoveComment, PreferenceString("RemoveComments", "Remove comments" + separator + "Ctrl+Shift+B"))
			MenuItem(#TE_Menu_FormatIndentation, PreferenceString("FormatIndentation", "Format indentation" + separator + "Ctrl+I"))
			MenuBar()
			MenuItem(#TE_Menu_ToggleFold, PreferenceString("ToggleFold", "Toggle current fold" + separator + "F4"))
			MenuItem(#TE_Menu_ToggleAllFolds, PreferenceString("ToggleAllFolds", "Toggle all folds" + separator + "Ctrl+F4"))
			MenuBar()
			OpenSubMenu( PreferenceString("SplitView", "Split View"))
			MenuItem(#TE_Menu_SplitViewHorizontal, PreferenceString("Horizontal", "Horizontal"))
			MenuItem(#TE_Menu_SplitViewVertical, PreferenceString("Vertical", "Vertical"))
			CloseSubMenu()
			MenuItem(#TE_Menu_UnsplitView, PreferenceString("UnsplitView", "Unsplit View"))
			MenuBar()
			MenuItem(#TE_Menu_SelectAll, PreferenceString("Select All", "Select All" + separator + "Ctrl+A"))
			
			BindEvent(#PB_Event_Menu, @Event_Menu())
			ClosePreferences()
		EndIf
	EndProcedure
	
	Procedure Editor_New(window, x, y, width, height, languageFile.s = "")
		ProcedureReturnIf(IsWindow(window) = 0)
		
		Protected *te.TE_STRUCT = AllocateStructure(TE_STRUCT)
		
		ProcedureReturnIf(*te = #Null)
		
		InitializeStructure(*te, TE_STRUCT)
		
		UseGadgetList(WindowID(window))
		
		Parser_Initialize(*te\parser)
		Language_Initialize(*te, languageFile)
		
		*te\window = window
		
		*te\x = x
		*te\y = y
		*te\width = width
		*te\height = height
		
		*te\enableScrollBarHorizontal = #TE_ScrollbarEnabled
		*te\enableScrollBarVertical = #TE_ScrollbarEnabled
		*te\enableStyling = #False
		*te\enableLineNumbers = #False
		*te\enableShowCurrentLine = #False
		*te\enableFolding = #False
		*te\enableIndentation = #False
		*te\enableCaseCorrection = #False
		*te\enableShowWhiteSpace = #False
		*te\enableIndentationLines = #False
		*te\enableAutoComplete = #False
		*te\enableDictionary = #False
		*te\enableSyntaxCheck = #False
		*te\enableBeautify = #False
		*te\enableMultiCursor = #False
		*te\enableSplitScreen = #False
		*te\enableHighlightSelection = #False
		*te\enableSelectPastedText = #False
		
		*te\highlightMode = #PB_String_NoCase
		
		*te\indentationMode = #TE_Indentation_None
		*te\useRealTab = #True
		*te\tabSize = 4
		
		*te\cursorState\clickSpeed = 500
		*te\cursorState\blinkDelay = 500
		*te\cursorState\firstClickTime = ElapsedMilliseconds() - 1000
		*te\cursorState\compareMode = #PB_String_NoCase; #PB_String_CaseSensitive
		
		*te\fontName = "Consolas"
		*te\lineHeight = 11
		*te\maxLineWidth = 0
		*te\scrollbarWidth = 15
		*te\topBorderSize = 0
		*te\leftBorderSize = 5
		*te\leftBorderOffset = BorderSize(*te)
		*te\newLineChar = #LF
		*te\newLineText = Chr(*te\newLineChar)
		
		With *te\colors
			\defaultTextColor = RGBA( 0, 0, 0, 255)
			\selectedTextColor = RGBA(255, 255, 255, 255)
			\cursor = RGBA( 0, 0, 0, 255)
			\inactiveBackground = RGBA(128, 128, 128, 255)
			\currentBackground = RGBA(255, 255, 255, 255)
			\selectionBackground = RGBA( 0, 120, 215, 255)
			\currentLine = RGBA(220, 220, 220, 255)
			\currentLineBackground = RGBA(220, 220, 220, 255)
			\inactiveLineBackground = RGBA( 64, 64, 64, 255)
			\indentationGuides = RGBA( 64, 64, 64, 255)
			\repeatedSelections = RGBA(200, 200, 200, 255)
			\lineNr = RGBA( 32, 32, 32, 255)
			\currentLineNr = RGBA(128, 128, 128, 255)
			\lineNrBackground = RGBA(220, 220, 220, 255)
			\foldIcon = RGBA( 0, 0, 0, 255)
			\foldIconBorder = RGBA( 0, 0, 0, 255)
			\foldIconBackground = RGBA(255, 255, 255, 255)
		EndWith
		
		SetWindowData(*te\window, *te)
		
		RemoveKeyboardShortcut(*te\window, #PB_Shortcut_All)
		
		BindEvent(#PB_Event_SizeWindow, @Event_Window(), window)
		BindEvent(#PB_Event_MoveWindow, @Event_Window(), window)
		BindEvent(#PB_Event_DeactivateWindow, @Event_Window(), window)
		
		AddWindowTimer(window, #TE_Timer_CursorBlink, *te\cursorState\blinkDelay)
  		BindEvent(#PB_Event_Timer, @Event_Timer(), window)
		
		Editor_New_FindWindow(*te)
		Style_SetFont(*te, *te\fontName, *te\lineHeight)
		Style_SetDefaultStyle(*te)
		
		Editor_New_AutocompleteWindow(*te)
		Editor_New_PopupMenu(*te)
		
		*te\view = View_Add(*te, x, y, width, height, #Null)
		*te\currentView = *te\view
		
		Textline_Add(*te)
		Folding_Update(*te, -1, -1)
		
		If *te\view = #Null
			FreeStructure(*te)
			ProcedureReturn #Null
		EndIf
		
		Cursor_Add(*te, 1, 1, #False, #False)
		
		Folding_Update(*te, -1, -1)
		Scroll_Update(*te, *te\view, *te\maincursor, -1, -1)
		
		; 			Draw(*te, *te\view, -1, #TE_Redraw_All)
		
		ProcedureReturn *te
	EndProcedure
	
	;-
	;- ------------ VIEW -----------
	;-
	
	Procedure View_Add(*te.TE_STRUCT, x, y, width, height, *parent.TE_VIEW, *view.TE_VIEW = #Null)
		ProcedureReturnIf( (*te = #Null) Or (width < 1) Or (height < 1))
		
		If *view = #Null
			*view.TE_VIEW = AllocateStructure(TE_VIEW)
		EndIf
		
		If *view = #Null
			ProcedureReturn #Null
		EndIf
		
		UseGadgetList(WindowID(*te\window))
		
		*view\canvas = CanvasGadget(#PB_Any, x, y, width, height, #PB_Canvas_Border | #PB_Canvas_Keyboard)
		
		If IsGadget(*view\canvas) = 0
			ProcedureReturn #Null
		EndIf
		
		SetActiveGadget(*view\canvas)
		
		*view\editor = *te
		*view\parent = *parent
		
		*view\x = x
		*view\y = y
		*view\width = width
		*view\height = height
		*view\zoom = 1.0
		
		*view\scroll\visibleLineNr = 1
		*view\scroll\charX = 1
		*view\scroll\scrollDelay = 25
		
		*view\scrollBarV\enabled = *te\enableScrollBarVertical
		
		*view\scrollBarH\enabled = *te\enableScrollBarHorizontal
		*view\scrollBarH\scale = 10
		; fixed scroll change
; 		*view\scrollBarV\gadget = ScrollBarGadget(#PB_Any, x + width - *te\scrollbarWidth, y, *te\scrollbarWidth, height, 0, 1, 1, #PB_ScrollBar_Vertical)
; 		*view\scrollBarH\gadget = ScrollBarGadget(#PB_Any, x, y + height - *te\scrollbarWidth, width, *te\scrollbarWidth, 0, 1, 1)
		
		widget::Open(*te\window, x, y, width, height, "", 0,0, *view\canvas)
		*view\scrollBarV\gadget = widget::Scroll(x + width - *te\scrollbarWidth, y, *te\scrollbarWidth, height, 0, 1, 1, #PB_ScrollBar_Vertical)
		*view\scrollBarH\gadget = widget::Scroll(x, y + height - *te\scrollbarWidth, width, *te\scrollbarWidth, 0, 1, 1)
		
		*view\scrollBarV\isHidden = #True
		*view\scrollBarH\isHidden = #True
		widget::Hide(*view\scrollBarV\gadget, #True)
		widget::Hide(*view\scrollBarH\gadget, #True)
		
		widget::SetAttribute(*view\scrollBarV\gadget, constants::#__Bar_Maximum, #TE_MaxScrollbarHeight)
		
		SetGadgetData(*view\canvas, *view)
		
		widget::SetData(*view\scrollBarV\gadget, *view)
		widget::SetData(*view\scrollBarH\gadget, *view)
		SetGadgetAttribute(*view\canvas, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
		
		EnableGadgetDrop(*view\canvas, #PB_Drop_Text, #PB_Drag_Copy, *view)
		; 		SetDropCallback(@Event_DropCallback())
		
		BindEvent(#PB_Event_GadgetDrop, @Event_Drop())
		BindEvent(#PB_Event_Gadget, @Event_Gadget(), *te\window, *view\canvas)
		widget::Bind(*view\scrollBarH\gadget, @Event_ScrollBar())
		widget::Bind(*view\scrollBarV\gadget, @Event_ScrollBar())
		
		*te\currentView = *view
		*te\redrawMode | #TE_Redraw_All
		
		If *te\currentCursor
			Scroll_Update(*te, *view, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr)
		EndIf
		
		ProcedureReturn *view
	EndProcedure
	
	Procedure View_Clear(*te.TE_STRUCT, *view.TE_VIEW)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		View_Clear(*te, *view\child[0])
		View_Clear(*te, *view\child[1])
		
		If IsGadget(*view\canvas)
			UnbindEvent(#PB_Event_Gadget, @Event_Gadget(), *te\window, *view\canvas)
			
			FreeGadget(*view\canvas)
		EndIf
		
		If (*view\scrollBarH\gadget)
			widget::Unbind(*view\scrollBarH\gadget, @Event_ScrollBar())
			
			widget::Free(*view\scrollBarH\gadget)
		EndIf
		
		If (*view\scrollBarV\gadget)
			widget::Unbind(*view\scrollBarV\gadget, @Event_ScrollBar())
			
			widget::Free(*view\scrollBarV\gadget)
		EndIf
		
		*view\canvas = #Null
		*view\scrollBarH\gadget = #Null
		*view\scrollBarV\gadget = #Null
	EndProcedure
	
	Procedure View_Delete(*te.TE_STRUCT, *view.TE_VIEW)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*view = *te\view))
		
		View_Clear(*te, *view)
		
		View_Delete(*te, *view\child[0])
		View_Delete(*te, *view\child[1])
		
		FreeStructure(*view)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure View_Unsplit(*te.TE_STRUCT, x, y)
		ProcedureReturnIf(*te = #Null)
		
		Protected *parent.TE_VIEW
		
		x / DesktopResolutionX()
		y / DesktopResolutionY()
		
		If View_FromMouse(*te, *te\view, x, y) = #False
			ProcedureReturn #False
		EndIf
		
		If *te\currentView\parent
			*parent = *te\currentView\parent
			
			View_Delete(*te, *parent\child[0])
			View_Delete(*te, *parent\child[1])
			
			*parent\child[0] = #Null
			*parent\child[1] = #Null
			
			If View_Add(*te, *parent\x, *parent\y, *parent\width, *parent\height, *parent\parent, *parent)
				*te\redrawMode | #TE_Redraw_All
				ProcedureReturn #True
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure View_Split(*te.TE_STRUCT, x, y, splitMode = #TE_View_SplitHorizontal)
		ProcedureReturnIf( (*te = #Null) Or (*te\enableSplitScreen = #False))
		
		Protected *view.TE_VIEW
		Protected width, height, width2, height2
		Protected splitPosition.d = 0.5
		
		x / DesktopResolutionX()
		y / DesktopResolutionY()
		
		If View_FromMouse(*te, *te\view, x, y) = #False
			ProcedureReturn #False
		EndIf
		
		If splitPosition < 0
			splitPosition = 0
		ElseIf splitPosition > 1
			splitPosition = 1
		EndIf
		
		If *te\currentView
			*view = *te\currentView
			
			If (splitMode = #TE_View_SplitVertical) And (*view\width > 0)
				; split horizontal
				
				; 				splitPosition = ((x - *view\x) / *view\width * 1.0)
				
				x = *view\x + (*view\width * splitPosition)
				y = *view\y
				width = *view\width * (1 - splitPosition)
				height = *view\height
				
				width2 = *view\width * splitPosition
				height2 = *view\height
			ElseIf (splitMode = #TE_View_SplitHorizontal) And (*view\height > 0)
				; split vertical
				
				; 				splitPosition = ((y - *view\y) / *view\height * 1.0)
				
				x = *view\x
				y = *view\y + (*view\height * splitPosition)
				width = *view\width
				height = *view\height * (1 - splitPosition)
				
				width2 = *view\width
				height2 = *view\height * splitPosition
			Else
				ProcedureReturn #False
			EndIf
			
			View_Clear(*te, *view)
			
			*view\child[0] = View_Add(*te, x, y, width, height, *view)
			*view\child[1] = View_Add(*te, *view\x, *view\y, width2, height2, *view)
			
			If *view\child[0] And *view\child[1]
				*te\redrawMode | #TE_Redraw_All
				ProcedureReturn #True
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure View_Get(*te.TE_STRUCT, *view.TE_VIEW)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		If IsGadget(*view\canvas)
			Scroll_Update(*te, *view, *te\currentCursor, *view\firstVisibleLineNr, -1)
			ProcedureReturn #True
		EndIf
		
		View_Get(*te, *view\child[0])
		View_Get(*te, *view\child[1])
	EndProcedure
	
	Procedure View_FromMouse(*te.TE_STRUCT, *view.TE_VIEW, x, y)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		If IsGadget(*view\canvas) And (x >= *view\x) And (x < *view\x + *view\width) And (y >= *view\y) And (y < *view\y + *view\height)
			*te\currentView = *view
			SetActiveGadget(*view\canvas)
			
			ProcedureReturn *view
		EndIf
		
		If View_FromMouse(*te, *view\child[0], x, y)
			ProcedureReturn #True
		ElseIf View_FromMouse(*te, *view\child[1], x, y)
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure View_Zoom(*te.TE_STRUCT, *view.TE_VIEW, direction)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		Protected oldZoom.d = *view\zoom
		
		If direction = 0
			*view\zoom = 1.0
		ElseIf direction < 0
			*view\zoom / 0.9
		Else
			*view\zoom * 0.9
		EndIf
		
		If *view\zoom < 0.1
			*view\zoom = 0.1
		ElseIf *view\zoom > 2.0
			*view\zoom = 2.0
		EndIf
		
		Autocomplete_Hide(*te)
		Scroll_Update(*te, *view, *te\currentCursor, -1, 1)
		*te\redrawMode | #TE_Redraw_All
		
		If oldZoom = *view\zoom
			ProcedureReturn #False
		Else
			ProcedureReturn #True
		EndIf
	EndProcedure
	
	Procedure View_Resize(*te.TE_STRUCT, *view.TE_VIEW, x, y, width, height)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		If *view\width
			Protected scaleX.d = (width * 1.0) / *view\width
		EndIf
		
		If *view\height
			Protected scaleY.d = (height * 1.0) / *view\height
		EndIf
		
		If x = #PB_Ignore
			x = *view\x
		EndIf
		
		If y = #PB_Ignore
			y = *view\y
		EndIf
		
		If width = #PB_Ignore
			width = *view\width
		EndIf
		
		If height = #PB_Ignore
			height = *view\height
		EndIf
		
		If #PB_Compiler_OS <> #PB_OS_Windows
			height - *te\scrollbarWidth
		EndIf
		
		*view\x = x
		*view\y = y
		*view\width = width
		*view\height = height
		
		If IsGadget(*view\canvas)
			Scroll_HideScrollBarH(*te, *view, #True)
			Scroll_HideScrollBarV(*te, *view, #True)
			
			ResizeGadget(*view\canvas, *view\x, *view\y, *view\width, *view\height)
			
			Scroll_Update(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr, *view\scroll\charX)
		EndIf
		
		If *view\child[0]
			View_Resize(*te, *view\child[0], *view\child[0]\x * scaleX, *view\child[0]\y * scaleY, *view\child[0]\width * scaleX, *view\child[0]\height * scaleY)
		EndIf
		If *view\child[1]
			View_Resize(*te, *view\child[1], *view\child[1]\x * scaleX, *view\child[1]\y * scaleY, *view\child[1]\width * scaleX, *view\child[1]\height * scaleY)
		EndIf
	EndProcedure
	
	;-
	;- ------------ FUNCTIONS -----------
	;-
	
	Procedure Max(a, b)
		If a > b : ProcedureReturn a : EndIf
		ProcedureReturn b
	EndProcedure
	
	Procedure Min(a, b)
		If a < b : ProcedureReturn a : EndIf
		ProcedureReturn b
	EndProcedure
	
	Procedure Clamp(value, min, max)
		If value < min : value = min : EndIf
		If value > max : value = max : EndIf
		ProcedureReturn value
	EndProcedure
	
	Procedure TokenType(*parser.TE_PARSER, c.c)
		ProcedureReturnIf( (*parser = #Null) Or (c < 0) Or (c > #TE_CharRange))
		
		ProcedureReturn *parser\tokenType(c)
	EndProcedure
	
	Procedure.s TokenName(*token.TE_TOKEN)
		ProcedureReturnIf(*token = #Null, "")
		
		ProcedureReturn TokenEnumName(*token\type)
	EndProcedure
	
	Procedure LineNr_from_VisibleLineNr(*te.TE_STRUCT, visibleLineNr)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0))
		
		Protected lineNr = visibleLineNr
		Protected *textBlock.TE_TEXTBLOCK
		
		ForEach *te\textBlock()
			If *te\textBlock()\firstVisibleLineNr >= visibleLineNr
				Break
			Else
				If (*textBlock = #Null) Or ( (*textBlock\firstLine\foldState <> #TE_Folding_Folded) Or (*te\textBlock()\firstLineNr >= *textBlock\lastLineNr))
					*textBlock = *te\textBlock()
				EndIf
			EndIf
		Next
		
		If *textBlock
			If *textBlock\firstLine\foldState = #TE_Folding_Folded
				lineNr = *textBlock\lastLineNr + (visibleLineNr - *textBlock\firstVisibleLineNr)
			Else
				lineNr = *textBlock\firstLineNr + (visibleLineNr - *textBlock\firstVisibleLineNr)
			EndIf
		EndIf
		
		ProcedureReturn Clamp(lineNr, 1, ListSize(*te\textLine()))
	EndProcedure
	
	Procedure LineNr_to_VisibleLineNr(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0))
		
		Protected visibleLineNr = lineNr
		Protected *textBlock.TE_TEXTBLOCK
		
		ForEach *te\textBlock()
			If *te\textBlock()\firstLineNr >= lineNr
				Break
			Else
				If (*textBlock = #Null) Or ( (*textBlock\firstLine\foldState <> #TE_Folding_Folded) Or (*te\textBlock()\firstLineNr >= *textBlock\lastLineNr))
					*textBlock = *te\textBlock()
				EndIf
			EndIf
		Next
		
		If *textBlock
			If *textBlock\firstLine\foldState = #TE_Folding_Folded
				visibleLineNr = *textBlock\lastVisibleLineNr + (lineNr - *textBlock\lastLineNr)
			Else
				visibleLineNr = *textBlock\firstVisibleLineNr + (lineNr - *textBlock\firstLineNr)
			EndIf
		EndIf
		
		ProcedureReturn Clamp(visibleLineNr, 1, *te\visibleLineCount)
	EndProcedure
	
	Procedure FoldiconSize(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		ProcedureReturn Int(*te\lineHeight * 0.6 * 0.5) << 1
	EndProcedure
	
	Procedure BorderSize(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected size = *te\leftBorderSize
		Protected textLine.TE_TEXTLINE
		Protected FoldiconSize
		Protected nrLines
		
		If *te\enableFolding
			size + FoldiconSize(*te) + 8
		EndIf
		If *te\enableLineNumbers
			nrLines = max(1, ListSize(*te\textLine()))
			textLine\text = RSet(Str(nrLines), Int(Log10(ListSize(*te\textLine())) + 1))
			size + Textline_Width(*te, textLine)
		EndIf
		
		ProcedureReturn size
	EndProcedure
	
	Procedure Position_InsideRange(*pos.TE_POSITION, *range.TE_RANGE, includeBorder = #True)
		; test if lineNr/charNr is inside given range
		;
		; returnvalues:
		;  0	-		not inside range
		; -1	-		position near range start
		;  1	-		position near range end
		
		ProcedureReturnIf( (*pos = #Null) Or (*range = #Null))
		ProcedureReturnIf( (*pos\lineNr < *range\pos1\lineNr) Or (*pos\lineNr > *range\pos2\lineNr))
		
		If includeBorder
			ProcedureReturnIf( (*pos\lineNr = *range\pos1\lineNr) And (*pos\charNr <= *range\pos1\charNr))
			ProcedureReturnIf( (*pos\lineNr = *range\pos2\lineNr) And (*pos\charNr >= *range\pos2\charNr))
		Else
			ProcedureReturnIf( (*pos\lineNr = *range\pos1\lineNr) And (*pos\charNr < *range\pos1\charNr))
			ProcedureReturnIf( (*pos\lineNr = *range\pos2\lineNr) And (*pos\charNr > *range\pos2\charNr))
		EndIf
		
		If (*pos\lineNr = *range\pos1\lineNr) And (*pos\lineNr = *range\pos2\lineNr)
			If Abs(*pos\charNr - *range\pos1\charNr) < Abs(*pos\charNr - *range\pos2\charNr)
				ProcedureReturn -1
			Else
				ProcedureReturn 1
			EndIf
		ElseIf Abs(*pos\lineNr - *range\pos1\lineNr) < Abs(*pos\lineNr - *range\pos2\lineNr)
			ProcedureReturn -1
		Else
			ProcedureReturn 1
		EndIf
		
		ProcedureReturn 0
	EndProcedure
	
	Procedure Position_InsideSelection(*te.TE_STRUCT, *view.TE_VIEW, screenX, screenY, checkBorder = #False)
		; test if the screen-position screenX/screenY is insinde a selection
		;
		; returnvalues:	*cursor - selection found
		;				#Null	- no selection found
		
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		Protected *result.TE_CURSOR
		Protected selection.TE_RANGE
		Protected selText.s
		Protected pos.TE_POSITION
		
		pos\lineNr = Textline_LineNrFromScreenPos(*te, *view, screenY)
		pos\charNr = Textline_CharNrFromScreenPos(*te, Textline_FromLine(*te, pos\lineNr), screenX - *te\leftBorderOffset + *view\scroll\charX)
		
		PushListPosition(*te\cursor())
		ForEach *te\cursor()
			If Selection_Get(*te\cursor(), selection)
				If Position_InsideRange(pos, selection, checkBorder)
					*result = *te\cursor()
					Break
				EndIf
			EndIf
		Next
		PopListPosition(*te\cursor())
		
		ProcedureReturn *result
	EndProcedure
	
	Procedure Position_Equal(*pos1.TE_POSITION, *pos2.TE_POSITION)
		ProcedureReturnIf( (*pos1 = #Null) Or (*pos2 = #Null))
		
		If (*pos1\lineNr <> *pos2\lineNr) Or (*pos1\charNr <> *pos2\charNr)
			ProcedureReturn #False
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Position_Changed(*pos1.TE_POSITION, *pos2.TE_POSITION)
		ProcedureReturnIf( (*pos1 = #Null) Or (*pos2 = #Null))
		
		If (*pos1\lineNr <> *pos2\lineNr) Or (*pos1\charNr <> *pos2\charNr)
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	;-
	;- ----------- TEXT -----------
	;-
	
	Procedure.s Text_Get(*te.TE_STRUCT, startLineNr, startCharNr, endLineNr, endCharNr)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0), "")
		ProcedureReturnIf( (startLineNr < 1) Or (endLineNr <= 0), "")
		
		Protected size, nrLines
		Protected head.s, tail.s, *tail.Character
		
		If startLineNr > endLineNr
			Swap startLineNr, endLineNr
			Swap startCharNr, endCharNr
		ElseIf (startLineNr = endLineNr) And (startCharNr > endCharNr)
			Swap startCharNr, endCharNr
		EndIf
		
		startLineNr = Clamp(startLineNr, 1, ListSize(*te\textLine()))
		endLineNr = Clamp(endLineNr, 1, ListSize(*te\textLine()))
		nrLines = (endLineNr - startLineNr) + 1
		
		PushListPosition(*te\textLine())
		
		If SelectElement(*te\textLine(), startLineNr - 1)
			If nrLines = 1
				head.s = Mid(*te\textLine()\text + *te\newLineText, startCharNr, endCharNr - startCharNr)
			ElseIf nrLines > 1
				head = Mid(*te\textLine()\text + *te\newLineText, startCharNr)
				
				If nrLines = 2
					If NextElement(*te\textLine())
						tail = Left(*te\textLine()\text + *te\newLineText, endCharNr - 1)
					EndIf
				Else 
					; calculate needed string size
					PushListPosition(*te\textLine())
					While (nrLines > 2) And NextElement(*te\textLine())
						size + Len(*te\textLine()\text + *te\newLineText)
						nrLines - 1
					Wend
					PopListPosition(*te\textLine())
					
					; create empty string
					tail = Space(size)
					*tail = @tail
					
					nrLines = (endLineNr - startLineNr) + 1
					While (nrLines > 2) And NextElement(*te\textLine())
						PokeS(*tail, *te\textLine()\text + *te\newLineText)
						*tail + StringByteLength(*te\textLine()\text + *te\newLineText)
						nrLines - 1
					Wend
					
					If NextElement(*te\textLine())
						tail + Left(*te\textLine()\text + *te\newLineText, endCharNr - 1)
					EndIf
				EndIf
			EndIf
		EndIf
		
		PopListPosition(*te\textLine())
		ProcedureReturn head + tail
	EndProcedure
	
	Procedure.s Text_Cut(text.s, startPos, length = 0)
		If text
			If length = 0
				ProcedureReturn Left(text, startPos - 1)
			Else
				ProcedureReturn Left(text, startPos - 1) + Mid(text, startPos + length)
			EndIf
		EndIf
		ProcedureReturn ""
	EndProcedure
	
	Procedure.s Text_Replace(text.s, replaceText.s, pos)
		text = Left(text, pos - 1) + 
		Left(replaceText, Len(text) - pos + 1) + 
		Mid(text, pos + Len(replaceText))
		ProcedureReturn text
	EndProcedure
	
	Procedure.s TokenText(*token.TE_TOKEN)
		If *token And (*token\size > 0)
			ProcedureReturn PeekS(*token\text, *token\size)
		EndIf
		ProcedureReturn ""
	EndProcedure
	
	
	;-
	;- ----------- UNDO -----------
	;-
	
	Procedure Undo_Start(*undo.TE_UNDO)
		ProcedureReturnIf(*undo = #Null)
		
		Protected result = ListSize(*undo\entry())
		Undo_Add(*undo, #TE_Undo_Start)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Undo_Add(*undo.TE_UNDO, action, startLineNr = 0, startCharNr = 0, endLineNr = 0, endCharNr = 0, text.s = "")
		ProcedureReturnIf(*undo = #Null)
		
		Protected *entry.TE_UNDOENTRY = LastElement(*undo\entry())
		
		If action = #TE_Undo_Start
			If *entry And (*entry\action = #TE_Undo_Start)
				; prevent adding multiple undo-start-markers
				ProcedureReturn #Null
			EndIf
		ElseIf (action = #TE_Undo_AddText) And ( (startLineNr = endLineNr) And (startCharNr = endCharNr))
			ProcedureReturn #Null
		ElseIf (action = #TE_Undo_DeleteText) And text = ""
			ProcedureReturn #Null
		EndIf
		
		*entry = AddElement(*undo\entry())
		If *entry
			*entry\action = action
			*entry\text = text
			*entry\startPos\lineNr = startLineNr
			*entry\startPos\charNr = startCharNr
			*entry\endPos\lineNr = endLineNr
			*entry\endPos\charNr = endCharNr
			
			; 			Select action
			; 				Case #TE_Undo_Start
			; 					Debug ""
			; 					Debug "  undo start (Undo-ID " + Str(*undo) + ")"
			; 				Case #TE_Undo_AddText				
			; 					Debug "  add text at: " + 
			; 					      "start <" + Str(*entry\startPos\lineNr) + ", " + Str(*entry\startPos\charNr) + "] end <" + Str(*entry\endPos\lineNr) + ", " + Str(*entry\endPos\charNr) + "]"
			; 				Case #TE_Undo_DeleteText
			; 					Debug "  delete text: " + ReplaceString(ReplaceString(*entry\text, Chr(10), "<\n]"), #TAB$, "<TAB]")
			; 					Debug "  start <" + Str(*entry\startPos\lineNr) + ", " + Str(*entry\startPos\charNr) + "]"
			; 			EndSelect
			
		EndIf
		
		ProcedureReturn *entry
	EndProcedure
	
	Procedure Undo_Do(*te.TE_STRUCT, *undo.TE_UNDO, *redo.TE_UNDO)
		ProcedureReturnIf( (*te = #Null) Or (*undo = #Null) Or (*redo = #Null))
		
		Protected quit
		Protected *entry.TE_UNDOENTRY = LastElement(*undo\entry())
		
		If *entry = #Null
			ProcedureReturn #False
		EndIf
		
		Selection_ClearAll(*te, #True)
		
		Undo_Add(*redo, #TE_Undo_Start)
		
		Repeat
			Select *entry\action
					
				Case #TE_Undo_Start
					
					quit = #True
					
				Case #TE_Undo_AddText
					
					Cursor_Position(*te, *te\currentCursor, *entry\startPos\lineNr, *entry\startPos\charNr, #False, #False)
					Selection_SetRange(*te, *te\currentCursor, *entry\endPos\lineNr, *entry\endPos\charNr, #False, #False)
					Selection_Delete(*te, *te\currentCursor, *redo)
					
				Case #TE_Undo_DeleteText
					
					Cursor_Position(*te, *te\currentCursor, *entry\startPos\lineNr, *entry\startPos\charNr, #False, #False)
					Textline_AddText(*te, *te\currentCursor, @*entry\text, Len(*entry\text), #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *redo)
					
			EndSelect
			
			; 			If *te\needFoldUpdate
			; 				Folding_Update(*te, -1, -1)
			; 			EndIf
			
			*entry = DeleteElement(*undo\entry())
		Until quit Or (*entry = #Null)
		
		Selection_ClearAll(*te, #True)
		
		If *te\needFoldUpdate
			Folding_Update(*te, -1, -1)
		EndIf
		Scroll_Update(*te, *te\currentView, *te\currentCursor, -1, -1)
		
		Draw(*te, *te\view)
		
		ProcedureReturn #True
	EndProcedure
	
	
	Procedure Undo_Update(*te.TE_STRUCT)
		; remove undo-start-markers from end of undo list
		
		ProcedureReturnIf(*te = #Null)
		
		Protected result = #False
		
		While LastElement(*te\undo\entry())
			If *te\undo\entry()\action = #TE_Undo_Start
				DeleteElement(*te\undo\entry())
				result = #True
			Else
				Break
			EndIf
		Wend
		
		While LastElement(*te\redo\entry())
			If *te\redo\entry()\action = #TE_Undo_Start
				DeleteElement(*te\redo\entry())
				result = #True
			Else
				Break
			EndIf
		Wend
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Undo_Clear(*undo.TE_UNDO)
		If *undo
			ClearList(*undo\entry())
		EndIf
	EndProcedure
	
	;-
	;- ----------- KEYWORD -----------
	;-
	
	
	Procedure KeyWord_Add(*te.TE_STRUCT, key.s, style = #TE_Ignore, caseCorrection = #TE_Ignore)
		ProcedureReturnIf(*te = #Null)
		
		Protected *key.TE_KEYWORD
		
		*key = FindMapElement(*te\keyWord(), LCase(key))
		If *key = #Null
			*key = AddMapElement(*te\keyWord(), LCase(key))
			*key\name = key
		EndIf
		
		If *key
			If style <> #TE_Ignore
				*key\style = style
			EndIf
			
			If caseCorrection <> #TE_Ignore
				*key\caseCorrection = caseCorrection
			EndIf
		EndIf
		
		ProcedureReturn *key
	EndProcedure
	
	Procedure KeyWord_LineContinuation(*te.TE_STRUCT, keyList.s)
		; keyList is a list of kewords separated by chr(10)
		
		ProcedureReturnIf( (*te = #Null) Or (keyList = ""))
		
		Protected count = CountString(keyList, Chr(10))
		Protected i
		Protected key.s
		
		For i = 1 To count + 1
			key = LCase(StringField(keyList, i, Chr(10)))
			If key
				AddMapElement(*te\keyWordLineContinuation(), key)
			EndIf
		Next
	EndProcedure
	
	Procedure KeyWord_Folding(*te.TE_STRUCT, key.s, foldState)
		ProcedureReturnIf(*te = #Null)
		
		Protected *key.TE_KEYWORD
		
		*key = KeyWord_Add(*te, key)
		If *key <> #Null
			*key\foldState = foldState
		EndIf
		
		ProcedureReturn *key
	EndProcedure
	
	Procedure KeyWord_Indentation(*te.TE_STRUCT, key.s, indentationBefore, indentationAfter)
		ProcedureReturnIf(*te = #Null)
		
		Protected *key.TE_KEYWORD
		
		*key = KeyWord_Add(*te, key)
		If *key <> #Null
			*key\indentationBefore = indentationBefore
			*key\indentationAfter = indentationAfter
		EndIf
		
		ProcedureReturn *key
	EndProcedure
	
	Procedure Syntax_Add(*te.TE_STRUCT, text.s, flags = #TE_Flag_Multiline)
		ProcedureReturnIf(*te = #Null)
		
		Protected nrParts, nrValues, valueStart
		Protected part.s, key.s, values.s, value.s
		Protected i, j
		
		If Right(text, 1) <> "'"
			text + "'"
		EndIf
		
		nrParts = CountString(text, "|") + 1
		For i = 1 To nrParts
			part.s = StringField(text, i, "|")
			key.s = Left(part, FindString(part, "'") - 1)
			If key
				*te\syntax(LCase(key))\keyWord = key
				*te\syntax(LCase(key))\flags | flags
				
				valueStart = FindString(part, "'")
				values.s = Mid(part, valueStart + 1, FindString(part, "'", valueStart + 1) - valueStart - 1)
				If values
					nrValues = CountString(values, ",") + 1
					For j = 1 To nrValues
						value = StringField(values, j, ",")
						
						*te\syntax(LCase(value))\keyWord = value
						*te\syntax(LCase(value))\flags | flags
						
						*te\syntax(LCase(value))\before(LCase(key))\keyWord = key
						*te\syntax(LCase(key))\after(LCase(value))\keyWord = value
					Next
				EndIf
			EndIf
		Next
		
		ForEach *te\syntax()
			If (MapSize(*te\syntax()\before()) = 0) And MapSize(*te\syntax()\after())
				*te\syntax()\flags | #TE_Flag_Start
			EndIf
			If (MapSize(*te\syntax()\after()) = 0) And MapSize(*te\syntax()\before())
				*te\syntax()\flags | #TE_Flag_End
			EndIf
		Next
	EndProcedure
	
	;-
	;- ----------- FOLDING -----------
	;-
	
	Procedure Folding_GetTextBlock(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf(*te = #Null)
		
		Protected *textBlock.TE_TEXTBLOCK = #Null
		
		PushListPosition(*te\textBlock())
		ForEach *te\textBlock()
			If (lineNr >= *te\textBlock()\firstLineNr) And (lineNr <= *te\textBlock()\lastLineNr Or *te\textBlock()\lastLineNr = 0)
				*textBlock = *te\textBlock()
			EndIf
		Next
		PopListPosition(*te\textBlock())
		
		ProcedureReturn *textBlock
	EndProcedure
	
	Procedure Folding_Update(*te.TE_STRUCT, firstLine, lastLine)
		ProcedureReturnIf(*te = #Null)
		
		If *te\enableFolding = #False
			*te\needFoldUpdate = #False
			
			*te\visibleLineCount = ListSize(*te\textLine())
			ProcedureReturn
		EndIf
		
		Protected *previousBlock.TE_TEXTBLOCK
		Protected *textBlock.TE_TEXTBLOCK
		Protected *foldBlock.TE_TEXTBLOCK
		Protected foldCount, foldSum
		Protected visibleLineNr
		Protected maxLineWidth, oldMaxLineWidth = *te\maxTextWidth
		
		*te\needFoldUpdate = #False
		*te\redrawMode | #TE_Redraw_All
		
		*te\visibleLineCount = ListSize(*te\textLine())
		
		ClearList(*te\textBlock())
		
		PushListPosition(*te\textLine())
		
		ForEach *te\textLine()
			
			If *foldBlock = #Null
				visibleLineNr + 1
			EndIf
			
			*te\textLine()\foldSum = foldSum
			
			If *te\textLine()\foldState
				foldSum = Max(0, foldSum + *te\textLine()\foldCount)
				
				If *te\textLine()\foldCount > 0
					foldCount + *te\textLine()\foldCount
					
					While foldCount > 0
						*textBlock = AddElement(*te\textBlock())
						If *textBlock
							*textBlock\firstLine = *te\textLine()
							*textBlock\firstLineNr = ListIndex(*te\textLine()) + 1
							*textBlock\firstVisibleLineNr = visibleLineNr
							
							If *foldBlock = #Null
								If *textBlock\firstLine\foldState = #TE_Folding_Folded
									*foldBlock = *textBlock
								EndIf
							EndIf
						EndIf
						
						foldCount - 1
					Wend
					
				ElseIf (*te\textLine()\foldCount < 0) And (*te\textLine()\foldSum > 0)
					
					foldCount = *te\textLine()\foldCount
					
					While *textBlock And (foldCount < 0)
						If *textBlock\lastLine = #Null
							*textBlock\lastLine = *te\textLine()
							*textBlock\lastLineNr = ListIndex(*te\textLine()) + 1
							*textBlock\lastVisibleLineNr = visibleLineNr
						EndIf
						
						If *textBlock = *foldBlock
							*te\visibleLineCount - (*foldBlock\lastLineNr - *foldBlock\firstLineNr)
							*foldBlock = #Null
						EndIf
						
						If PreviousElement(*te\textBlock())
							*textBlock = *te\textBlock()
						EndIf
						
						foldCount + 1
					Wend
				EndIf
				
			EndIf
			
		Next
		
		PopListPosition(*te\textLine())
		
		If *foldBlock
			*te\visibleLineCount - (ListSize(*te\textLine()) - *foldBlock\firstLineNr)
		EndIf
		
		SortStructuredList(*te\textBlock(), #PB_Sort_Ascending, OffsetOf(TE_TEXTBLOCK\firstLineNr), TypeOf(TE_TEXTBLOCK\firstLineNr))
		
		ForEach *te\cursor()
			*te\cursor()\position\visibleLineNr = LineNr_to_VisibleLineNr(*te, *te\cursor()\position\lineNr)
		Next
	EndProcedure
	
	Procedure Folding_Toggle(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf(*te = #Null)
		
		PushListPosition(*te\textBlock())
		Protected *textblock.TE_TEXTBLOCK = Folding_GetTextBlock(*te, lineNr)
		
		If *textblock
			If *textblock\firstLine\foldState = #TE_Folding_Folded
				*textblock\firstLine\foldState = #TE_Folding_Unfolded
			ElseIf *textblock\firstLine\foldState = #TE_Folding_Unfolded
				*textblock\firstLine\foldState = #TE_Folding_Folded
			EndIf
			
			*te\redrawMode | #TE_Redraw_All
			*te\needScrollUpdate = #True
			*te\needFoldUpdate = #True
		EndIf
		PopListPosition(*te\textBlock())
		
		ProcedureReturn *textblock
	EndProcedure
	
	Procedure Folding_UnfoldTextline(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf(*te = #Null)
		
		Protected *textBlock.TE_TEXTBLOCK
		
		PushListPosition(*te\textBlock())
		Repeat
			*textBlock = Folding_GetTextBlock(*te, lineNr)
			
			If *textBlock
				If (*textBlock\firstLine And (*textBlock\firstLine\foldState & #TE_Folding_Folded))
					*te\needFoldUpdate = #True
					*te\redrawMode | #TE_Redraw_All
				EndIf
				
				*textBlock\firstLine\foldState = #TE_Folding_Unfolded
				lineNr = *textBlock\firstLineNr - 1
			EndIf
		Until (*textBlock = #Null)
		PopListPosition(*te\textBlock())
	EndProcedure
	
	;-
	;- ----------- INDENTATION -----------
	;-
	
	Procedure.s Indentation_Text(*te.TE_STRUCT, indentation.s, indentationCount)
		ProcedureReturnIf( (*te = #Null) Or (indentationCount = 0), indentation)
		
		Protected i, j
		
		If indentationCount > 0
			
			If *te\useRealTab
				indentation + LSet("", indentationCount, #TAB$)
			Else
				indentation + LSet("", indentationCount * *te\tabSize, " ")
			EndIf
			
		ElseIf indentationCount < 0
			
			For i = indentationCount To -1
				If Left(indentation, 1) = #TAB$
					indentation = Mid(indentation, 2)
				ElseIf Left(indentation, *te\tabSize) = Space(*te\tabSize)
					indentation = Mid(indentation, *te\tabSize + 1)
				ElseIf Left(indentation, 1) = " "
					For j = 1 To *te\tabSize
						If Mid(indentation, j, 1) <> " "
							indentation = Mid(indentation, j)
							Break
						EndIf
					Next
				EndIf
			Next
			
		EndIf
		
		ProcedureReturn indentation
	EndProcedure
	
	Procedure.s Indentation_LineContinuation(*te.TE_STRUCT, *textLine.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null) Or (*textLine\tokenCount = 0), "")
		
		Protected *firstLine.TE_TEXTLINE
		Protected *currentLine.TE_TEXTLINE = *textLine
		Protected NewList indent.TE_INDENTATIONPOS(), indent.TE_INDENTATIONPOS
		Protected lineNr, i, newIndent, nextIndent, firstIndent
		
		PushListPosition(*te\textLine())
		ChangeCurrentElement(*te\textLine(), *textLine)
		
		lineNr = ListIndex(*te\textLine())
		
		While PreviousElement(*te\textLine()) And Textline_HasLineContinuation(*te, *te\textLine())
			*textLine = *te\textLine()
		Wend
		
		*firstLine = *textLine
		ChangeCurrentElement(*te\textLine(), *textLine)
		Repeat
			For i = 1 To *textLine\tokenCount
				If nextIndent And (*textline\token(i)\type = #TE_Token_String)
					newIndent = 1
					nextIndent = 0
				EndIf
				If newIndent And (*textline\token(i)\type <> #TE_Token_Whitespace)
					newIndent = 0
					nextIndent = 0
					indent\textLine = *textLine
					indent\charNr = *textLine\token(i)\charNr
				EndIf
				
				Select *textline\token(i)\type
					Case #TE_Token_Comment
						Break
					Case #TE_Token_Comma
						nextIndent = 1
					Case #TE_Token_Equal
						nextIndent = 1
						; 						newIndent = 1
					Case #TE_Token_BracketOpen
						newIndent = 1
						AddElement(indent())
						CopyStructure(indent, indent(), TE_INDENTATIONPOS)
					Case #TE_Token_BracketClose
						If LastElement(indent())
							CopyStructure(indent(), indent, TE_INDENTATIONPOS)
							DeleteElement(indent())
						EndIf
				EndSelect
				
				If indent\charNr = 0
					If firstIndent = 0 And *textline\token(i)\type <> #TE_Token_Whitespace
						firstIndent = 1
					ElseIf firstIndent = 1 And *textline\token(i)\type = #TE_Token_Whitespace
						firstIndent = 2
						newIndent = 1
					EndIf
				EndIf
			Next
			*textLine = NextElement(*te\textLine())
		Until (ListIndex(*te\textLine()) > lineNr) Or (*textLine = #Null)
		
		PopListPosition(*te\textLine())
		
		If indent\textLine
			ProcedureReturn Space(Textline_ColumnFromCharNr(*te, *te\currentView, indent\textLine, indent\charNr) - 1)
		EndIf
	EndProcedure
	
	Procedure.s Indentation_Before(*te.TE_STRUCT, *textLine.TE_TEXTLINE, mode = #TE_Indentation_Auto)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null), "")
		
		Protected *previousLine.TE_TEXTLINE = #Null
		Protected *indentation.TE_TOKEN = #Null
		Protected indentationCount = 0
		
		PushListPosition(*te\textLine())
		ChangeCurrentElement(*te\textLine(), *textLine)
		
		If mode = #TE_Indentation_Auto
			
			While (*previousLine = #Null) And PreviousElement(*te\textLine())
				*textLine = *te\textLine()
				If *textLine\tokenCount > 0
					If (*textLine\tokenCount = 1) And (*textLine\token(1)\type = #TE_Token_Whitespace)
						*indentation = @*textLine\token(1)
					Else
						*previousLine = *textLine
					EndIf
				EndIf
			Wend
			
			While PreviousElement(*te\textLine()) And Textline_HasLineContinuation(*te, *te\textLine())
				*previousLine = *te\textLine()
			Wend
			If *previousLine
				If *previousLine\tokenCount >= 1
					If *previousLine\token(1)\type = #TE_Token_Whitespace
						*indentation = @*previousLine\token(1)
					Else
						*indentation = #Null
					EndIf
				EndIf
				indentationCount = *previousLine\indentationAfter
			EndIf
			
		ElseIf mode = #TE_Indentation_Block
			
			*previousLine = *te\textLine()
			While *previousLine And (*previousLine\tokenCount = 0)
				*previousLine = PreviousElement(*te\textLine())
			Wend
			
			If *previousLine And *previousLine\tokenCount And *previousLine\token(1)\type = #TE_Token_Whitespace
				*indentation = @*previousLine\token(1)
			EndIf
			
		EndIf
		PopListPosition(*te\textLine())
		
		If *indentation
			ProcedureReturn Indentation_Text(*te, TokenText(*indentation), indentationCount)
		Else
			ProcedureReturn Indentation_Text(*te, "", indentationCount)
		EndIf
	EndProcedure
	
	Procedure Indentation_Range(*te.TE_STRUCT, firstLineNr, lastLineNr, *cursor.TE_CURSOR = #Null, mode = #TE_Indentation_Auto)
		ProcedureReturnIf( (*te = #Null) Or (*te\enableIndentation = #False))
		
		Protected *textline.TE_TEXTLINE, *lastTextline.TE_TEXTLINE
		Protected indentationCount, indentation.s
		Protected text.s
		
		If lastLineNr <= 0
			lastLineNr = firstLineNr
		EndIf
		
		If firstLineNr > lastLineNr
			Swap firstLineNr, lastLineNr
		EndIf
		
		PushListPosition(*te\textLine())
		
		If Textline_FromLine(*te, firstLineNr)
			indentation = Indentation_Before(*te, *te\textLine(), mode)
			
			PushListPosition(*te\textLine())
			*lastTextline = PreviousElement(*te\textLine())
			PopListPosition(*te\textLine())
			
			Protected continueLine
			
			If mode = #TE_Indentation_Auto
				
				Repeat
					If *lastTextline And Textline_HasLineContinuation(*te, *lastTextline)
						indentation = Indentation_LineContinuation(*te, *lastTextline)
						If continueLine = 0
							continueLine = 1
							indentationCount = 0
						EndIf
					Else
						If continueLine
							indentation = Indentation_Before(*te, *lastTextline, mode)
							continueLine = 0
						EndIf
						
						indentationCount + *te\textLine()\indentationBefore
						indentation = Indentation_Text(*te, indentation, indentationCount)
						indentationCount = *te\textLine()\indentationAfter
					EndIf
					
					Textline_SetText(*te, *te\textLine(), indentation + Indentation_Clear(*te\textLine()), #TE_Styling_UpdateIndentation, *te\undo)
					*lastTextline = *te\textLine()
				Until (ListIndex(*te\textLine()) >= lastLineNr - 1) Or (NextElement(*te\textLine()) = #Null)
				
			ElseIf mode = #TE_Indentation_Block
				
				Repeat
					text = Indentation_Clear(*te\textLine())
					Textline_SetText(*te, *te\textLine(), indentation + text, #TE_Styling_UpdateIndentation, *te\undo)
				Until (ListIndex(*te\textLine()) >= lastLineNr - 1) Or (NextElement(*te\textLine()) = #Null)
				
			EndIf
		EndIf
		PopListPosition(*te\textLine())
		
		If *cursor
			Cursor_Position(*te, *cursor, lastLineNr, Textline_LastCharNr(*te, lastLineNr))
			Selection_SetRange(*te, *cursor, firstLineNr, 1)
		EndIf
		
		ProcedureReturn Len(indentation) + 1
	EndProcedure
	
	Procedure Indentation_All(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Indentation_Range(*te, 1, ListSize(*te\textLine()), #Null, #TE_Indentation_Auto)
	EndProcedure
	
	Procedure.s Indentation_Clear(*textLine.TE_TEXTLINE)
		ProcedureReturnIf( (*textLine = #Null) Or (*textLine\tokenCount < 1), "")
		
		If (*textLine\tokenCount = 1) And (*textLine\token(1)\type = #TE_Token_Whitespace)
			ProcedureReturn ""
		ElseIf (*textLine\tokenCount > 1) And (*textLine\token(1)\type = #TE_Token_Whitespace)
			ProcedureReturn Mid(*textLine\text, *textLine\token(2)\charNr);PeekS(*textLine\token(2)\text)
		Else
			ProcedureReturn *textLine\text
		EndIf
	EndProcedure
	
	Procedure Indentation_Add(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		Protected result = #False
		Protected charNr, tabPos
		Protected tabText.s
		
		charNr = Clamp(*cursor\position\charNr, 1, Textline_Length(*cursor\position\textline) + 1)
		
		If *te\useRealTab
			If Textline_AddChar(*te, *cursor, #TAB, #False, #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *te\undo)
				result = #True
			EndIf
		Else
			tabPos = Textline_NextTabSize(*te, *cursor\position\textline, charNr)
			tabText.s = Space(tabPos)
			
			If Textline_AddText(*te, *cursor, @tabText, Len(tabText), #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *te\undo)
				result = #True
			EndIf
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Indentation_LTrim(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		Protected result = #False
		Protected *textline.TE_TEXTLINE = *cursor\position\textline
		Protected charNr = 0
		
		If Mid(*textline\text, 1, 1) = #TAB$
			charNr = 2
		ElseIf Mid(*textline\text, 1, 1) = " "
			charNr = 1
			While (charNr <= *te\tabSize) And (Mid(*textline\text, charNr, 1) = " ")
				charNr + 1
			Wend
		EndIf
		
		If charNr
			Cursor_Position(*te, *cursor, *cursor\position\lineNr, charNr)
			Selection_SetRange(*te, *cursor, *cursor\position\lineNr, 1)
			result = Selection_Delete(*te, *cursor, *te\undo)
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	;-
	;- ----------- PARSER -----------
	;-
	
	Procedure Parser_Initialize(*parser.TE_PARSER)
		ProcedureReturnIf(*parser = #Null)
		
		Parser_Clear(*parser)
		
		Protected c
		
		For c = 0 To #TE_CharRange
			Select c
				Case 0
					*parser\tokenType(c) = #TE_Token_EOL
				Case 9, ' '
					*parser\tokenType(c) = #TE_Token_Whitespace
				Case '(', '[', '{'
					*parser\tokenType(c) = #TE_Token_BracketOpen
				Case ')', ']', '}'
					*parser\tokenType(c) = #TE_Token_BracketClose
				Case ','
					*parser\tokenType(c) = #TE_Token_Comma
				Case '.'
					*parser\tokenType(c) = #TE_Token_Point
				Case '0' To '9'
					*parser\tokenType(c) = #TE_Token_Number
				Case ':'
					*parser\tokenType(c) = #TE_Token_Colon
				Case '='
					*parser\tokenType(c) = #TE_Token_Equal
				Case 'a' To 'z', 'A' To 'Z', '_'
					*parser\tokenType(c) = #TE_Token_Text
				Case '\'
					*parser\tokenType(c) = #TE_Token_Backslash
					; 					Case '!', '$', '%', '&', '*', '+', '-', '/', '@', '|', '~', '#'
				Case '!', '%', '&', '*', '+', '-', '/', '|', '~'
					*parser\tokenType(c) = #TE_Token_Operator
				Case '<', '>'
					*parser\tokenType(c) = #TE_Token_Compare
				Default; 128-65535
					*parser\tokenType(c) = #TE_Token_Unknown
			EndSelect
		Next
	EndProcedure
	
	Procedure Parser_Clear(*parser.TE_PARSER)
		ProcedureReturnIf(*parser = #Null)
		
		*parser\state = 0
		*parser\tokenIndex = 0
		*parser\token = #Null
		*parser\textline = #Null
		*parser\lineNr = 0
	EndProcedure
	
	Procedure Parser_TokenAtCharNr(*te.TE_STRUCT, *textLine.TE_TEXTLINE, charNr, testBounds = #False, startIndex = 1)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null) Or (*textLine\tokenCount = 0), #Null)
		
		If ArraySize(*textLine\token()) < 0
			Debug "Error in Procedure Parser_TokenAtCharNr"
			Debug "Array *textLine\token() not allocated"
			ProcedureReturn #Null
		EndIf
		
		Protected *token.TE_TOKEN = #Null
		Protected tokenIndex = 0
		Protected i
		
		If testBounds And (charNr < 1) Or (charNr > Len(*textLine\text))
			ProcedureReturn #Null
		EndIf
		
		If charNr <= 1
			tokenIndex = 1
		ElseIf charNr > Len(*textLine\text)
			tokenIndex = *textLine\tokenCount
		Else
			For i = startIndex To *textLine\tokenCount
				*token = @*textLine\token(i)
				If (charNr >= *token\charNr) And (charNr < (*token\charNr + *token\size))
					tokenIndex = i
					Break
				EndIf
			Next
		EndIf
		
		If tokenIndex
			*token = @*textLine\token(tokenIndex)
			*te\parser\textline = *textLine
			*te\parser\tokenIndex = tokenIndex
			*te\parser\token = *token
		EndIf
		
		ProcedureReturn *token
	EndProcedure
	
	Procedure Parser_NextToken(*te.TE_STRUCT, direction, flags = #TE_Flag_NoWhiteSpace)
		ProcedureReturnIf( (*te = #Null) Or (*te\parser\textline = #Null) Or (direction = 0))
		
		Protected *parser.TE_PARSER = *te\parser
		Protected *textline.TE_TEXTLINE = *parser\textline
		Protected *token.TE_TOKEN
		Protected tokenIndex = *parser\tokenIndex
		Protected currentFlags = 0
		
		*parser\token = #Null
		ChangeCurrentElement(*te\textLine(), *textline)
		Repeat
			Protected endLoop = #True
			tokenIndex + direction
			
			currentFlags = flags
			If (tokenIndex < 1) Or (tokenIndex > *textline\tokenCount)
				; if multiline: keep looking for lines with tokens
				tokenIndex = 0
				If (currentFlags & #TE_Flag_Multiline)
					If (direction < 0) And (ListIndex(*te\textLine()) > 0)
						Repeat
							*textline = PreviousElement(*te\textLine())
						Until (*textline = #Null) Or *textline\tokenCount
						If *textline And *textline\tokenCount
							tokenIndex = *textline\tokenCount
						Else
							*te\parser\state | #TE_Parser_State_EOF
						EndIf
					ElseIf (direction > 0) And (ListIndex(*te\textLine()) < ListSize(*te\textLine()) - 1)
						Repeat
							*textline = NextElement(*te\textLine())
						Until (*textline = #Null) Or *textline\tokenCount
						If *textline And *textline\tokenCount
							tokenIndex = 1
						Else
							*te\parser\state | #TE_Parser_State_EOF
						EndIf
					EndIf
				Else
					*parser\state | #TE_Parser_State_EOL
				EndIf
			EndIf
			
			If tokenIndex
				*token = @*textline\token(tokenIndex)
				If (currentFlags & #TE_Flag_NoWhiteSpace) And (*textline\token(tokenIndex)\type = #TE_Token_Whitespace)
					endLoop = #False
				ElseIf (currentFlags & #TE_Flag_NoBlankLines)
					If (*textline\tokenCount = 1) Or (*textline\tokenCount = 2 And *textline\token(1)\type = #TE_Token_Whitespace)
						endLoop = #False
					EndIf
				EndIf
				
				If endLoop
					*parser\token = *token
					*parser\tokenIndex = tokenIndex
					*parser\textline = *textline
					*parser\lineNr = ListIndex(*te\textLine()) + 1
					*parser\state & ~#TE_Parser_State_EOL
				EndIf
			EndIf
		Until endLoop Or (*te\parser\state & #TE_Parser_State_EOF)
		
		ProcedureReturn *parser\token
	EndProcedure
	
	;-
	
	Procedure Parser_SyntaxCheckFind(*te.TE_STRUCT, direction, findFlags, errorFlags)
		ProcedureReturnIf( (*te = #Null) Or (*te\parser\textline = #Null))
		ProcedureReturnIf( (*te\parser\tokenIndex > *te\parser\textline\tokenCount))
		
		Protected *token.TE_TOKEN = #Null
		Protected *currentToken.TE_TOKEN = *te\parser\token
		Protected oldParser.TE_PARSER
		Protected skip
		
		CopyStructure(*te\parser, oldParser, TE_PARSER)
		Repeat
			*currentToken = Parser_NextToken(*te, direction, #TE_Flag_Multiline | #TE_Flag_NoWhiteSpace)
			If *currentToken
				If FindMapElement(*te\syntax(), LCase(TokenText(*currentToken)))
					If (*te\syntax()\flags & errorFlags) = errorFlags
						; 						Break
						skip + 1
					ElseIf *te\syntax()\flags & findFlags
						If skip
							skip = Max(skip - 1, 0)
						Else
							*token = *currentToken
							Break
						EndIf
					EndIf
				EndIf
			EndIf
		Until *currentToken = #Null
		
		If *token = #Null
			CopyStructure(oldParser, *te\parser, TE_PARSER)
		EndIf
		
		ProcedureReturn *token
	EndProcedure
	
	Procedure Parser_SyntaxCheck(*te.TE_STRUCT, direction, flagStart, flagEnd, flags)
		ProcedureReturnIf( (*te = #Null) Or (*te\parser\textline = #Null) Or (*te\parser\token = #Null) Or (direction = 0))
		
		Protected error = 0
		Protected result = 0
		Protected level = 0
		Protected containerLevel = 0
		Protected procedureLevel = 0
		Protected loopLevel = 0
		Protected compilerLevel = 0
		Protected *token.TE_TOKEN = *te\parser\token
		Protected *findToken.TE_TOKEN = *te\parser\token
		Protected *current.TE_SYNTAX
		Protected *previous.TE_SYNTAX
		Protected addResult
		Protected key.s
		Protected Dim *code(1024), codeLevel
		
		ChangeCurrentElement(*te\textLine(), *te\parser\textline)
		
		Repeat
			addResult = #False
			
			key = LCase(TokenText(*token))
			*current = FindMapElement(*te\syntax(), key)
			If *current
				If (*current\flags & #TE_Flag_Break) Or (*current\flags & #TE_Flag_Continue)
					If (flags & #TE_Flag_Loop) And (loopLevel = 1)
						addResult = #True
					EndIf
				ElseIf *current\flags & #TE_Flag_Return
					If (flags & #TE_Flag_Procedure) And (procedureLevel = 1)
						addResult = #True
					EndIf
				Else
					If (level = 0) Or (*current\flags & flagStart)
						If codeLevel < 1024
							*code(codeLevel) = *previous
							codeLevel + 1
						EndIf
						
						If *current\flags & #TE_Flag_Compiler
							compilerLevel + 1
						EndIf
						If *current\flags & #TE_Flag_Container
							containerLevel + 1
						EndIf
						If *current\flags & #TE_Flag_Loop
							loopLevel + 1
						EndIf
						If *current\flags & #TE_Flag_Procedure
							procedureLevel + 1
						EndIf
						
						If level = 0
							addResult = #True
						EndIf
						
						If *current\flags & flagEnd
							result = 1
						EndIf
						
						level + direction
						
					ElseIf *previous
						
						If (direction > 0 And FindMapElement(*previous\after(), key)) Or
							(direction < 0 And FindMapElement(*previous\before(), key))
							
							If *current\flags & flagEnd
								
								level - direction
								
								If *current\flags & #TE_Flag_Container
									containerLevel - 1
								EndIf
								If *current\flags & #TE_Flag_Loop
									loopLevel - 1
								EndIf
								If *current\flags & #TE_Flag_Procedure
									procedureLevel - 1
								EndIf
								
								If codeLevel = 0
									error = #True
								Else
									codeLevel - 1
									*current = *code(codeLevel)
								EndIf
								
								If level = 0
									result = 1
								ElseIf ( (direction > 0) And (level < 0)) Or ( (direction < 0) And (level > 0))
									error = #True
								EndIf
								
								
							ElseIf Abs(level) = 1
								addResult = #True
							EndIf
							
						Else
							error = #True
						EndIf
						
					EndIf
					
					*previous = *current
				EndIf
			EndIf
			
			If error Or result Or addResult
				If AddElement(*te\syntaxHighlight())
					*te\parser\textline\needRedraw = #True
					*te\syntaxHighlight()\textline = *te\parser\textline
					*te\syntaxHighlight()\startCharNr = *token\charNr
					*te\syntaxHighlight()\endCharNr = *token\charNr + *token\size
					
					If error
						*te\syntaxHighlight()\style = #TE_Style_CodeMismatch
					Else
						If (*findToken\type = #TE_Token_BracketOpen) Or (*findToken\type = #TE_Token_BracketClose)
							*te\syntaxHighlight()\style = #TE_Style_BracketMatch
						Else
							*te\syntaxHighlight()\style = #TE_Style_CodeMatch
						EndIf
					EndIf
				EndIf
			EndIf
			
			If result = 0
				Repeat
					*token = #Null
					*te\parser\tokenIndex + direction
					
					If *te\parser\tokenIndex < 1
						*te\parser\textline = PreviousElement(*te\textLine())
						If *te\parser\textline And *te\textLine()\tokenCount
							*te\parser\tokenIndex = *te\textLine()\tokenCount
						EndIf
					ElseIf *te\parser\tokenIndex > *te\textLine()\tokenCount
						*te\parser\textline = NextElement(*te\textLine())
						If *te\parser\textline And *te\textLine()\tokenCount
							*te\parser\tokenIndex = 1
						EndIf
					EndIf
					
					If *te\parser\textline And *te\parser\textline\tokenCount
						*token = @*te\parser\textline\token(*te\parser\tokenIndex)
						If *token And ( (*token\type <> #TE_Token_Text) And (*token\type <> #TE_Token_BracketOpen) And (*token\type <> #TE_Token_BracketClose))
							*token = #Null
						EndIf
					EndIf
					
					If compilerLevel And *token
						compilerLevel = 1
						If FindMapElement(*te\syntax(), LCase(TokenText(*token))) And (*te\syntax()\flags & #TE_Flag_Compiler)
							If ( (direction < 0) And (*te\syntax()\flags & #TE_Flag_Start)) Or ( (direction > 0) And (*te\syntax()\flags & #TE_Flag_End))
								compilerLevel = 0
							Else
								compilerLevel = -1
							EndIf
						EndIf
						If compilerLevel = 1
							*token = #Null
						EndIf
					EndIf
					
				Until *token Or (*te\parser\textline = #Null)
			EndIf
		Until (*token = #Null) Or result Or error
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Parser_SyntaxCheckStart(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*te\enableSyntaxCheck = #False) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		Protected *token.TE_TOKEN
		Protected *found.TE_TOKEN
		Protected result1, result2
		Protected style, i
		
		SyntaxHighlight_Clear(*te)
		
		If Cursor_InsideComment(*te, *cursor)
			ProcedureReturn #False
		EndIf
		
		Parser_Clear(*te\parser)
		
		*token = Parser_TokenAtCharNr(*te, *cursor\position\textline, *cursor\position\charNr, #True)
		If *token = #Null
			ProcedureReturn #False
		EndIf
		
		If (*token\type <> #TE_Token_Text) And (*token\type <> #TE_Token_BracketOpen) And (*token\type <> #TE_Token_BracketClose)
			ProcedureReturn #False
		EndIf
		If FindMapElement(*te\syntax(), LCase(TokenText(*token))) = 0
			ProcedureReturn #False
		EndIf
		
		*found = *token
		
		If (*te\syntax()\flags & #TE_Flag_Break) Or (*te\syntax()\flags & #TE_Flag_Continue)
			*found = Parser_SyntaxCheckFind(*te, -1, #TE_Flag_Loop, #TE_Flag_Loop | #TE_Flag_End)
		ElseIf *te\syntax()\flags & #TE_Flag_Return
			*found = Parser_SyntaxCheckFind(*te, -1, #TE_Flag_Procedure, #TE_Flag_Procedure | #TE_Flag_End)
		EndIf
		
		If *found
			Protected parser.TE_PARSER
			
			CopyStructure(*te\parser, @parser, TE_PARSER)
			result1 = Parser_SyntaxCheck(*te, -1, #TE_Flag_End, #TE_Flag_Start, *te\syntax()\flags)
			
			CopyStructure(@parser, *te\parser, TE_PARSER)
			result2 = Parser_SyntaxCheck(*te, 1, #TE_Flag_Start, #TE_Flag_End, *te\syntax()\flags)
		EndIf
		
		If (*found = #Null) Or (result1 < 1) Or (result2 < 1)
			If AddElement(*te\syntaxHighlight())
				*te\syntaxHighlight()\textline = *cursor\position\textline
				*te\syntaxHighlight()\startCharNr = *token\charNr
				*te\syntaxHighlight()\endCharNr = *token\charNr + *token\size
				
				If *token\type = #TE_Token_BracketOpen Or *token\type = #TE_Token_BracketClose
					*te\syntaxHighlight()\style = #TE_Style_BracketMismatch
				Else
					*te\syntaxHighlight()\style = #TE_Style_CodeMismatch
				EndIf
			EndIf
		EndIf
		
		SyntaxHighlight_Update(*te)
		
		ProcedureReturn #True
	EndProcedure
	
	;-
	
	Procedure Tokenizer_GetNumber(*text.Character, *token.TE_TOKEN)
		Protected *c.Character = *text
		Protected size
		Protected decPointFound
		
		*token\type = #TE_Token_Number
		
		While *c\c
			Select *c\c
				Case '0' To '9'
					size + 1
				Case '.'
					If decPointFound
						Break
					EndIf
					decPointFound = 1
					size + 1
				Default
					Break
			EndSelect
			
			*c + #TE_CharSize
		Wend
		
		ProcedureReturn size
	EndProcedure
	
	Procedure Tokenizer_GetText(*text.Character, *token.TE_TOKEN, type = #TE_Token_Text)
		Protected *c.Character = *text
		Protected size
		
		*token\type = type
		
		While *c\c
			Select *c\c
				Case 'a' To 'z', 'A' To 'Z', '_'
					size + 1
					;Case 161 To #TE_CharRange
				Case 128 To #TE_CharRange
					size + 1
				Case '0' To '9'
					size + 1
				Default
					Break
			EndSelect
			
			*c + #TE_CharSize
		Wend
		
		ProcedureReturn size
	EndProcedure
	
	Procedure Tokenizer_GetComment(*text.Character, *commentChar.Character, length, *token.TE_TOKEN)
		Protected *c.Character = *text
		Protected size
		
		If CompareMemoryString(*text, *commentChar, #PB_String_CaseSensitive, length) = #PB_String_Equal
			*token\type = #TE_Token_Comment
			size = length
		EndIf
		
		ProcedureReturn size
	EndProcedure
	
	Procedure Tokenizer_GetWhiteSpace(*text.Character, *token.TE_TOKEN)
		Protected *c.Character = *text
		Protected size
		
		*token\type = #TE_Token_Whitespace
		
		While *c\c
			Select *c\c
				Case ' ', #TAB
					size + 1
				Default
					Break
			EndSelect
			
			*c + #TE_CharSize
		Wend
		
		ProcedureReturn size
	EndProcedure
	
	Procedure Tokenizer_Textline(*te.TE_STRUCT, *textline.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null))
		
		Protected *c.Character
		Protected size
		Protected type
		Protected charNr = 1
		Protected token.TE_TOKEN
		Protected commentChar.c = Asc(Left(*te\commentChar, 1))
		Protected uncommentChar.c = Asc(Left(*te\uncommentChar, 1))
		Protected isComment = #False, isQuoted = 0
		Protected maxTokens = ArraySize(*textline\token())
		Protected maxLength = Len(*textline\text) + 2
		
		*textline\tokenCount = 0
		
		*c = @*textline\text
		Repeat
			token\type = 0
			token\text = #Null
			size = 0
			
			If isQuoted = 0
				If *c\c = commentChar
					size = Tokenizer_GetComment(*c, @*te\commentChar, Len(*te\commentChar), @token)
					If size
						isComment = #True
					EndIf
				EndIf
				If *c\c = uncommentChar
					size = Tokenizer_GetComment(*c, @*te\uncommentChar, Len(*te\uncommentChar), @token)
					If size
						isComment = #False
					EndIf
				EndIf
			EndIf
			
			If size = 0 And (*c\c <= #TE_CharRange)
				token\type = *te\parser\tokenType(*c\c)
				
				size = 1
				Select token\type
					Case #TE_Token_Whitespace
						size = Tokenizer_GetWhiteSpace(*c, @token)
					Case #TE_Token_Number
						size = Tokenizer_GetNumber(*c, @token)
					Case #TE_Token_Text
						size = Tokenizer_GetText(*c, @token)
					Case #TE_Token_Unknown
						size = Tokenizer_GetText(*c, @token, #TE_Token_Unknown)
				EndSelect
			EndIf
			
			If size = 0
				size = 1
				token\type = #TE_Token_Unknown
			EndIf
			
			*textline\tokenCount + 1
			If *textline\tokenCount > maxTokens
				maxTokens + 16
				ReDim *textline\token(maxTokens)
			EndIf
			
			With *textline\token(*textline\tokenCount)
				\type = token\type
				\text = *c
				\charNr = charNr
				\size = size
				
				If isComment
					\type = #TE_Token_Comment
				ElseIf (isQuoted = 1) Or ( (isQuoted = 0) And (*c\c = 39))
					\type = #TE_Token_Quote
					If *c\c = 39
						isQuoted = Bool(Not isQuoted)
					EndIf
				ElseIf (isQuoted = 2) Or ( (isQuoted = 0) And (*c\c = '"'))
					\type = #TE_Token_String
					If *c\c = '"'
						isQuoted = Bool(Not isQuoted) * 2
					EndIf
				EndIf
			EndWith
			
			charNr + size
			*c + size * #TE_CharSize
		Until charNr >= maxLength; token\type = #TE_Token_EOL
		
		ProcedureReturn *textline\tokenCount
	EndProcedure
	
	Procedure Tokenizer_All(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected tokenCount
		
		PushListPosition(*te\textLine())
		ForEach *te\textLine()
			tokenCount + Tokenizer_Textline(*te, *te\textLine())
		Next
		PopListPosition(*te\textLine())
		
		ProcedureReturn tokenCount
	EndProcedure
	
	;-
	;- ----------- STYLE -----------
	;-
	
	Procedure Style_Textline(*te.TE_STRUCT, *textLine.TE_TEXTLINE, styleFlags = 0)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null))
		
		Protected indentationCount, indentationBeforeCount, indentationAfterCount
		Protected foldCount, lastFoldCount
		Protected sSize, lastStyle
		Protected *token.TE_TOKEN, *lastToken.TE_TOKEN, *lastNonWhitespaceToken.TE_TOKEN
		Protected *textBlock.TE_TEXTBLOCK
		Protected charNr
		Protected i
		Protected tokenSize
		Protected tokenType
		Protected key.s
		Protected *text = @*textLine\text
		
		If Tokenizer_Textline(*te, *textLine)
			lastFoldCount = *textLine\foldCount
			
			sSize = Textline_Length(*textLine) + 1
			If (ArraySize(*textLine\style()) < sSize + 1) Or (ArraySize(*textLine\style()) > sSize + 32)
				ReDim *textLine\style(sSize + 1)
			EndIf
			FillMemory(@*textLine\style(), ArraySize(*textLine\style()), 0, #PB_Byte)
			
			If *te\enableStyling = #False
				For i = 1 To *textLine\tokenCount
					*token.TE_TOKEN = @*textLine\token(i)
					*textLine\style(*token\charNr) = #TE_Style_None
				Next
				
				*textLine\needRedraw = #True
				ProcedureReturn
			EndIf
			
			For i = 1 To *textLine\tokenCount
				*token.TE_TOKEN = @*textLine\token(i)
				If *token
					tokenType = *token\type
					tokenSize = *token\size
					charNr = *token\charNr
					
					Select tokenType
							
						Case #TE_Token_Text
							
							*textLine\style(charNr) = 0
							
							If TokenType = #TE_Token_Text And (i > 1)
								If i > 2 And *lastToken And *lastToken\type = #TE_Token_Colon And *textLine\token(i - 2)\type = #TE_Token_Text; And *textLine\style(i - 2) <> #TE_Style_Keyword
									If *textLine\style(*textLine\token(i - 2)\charNr) <> #TE_Style_Keyword
										*textLine\style(*textLine\token(i - 2)\charNr) = #TE_Style_Text
									EndIf
								ElseIf *lastToken And *lastToken\type = #TE_Token_Number
									*textLine\style(charNr) = #TE_Style_None
								ElseIf *lastToken And *lastToken\type = #TE_Token_Point
									*textLine\style(charNr) = #TE_Style_Structure
								ElseIf *lastToken And *lastToken\type = #TE_Token_Operator And *lastToken\text\c = '*'
									*textLine\style(charNr) = #TE_Style_Pointer
									*textLine\style(*lastToken\charNr) = #TE_Style_Pointer
								ElseIf *lastToken And *lastToken\type = #TE_Token_Unknown And *lastToken\text\c = '#'
									*textLine\style(charNr) = #TE_Style_Constant
									*textLine\style(*lastToken\charNr) = #TE_Style_Constant
								ElseIf *lastNonWhitespaceToken And *lastNonWhitespaceToken\type = #TE_Token_Unknown And *lastNonWhitespaceToken\text\c = '@'
									*textLine\style(charNr) = #TE_Style_Address
									*textLine\style(*lastNonWhitespaceToken\charNr) = #TE_Style_Address
								EndIf
							EndIf
							
							If *textLine\style(charNr) = 0
								key = LCase(PeekS(*token\text, *token\size))
								If FindMapElement(*te\keyWord(), key)
									*textLine\style(charNr) = *te\keyWord()\style
									foldCount + *te\keyWord()\foldState
									
									If (TokenType = #TE_Token_Text) And (styleFlags & #TE_Styling_UpdateIndentation)
										If *te\keyWord()\indentationBefore Or *te\keyWord()\indentationAfter
											indentationCount + 1
											Protected indentation
											If indentationCount = 1
												indentationBeforeCount = *te\keyWord()\indentationBefore
												indentationAfterCount = *te\keyWord()\indentationAfter
												indentation = indentationBeforeCount + indentationAfterCount
											Else
												indentation + *te\keyWord()\indentationBefore
												indentationBeforeCount = Min(0, indentation)
												indentationAfterCount = *te\keyWord()\indentationAfter + Max(0, indentation)
												indentation + *te\keyWord()\indentationAfter
											EndIf
										EndIf
									EndIf
									
									If *te\enableCaseCorrection And (styleFlags & #TE_Styling_CaseCorrection) And (*te\keyWord()\caseCorrection)
										ReplaceString(*textLine\text, *te\keyWord()\name, *te\keyWord()\name, #PB_String_NoCase | #PB_String_InPlace, charNr, 1)
									EndIf
									
								ElseIf tokenType = #TE_Token_Text
									*textLine\style(charNr) = #TE_Style_Text
								Else
									*textLine\style(charNr) = #TE_Style_Constant
								EndIf
								
							EndIf
							
						Case #TE_Token_String
							
							*textLine\style(charNr) = #TE_Style_String
							
						Case #TE_Token_Quote
							
							*textLine\style(charNr) = #TE_Style_Quote
							
						Case #TE_Token_Number
							
							*textLine\style(charNr) = #TE_Style_Number
							
						Case #TE_Token_Operator, #TE_Token_Equal, #TE_Token_Compare
							
							*textLine\style(charNr) = #TE_Style_Operator
							
						Case #TE_Token_Backslash
							
							*textLine\style(charNr) = #TE_Style_Backslash
							
						Case #TE_Token_BracketOpen
							
							*textLine\style(charNr) = #TE_Style_Bracket
							
							If *lastNonWhitespaceToken And (*lastNonWhitespaceToken\type = #TE_Token_Text) And (lastStyle <> #TE_Style_Keyword)
								*textLine\style(*lastNonWhitespaceToken\charNr) = #TE_Style_Function
							EndIf
							
						Case #TE_Token_BracketClose
							
							*textLine\style(charNr) = #TE_Style_Bracket
							
						Case #TE_Token_Comment
							
							*textLine\style(charNr) = #TE_Style_Comment
							
						Default
							
							*textLine\style(charNr) = #TE_Style_None
							
					EndSelect
					
					If TokenType = #TE_Token_Unknown
						If (*token\text\c = '$') And *lastToken And *lastToken\type = #TE_Token_Text
							*textLine\style(charNr) = #TE_Style_Text
						EndIf
					ElseIf TokenType = #TE_Token_Colon
						If (*lastToken And *lastToken\type = #TE_Token_Text) And (i >= *textLine\tokenCount Or *textLine\token(i + 1)\type <> #TE_Token_Colon)
							If *textLine\style(*lastToken\charNr) <> #TE_Style_Keyword
								*textLine\style(*lastToken\charNr) = #TE_Style_Label
							EndIf
						ElseIf (i > 2 And *textLine\token(i - 2)\type = #TE_Token_Text) And (*lastToken\type = #TE_Token_Colon)
							If *textLine\style(*textLine\token(i - 2)\charNr) <> #TE_Style_Keyword
								*textLine\style(*textLine\token(i - 2)\charNr) = #TE_Style_Structure
							EndIf
						EndIf
					EndIf
					
					If *lastNonWhitespaceToken
						If *lastNonWhitespaceToken\type = #TE_Token_Comment
							If styleFlags & #TE_Styling_UpdateFolding
								; hack for folding with ";{" and ";}" 
								If FindMapElement(*te\keyWord(), TokenText(*lastNonWhitespaceToken) + TokenText(*token))
									foldCount + *te\keyWord()\foldState
								EndIf
							EndIf
						EndIf
					EndIf
					
					*lastToken = *token
					If (tokenType <> #TE_Token_Whitespace)
						lastStyle = *textLine\style(charNr)
						*lastNonWhitespaceToken = *token
					EndIf
					
				EndIf
				
			Next
			
		EndIf
		
		If styleFlags & #TE_Styling_UnfoldIfNeeded
			If (*textLine\foldState = #TE_Folding_Folded) And (foldCount <= 0)
				styleFlags | #TE_Styling_UpdateFolding
			EndIf
		EndIf
		
		If styleFlags & #TE_Styling_UpdateFolding
			*textLine\foldCount = foldCount
			
			If (foldCount > 0) And (*textLine\foldState <= 0)
				*textLine\foldState = #TE_Folding_Unfolded
			ElseIf (foldCount < 0) And (*textLine\foldState >= 0)
				*textLine\foldState = #TE_Folding_End
			ElseIf (foldCount = 0) And (*textLine\foldState <> 0)
				*textLine\foldState = 0
			EndIf
			
			If foldCount <> lastFoldCount
				*te\needFoldUpdate = #True
			EndIf
		EndIf
		
		If styleFlags & #TE_Styling_UpdateIndentation
			*textLine\indentationBefore = indentationBeforeCount
			*textLine\indentationAfter = indentationAfterCount
		EndIf
		
		*textLine\needRedraw = #True
	EndProcedure
	
	Procedure Style_FromCharNr(*textLine.TE_TEXTLINE, charNr, scanWholeLine = #False)
		ProcedureReturnIf( (*textLine = #Null) Or (ArraySize(*textLine\style()) < 1))
		
		Protected i
		Protected result = 0
		
		charNr = Clamp(charNr, 1, ArraySize(*textLine\style()))
		
		If scanWholeLine
			While (charNr > 0) And (result = 0)
				result = *textLine\style(charNr)
				charNr - 1
			Wend
		Else
			result = *textLine\style(charNr)
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Style_LoadFont(*te.TE_STRUCT, *font.TE_FONT, fontName.s, fontSize, fontStyle = 0)
		ProcedureReturnIf( (*te = #Null) Or (*font = #Null))
		
		Protected result = #False
		Protected c, minTextWidth, image
		
		If IsFont(*font\nr)
			FreeFont(*font\nr)
		EndIf
		
		CompilerSelect #PB_Compiler_OS
			CompilerCase #PB_OS_Windows
				*font\nr = LoadFont(#PB_Any, fontName, fontSize / DesktopResolutionY() * 1.0, fontStyle)
			CompilerCase #PB_OS_MacOS
				*font\nr = LoadFont(#PB_Any, fontName, fontSize / DesktopResolutionY() * 1.2, fontStyle)
			CompilerCase #PB_OS_Linux
				*font\nr = LoadFont(#PB_Any, fontName, fontSize / DesktopResolutionY() * 1.0, fontStyle)
		CompilerEndSelect
		
		If IsFont(*font\nr)
			*font\style = fontStyle
			*font\id = FontID(*font\nr)
			*font\name = fontName
			*font\size = fontSize
			
			image = CreateImage(#PB_Any, 32, 32)
			If IsImage(image)
				If StartVectorDrawing(ImageVectorOutput(image))
					result = #True
					
					VectorFont(*font\id)
					
					minTextWidth = VectorTextWidth(" ")
					*font\height = VectorTextHeight(" ")
					*te\lineHeight = *font\height
					
					For c = 0 To #TE_CharRange
						*font\width(c) = Max(minTextWidth, VectorTextWidth(Chr(c)))
					Next
					*font\width(#TAB) = minTextWidth
					
					StopVectorDrawing()
				EndIf
				FreeImage(image)
			EndIf
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Style_SetFont(*te.TE_STRUCT, fontName.s, fontSize, fontStyle = 0)
		ProcedureReturnIf( (*te = #Null))
		
		Protected i, c, font
		fontSize = Clamp(fontSize, 1, 64)
		
		Style_LoadFont(*te, *te\font(0), fontName, fontSize, #PB_Font_HighQuality | fontStyle)
		Style_LoadFont(*te, *te\font(1), fontName, fontSize, #PB_Font_HighQuality | #PB_Font_Bold)
		; 		Style_LoadFont(*te, *te\font(2), fontName, fontSize, #PB_Font_HighQuality | #PB_Font_Italic)
		; 		Style_LoadFont(*te, *te\font(3), fontName, fontSize, #PB_Font_HighQuality | #PB_Font_Underline)
		; 		Style_LoadFont(*te, *te\font(4), fontName, fontSize, #PB_Font_HighQuality | #PB_Font_StrikeOut)
		
		*te\leftBorderOffset = BorderSize(*te)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Style_Set(*te.TE_STRUCT, styleNr, fontNr, fColor, bColor = #TE_Ignore, underlined = #False)
		ProcedureReturnIf( (*te = #Null) Or (styleNr < 0) Or (styleNr > ArraySize(*te\textStyle())))
		
		Protected *style.TE_TEXTSTYLE
		
		*style = @*te\textStyle(styleNr)
		*style\fColor = fColor
		*style\bColor = bColor
		*style\fontNr = fontNr
		*style\underlined = underlined
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Style_SetDefaultStyle(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Style_Set(*te, #TE_Style_None, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Keyword, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Function, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Structure, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Text, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_String, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Quote, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Comment, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Number, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Pointer, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Address, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Constant, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Operator, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Backslash, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Comma, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Bracket, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Label, 0, *te\colors\defaultTextColor)
		Style_Set(*te, #TE_Style_Highlight, #TE_Ignore, #TE_Ignore, RGBA(85, 85, 80, 255))
		Style_Set(*te, #TE_Style_CodeMatch, 1, RGBA(220, 135, 190, 255), RGBA( 85, 85, 80, 255), #True)
		Style_Set(*te, #TE_Style_CodeMismatch, 1, RGBA(255, 0, 0, 255), RGBA(130, 60, 20, 255), #True)
		Style_Set(*te, #TE_Style_BracketMatch, 0, RGBA(220, 135, 190, 255), RGBA( 85, 85, 80, 255))
		Style_Set(*te, #TE_Style_BracketMismatch, 0, RGBA(255, 0, 0, 255), RGBA(130, 60, 20, 255))
		
	EndProcedure
	
	;-
	;- ----------- TEXTLINE -----------
	;-
	
	Procedure Textline_Add(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		If AddElement(*te\textLine())
			*te\textLine()\text = ""
			*te\textLine()\needRedraw = #True
			*te\needFoldUpdate = #True
			ProcedureReturn *te\textLine()
		EndIf
		
		ProcedureReturn #Null
	EndProcedure
	
	Procedure Textline_Delete(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (ListIndex(*te\textLine()) < 0))
		
		Protected *textline.TE_TEXTLINE
		Protected marker
		
		SyntaxHighlight_Clear(*te)
		
		*te\needFoldUpdate = #True
		
		marker = *te\textLine()\marker
		
		FreeArray(*te\textLine()\token())
		*te\textLine()\text = #Null$
		
		*textline = DeleteElement(*te\textLine(), 1)
		If *textline
			*textline\marker | marker
		EndIf
		
		ProcedureReturn *textline
	EndProcedure
	
	Procedure Textline_AddChar(*te.TE_STRUCT, *cursor.TE_CURSOR, c.c, overwrite, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		ChangeCurrentElement(*te\textLine(), *cursor\position\textline)
		
		Protected *textLine.TE_TEXTLINE = *cursor\position\textline
		Protected *previousLine.TE_TEXTLINE
		Protected previousLineNr = *cursor\position\lineNr
		Protected previousCharNr = *cursor\position\charNr
		Protected marker
		
		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		
		If c = *te\newLineChar
			ChangeCurrentElement(*te\textLine(), *textLine)
			
			*previousLine = *textLine
			*textLine = Textline_Add(*te)
			
			If *textLine
				*textLine\text = Mid(*previousLine\text, *cursor\position\charNr)
				*previousLine\text = Left(*previousLine\text, *cursor\position\charNr - 1)
				
				*cursor\position\textline = *textLine
				*cursor\position\lineNr + 1
				*cursor\position\visibleLineNr + 1
				*cursor\position\charNr = 1
				
				*cursor\position\charX = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr)
				*cursor\position\currentX = *cursor\position\charX
				
				If (*previousLine\marker) And (*textLine\text And *previousLine\text = "")
					Swap *textLine\marker, *previousLine\marker
				EndIf
				
				Style_Textline(*te, *previousLine, styleFlags)
			EndIf
			
		Else
			
			If overwrite And *cursor\position\charNr <= Textline_Length(*textLine)
				Undo_Add(*undo, #TE_Undo_DeleteText, previousLineNr, previousCharNr, 0, 0, Mid(*textLine\text, *cursor\position\charNr, 1))
				*textLine\text = Text_Replace(*textLine\text, Chr(c), *cursor\position\charNr)
			Else
				*textLine\text = InsertString(*textLine\text, Chr(c), *cursor\position\charNr)
			EndIf
			*textLine\textWidth = Textline_Width(*te, *textLine)
			
			*cursor\position\charNr + 1
			*cursor\position\charX = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr)
			*cursor\position\currentX = *cursor\position\charX
			
			*te\maxTextWidth = Max(*te\maxTextWidth, *textLine\textWidth)
		EndIf
		
		*te\leftBorderOffset = BorderSize(*te)
		
		Style_Textline(*te, *cursor\position\textline, styleFlags)
		
		Undo_Add(*undo, #TE_Undo_AddText, previousLineNr, previousCharNr, *cursor\position\lineNr, *cursor\position\charNr)
		
		Cursor_MoveMulti(*te, *cursor, previousLineNr, *cursor\position\lineNr - previousLineNr, *cursor\position\charNr - previousCharNr)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Textline_AddText(*te.TE_STRUCT, *cursor.TE_CURSOR, *c.Character, textLength, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null) Or (*c = #Null) Or (*c\c = 0))
		
		; 		If textLength = 1
		; 			Cursor_Position(*te, *cursor, Textline_LineNr(*te, *cursor\position\textline), *cursor\position\charNr)
		; 			ProcedureReturn Textline_AddChar(*te, *cursor, *c\c, #False, styleFlags, *undo)
		; 		EndIf
		
		Protected previousLineNr = *cursor\position\lineNr
		Protected previousCharNr = *cursor\position\charNr
		Protected tail.s, text.s
		Protected *firstChar.Character = #Null
		Protected *previousLine.TE_TEXTLINE
		Protected addText
		
		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		
		ChangeCurrentElement(*te\textLine(), *cursor\position\textline)
		
		tail = Mid(*cursor\position\textline\text, *cursor\position\charNr)
		*cursor\position\textline\text = Left(*cursor\position\textline\text, *cursor\position\charNr - 1)
		
		Repeat
			
			Select *c\c
				Case 0
					addText = -1
				Case *te\newLineChar
					addText = 1
				Case 9, 32 To #TE_CharRange
					If *firstChar = #Null
						*firstChar = *c
					EndIf
				Default
					addText = -2
			EndSelect
			
			If addText
				If *firstChar <> #Null
					text = PeekS(*firstChar, (*c - *firstChar) / #TE_CharSize)
					*cursor\position\textline\text + text
					*cursor\position\charNr + Len(text)
				EndIf
				
				If addText = 1
					*previousLine = *cursor\position\textline
					
					*cursor\position\textline\textWidth = Textline_Width(*te, *previousLine)
					
					*cursor\position\textline = Textline_Add(*te)
					*cursor\position\lineNr + 1
					*cursor\position\visibleLineNr + 1
					*cursor\position\charNr = 1
					*cursor\position\charX = 0
					
					*te\maxTextWidth = Max(*te\maxTextWidth, *previousLine\textWidth)
					
					Style_Textline(*te, *previousLine, styleFlags)
				EndIf
				
				*firstChar = #Null
				addText = 0
			EndIf
			
			If *c\c = 0
				Break
			EndIf
			
			*c + #TE_CharSize
		Until (addText = -1)
		
		*cursor\position\textline\text = *cursor\position\textline\text + tail
		*cursor\position\textline\textWidth = Textline_Width(*te, *cursor\position\textline)
		
		*te\maxTextWidth = Max(*te\maxTextWidth, *cursor\position\textline\textWidth)
		*te\leftBorderOffset = BorderSize(*te)
		
		Style_Textline(*te, *cursor\position\textline, styleFlags)
		
		Undo_Add(*undo, #TE_Undo_AddText, previousLineNr, previousCharNr, *cursor\position\lineNr, *cursor\position\charNr)
		
		Cursor_MoveMulti(*te, *cursor, previousLineNr, *cursor\position\lineNr - previousLineNr, *cursor\position\charNr - previousCharNr)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Textline_SetText(*te.TE_STRUCT, *textLine.TE_TEXTLINE, text.s, styleFlags = #TE_Styling_All, *undo.TE_UNDO = #Null)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null) Or (*textLine\text = text))
		
		Protected lineNr = Textline_LineNr(*te, *textLine)
		
		Undo_Add(*undo, #TE_Undo_DeleteText, lineNr, 1, 0, 0, *textLine\text)
		Undo_Add(*undo, #TE_Undo_AddText, lineNr, 1, lineNr, Len(text) + 1)
		
		*textLine\text = text
		
		Style_Textline(*te, *textLine, styleFlags)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure.s Textline_GetText(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf(*te = #Null, "")
		
		Protected text.s = ""
		PushListPosition(*te\textLine())
		If Textline_FromLine(*te, lineNr)
			text = *te\textLine()\text
		EndIf
		PopListPosition(*te\textLine())
		
		ProcedureReturn text
	EndProcedure
	
	Procedure Texlint_IsEmpty(*textline.TE_TEXTLINE)
		ProcedureReturnIf(*textline = #Null)
		
		If (*textline\tokenCount = 1) And (*textline\token(1)\type = #TE_Token_EOL)
			ProcedureReturn #True
		ElseIf (*textline\tokenCount = 2) And (*textline\token(1)\type = #TE_Token_Whitespace)
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Textline_LineNr(*te.TE_STRUCT, *textline.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null))
		
		Protected lineNr
		
		PushListPosition(*te\textLine())
		ChangeCurrentElement(*te\textLine(), *textline)
		lineNr = ListIndex(*te\textLine()) + 1
		PopListPosition(*te\textLine())
		
		ProcedureReturn lineNr
	EndProcedure
	
	Procedure Textline_FromLine(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0))
		
		lineNr = Clamp(lineNr, 1, ListSize(*te\textLine()))
		
		If SelectElement(*te\textLine(), lineNr - 1)
			ProcedureReturn *te\textLine()
		EndIf
		
		ProcedureReturn #Null
	EndProcedure
	
	Procedure Textline_FromVisibleLineNr(*te.TE_STRUCT, visibleLineNr)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0))
		
		Protected lineNr = LineNr_from_VisibleLineNr(*te, visibleLineNr)
		
		If SelectElement(*te\textLine(), lineNr - 1)
			ProcedureReturn *te\textLine()
		EndIf
		
		ProcedureReturn #Null
	EndProcedure
	
	Procedure Textline_TopLine(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		ProcedureReturn LineNr_from_VisibleLineNr(*te, *te\currentView\scroll\visibleLineNr)
	EndProcedure
	
	Procedure Textline_BottomLine(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		ProcedureReturn Min(LineNr_from_VisibleLineNr(*te, *te\currentView\scroll\visibleLineNr + *te\currentView\pageHeight + 1), ListSize(*te\textLine()))
	EndProcedure
	
	Procedure Textline_LineNrFromScreenPos(*te.TE_STRUCT, *view.TE_VIEW, screenY)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*te\lineHeight = 0))
		
		Protected lineNr
		
		screenY = Clamp(screenY, 0, *view\height - 1)
		
		lineNr = LineNr_from_VisibleLineNr(*te, *view\scroll\visibleLineNr + (screenY - *te\topBorderSize) / *te\lineHeight)
		
		ProcedureReturn Clamp(lineNr, 1, ListSize(*te\textLine()))
	EndProcedure
	
	Procedure Textline_CharNrFromScreenPos(*te.TE_STRUCT, *textLine.TE_TEXTLINE, screenX)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null))
		
		Protected *font.TE_FONT, fontNr
		Protected *t.Character
		Protected x, width, tabWidth
		Protected style
		Protected charNr
		
		*t = @*textLine\text
		x = 0
		
		If screenX <= 0
			ProcedureReturn 1
		ElseIf *t
			charNr = 1
			*font = @*te\font(0)
			
			If *te\useRealTab
				tabWidth = (*font\width(#TAB) * *te\tabSize)
			Else
				tabWidth = (*font\width(' ') * *te\tabSize)
			EndIf
			
			If tabWidth < 1
				tabWidth = 1
			EndIf
			
			While *t\c
				style = Style_FromCharNr(*textLine, charNr)
				If style
					fontNr = Clamp(*te\textStyle(style)\fontNr, 0, ArraySize(*te\font()))
					*font = @*te\font(fontNr)
				EndIf
				
				Select *t\c
					Case #TAB
						width = tabWidth - ( (x + tabWidth) % tabWidth)
					Default
						width = *font\width(*t\c)
				EndSelect
				
				If (screenX > x) And (screenX <= (x + width * 0.5))
					ProcedureReturn charNr
				ElseIf (screenX > x + width * 0.5) And (screenX <= (x + width))
					ProcedureReturn charNr + 1
				EndIf
				
				x + width
				charNr + 1
				*t + #TE_CharSize
			Wend
		EndIf
		
		ProcedureReturn Textline_Length(*textLine) + 1
	EndProcedure
	
	Procedure Textline_ColumnFromCharNr(*te.TE_STRUCT, *view.TE_VIEW, *textLine.TE_TEXTLINE, charNr)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*textLine = #Null)); Or (*textLine\text = ""))
		
		Protected *font.TE_FONT, fontNr
		Protected *t.Character
		Protected x, width, tabWidth, currentCharNr
		Protected style
		Protected column, nextColumn
		
		*t = @*textLine\text
		
		If charNr <= 1
			ProcedureReturn 1
		ElseIf *t
			currentCharNr = 1
			column = 1
			x = *view\scroll\charX
			*font = @*te\font(0)
			
			If *te\useRealTab
				tabWidth = (*font\width(#TAB) * *te\tabSize)
			Else
				tabWidth = (*font\width(' ') * *te\tabSize)
			EndIf
			
			If tabWidth < 1
				tabWidth = 1
			EndIf
			
			While *t\c
				style = Style_FromCharNr(*textLine, column)
				If style
					fontNr = Clamp(*te\textStyle(style)\fontNr, 0, ArraySize(*te\font()))
					*font = @*te\font(fontNr)
				EndIf
				
				Select *t\c
					Case #TAB
						width = tabWidth - ( (x + tabWidth) % tabWidth)
						nextColumn = column + (width / *font\width(#TAB))
					Default
						width = *font\width(*t\c)
						nextColumn = column + 1
				EndSelect
				
				If charNr = currentCharNr
					ProcedureReturn column
				EndIf
				
				column = nextColumn
				currentCharNr + 1
				x + width
				*t + #TE_CharSize
			Wend
		EndIf
		
		ProcedureReturn column
	EndProcedure
	
	Procedure Textline_CharNrToScreenPos(*te.TE_STRUCT, *textLine.TE_TEXTLINE, charNr)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null) Or (charNr < 1))
		
		Protected *font.TE_FONT, fontNr
		Protected *t.Character
		Protected x, tabWidth, cNr
		Protected style
		Protected maxX
		
		*t = @*textLine\text
		If *t
			cNr = 1
			*font = @*te\font(0)
			
			If *te\useRealTab
				tabWidth = Max(1, *font\width(#TAB) * *te\tabSize)
			Else
				tabWidth = Max(1, *font\width(' ') * *te\tabSize)
			EndIf
			
			While *t\c And (cNr < charNr)
				style = Style_FromCharNr(*textLine, cNr)
				If style
					fontNr = Clamp(*te\textStyle(style)\fontNr, 0, ArraySize(*te\font()))
					*font = @*te\font(fontNr)
				EndIf
				
				Select *t\c
					Case #TAB
						x + tabWidth - ( (x + tabWidth) % tabWidth)
					Case 0 To #TE_CharRange
						x + *font\width(*t\c)
				EndSelect
				
				cNr + 1
				*t + #TE_CharSize
			Wend
		EndIf
		
		ProcedureReturn x
	EndProcedure
	
	Procedure Textline_CharAtPos(*textline.TE_TEXTLINE, charNr)
		ProcedureReturnIf( (*textline = #Null) Or (charNr < 1) Or (charNr > Textline_Length(*textline)))
		
		ProcedureReturn Asc(Mid(*textline\text, charNr, 1))
	EndProcedure
	
	
	Procedure Textline_Width(*te.TE_STRUCT, *textLine.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textLine = #Null))
		
		ProcedureReturn Textline_CharNrToScreenPos(*te, *textLine, Textline_Length(*textLine) + 1)
	EndProcedure
	
	Procedure Textline_Start(*textline.TE_TEXTLINE, charNr)
		ProcedureReturnIf(*textLine = #Null)
		
		If *textline\tokenCount
			If (*textline\token(1)\type = #TE_Token_Whitespace) And (charNr <> *textline\token(1)\size + 1)
				ProcedureReturn *textline\token(1)\size + 1
			EndIf
		EndIf
		ProcedureReturn 1
	EndProcedure
	
	Procedure Textline_Length(*textLine.TE_TEXTLINE)
		ProcedureReturnIf(*textLine = #Null)
		
		ProcedureReturn Len(*textLine\text)
	EndProcedure
	
	Procedure Textline_LastCharNr(*te.TE_STRUCT, lineNr)
		ProcedureReturnIf(*te = #Null)
		
		If Textline_FromLine(*te, lineNr)
			ProcedureReturn Len(*te\textLine()\text) + 2
		EndIf
		
		ProcedureReturn 0
	EndProcedure
	
	Procedure Textline_NextTabSize(*te.TE_STRUCT, *textline.TE_TEXTLINE, charNr)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null) Or (*te\font(0)\width(#TAB) = 0))
		
		Protected x, tabWidth
		
		x = Textline_CharNrToScreenPos(*te, *textline, charNr)
		tabWidth = Max(1, *te\font(0)\width(' ') * *te\tabSize)
		tabWidth = Max(1, tabWidth - ( (x + tabWidth) % tabWidth))
		
		; 		ProcedureReturn charNr + (tabWidth / *te\font(0)\width(#TAB))
		ProcedureReturn tabWidth / *te\font(0)\width(#TAB)
	EndProcedure
	
	Procedure Textline_JoinNextLine(*te.TE_STRUCT, *cursor.TE_CURSOR, *undo.TE_UNDO)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		Protected lineNr = *cursor\position\lineNr
		Protected charNr = *cursor\position\charNr
		
		If *cursor\position\charNr > Textline_Length(*cursor\position\textline)
			Cursor_Position(*te, *cursor, lineNr + 1, 1)
			Selection_SetRange(*te, *cursor, lineNr, charNr)
			ProcedureReturn Selection_Delete(*te, *cursor, *undo)
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Textline_JoinPreviousLine(*te.TE_STRUCT, *cursor.TE_CURSOR, *textLine.TE_TEXTLINE, *undo.TE_UNDO)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		If *cursor\position\charNr <= 1
			If Cursor_Move(*te, *cursor, 0, -1)
				ProcedureReturn Textline_JoinNextLine(*te, *cursor, *undo)
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	
	Procedure Textline_FindText(*textline.TE_TEXTLINE, find.s, *result.TE_RANGE, ignoreWhiteSpace = #False)
		ProcedureReturnIf( (*textline = #Null) Or (*result = #Null) Or (find = ""))
		
		*result\pos1\charNr = 0
		*result\pos2\charNr = 0
		
		Protected *text.Character = @*textline\text
		Protected *find.Character = @find
		Protected findLength = Len(find)
		Protected matchLength
		
		If findLength > Textline_Length(*textline)
			ProcedureReturn #False
		EndIf
		
		If ignoreWhiteSpace
			While (*text\c = ' ') Or (*text\c = #TAB)
				*text + #TE_CharSize
			Wend
		EndIf
		
		While *find\c And *text\c
			If *text\c <> *find\c
				ProcedureReturn #False
			EndIf
			
			matchLength + 1
			
			If *result\pos1\charNr = 0
				*result\pos1\charNr = (*text - @*textline\text) / #TE_CharSize + 1
			EndIf
			If matchLength = findLength
				*result\pos2\charNr = (*text - @*textline\text) / #TE_CharSize + 2
				ProcedureReturn #True
			EndIf
			
			*find + #TE_CharSize
			*text + #TE_CharSize
		Wend
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Textline_HasLineContinuation(*te.TE_STRUCT, *textline.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null) Or (*textline\tokenCount < 1))
		
		Protected lastToken = *textline\tokenCount
		
		; strip trailing whitespace and comment
		While (lastToken > 0) And ( (*textline\token(lastToken)\type = #TE_Token_Whitespace) Or (*textline\token(lastToken)\type = #TE_Token_Comment))
			lastToken - 1
		Wend
		If lastToken > 0
			ProcedureReturn FindMapElement(*te\keyWordLineContinuation(), LCase(TokenText(*textline\token(lastToken))))
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure Textline_Beautify(*te.TE_STRUCT, *textline.TE_TEXTLINE)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null) Or (*textline\tokenCount < 1))
		ProcedureReturnIf(*te\enableBeautify = #False)
		
		Protected lastBracket, currentBracket
		Protected *last.TE_TOKEN, *last2.TE_TOKEN, *current.TE_TOKEN
		Protected text.s
		Protected i, isVal = -1, lastIsVal = -1, lastIsVal2 = -1
		Protected style
		
		Dim token.s(*textline\tokenCount)
		
		For i = 1 To *textline\tokenCount
			token(i) = TokenText(*textline\token(i))
		Next
		
		For i = 1 To *textline\tokenCount
			*last2 = *last
			*last = *current
			*current = @*textline\token(i)
			
			If *current\type <> #TE_Token_Whitespace
				lastBracket = currentBracket
				Select *current\type
					Case #TE_Token_BracketOpen
						currentBracket = 1
					Case #TE_Token_BracketClose
						currentBracket = -1
					Default
						currentBracket = 0
				EndSelect
				
				style = 0
				lastIsVal2 = lastIsVal
				lastIsVal = isVal
				If (*current\type = #TE_Token_Number) Or (*current\type = #TE_Token_Text)
					isVal = 1
				Else
					isVal = 0
				EndIf
			EndIf
			
			If (i > 1) And *last
				If *current\type = #TE_Token_Comment
					Break
				ElseIf *last\type = #TE_Token_Whitespace And token(i - 1) <> ""
					If i > 2
						token(i - 1) = " "
					EndIf
				EndIf
				
				If *current\type = #TE_Token_Colon And *last\type <> #TE_Token_Colon And *textline\token(i + 1)\type <> #TE_Token_Colon And (i < *textline\tokenCount Or *textline\token(i + 1)\type = #TE_Token_Whitespace)
					token(i - 1) + " "
				EndIf
				
				If *current\type = #TE_Token_BracketOpen
					If *last\type = #TE_Token_Whitespace
						If *last2 And *last2\type = #TE_Token_BracketOpen
							token(i - 1) = ""
						ElseIf *last2
							style = Style_FromCharNr(*textline, *last2\charNr)
						EndIf
						If style = #TE_Style_Function Or style = #TE_Style_Structure
							token(i - 1) = ""
						Else
							token(i - 1) = " "
						EndIf
					ElseIf (*last\type <> #TE_Token_BracketOpen) And (*last\type <> #TE_Token_Operator Or *last\text\c <> '-')
						style = Style_FromCharNr(*textline, *last\charNr)
						If style <> #TE_Style_Function And style <> #TE_Style_Structure
							token(i - 1) + " "
						EndIf
					EndIf
				ElseIf *current\type = #TE_Token_Colon And *last\type = #TE_Token_Colon
					If *last2 And *last2\type = #TE_Token_Whitespace
						token(i - 2) = ""
					EndIf
				ElseIf *current\type = #TE_Token_Colon And *last\type = #TE_Token_Whitespace
					token(i - 1) = " "
				ElseIf *current\type = #TE_Token_BracketClose And *last\type = #TE_Token_Whitespace
					token(i - 1) = ""
				ElseIf *current\type = #TE_Token_Comma And *last\type = #TE_Token_Whitespace
					token(i - 1) = ""
				ElseIf *current\type = #TE_Token_Point And *last\type = #TE_Token_Whitespace
					token(i - 1) = ""
				ElseIf *current\type = #TE_Token_Backslash And *last\type = #TE_Token_Whitespace
					; 					token(i - 1) = ""
				ElseIf (*current\type = #TE_Token_Equal Or *current\type = #TE_Token_Compare) And *last\type = #TE_Token_Whitespace
					If *last2 And (*last2\type = #TE_Token_Compare Or *last2\type = #TE_Token_Equal)
						token(i - 1) = ""
					EndIf
				ElseIf *current\type = #TE_Token_Whitespace And *last\type = #TE_Token_Colon
					If *last2 And *last2\type = #TE_Token_Colon
						token(i) = ""
					EndIf
				ElseIf *current\type = #TE_Token_Whitespace And (*last\type = #TE_Token_BracketOpen Or *last\type = #TE_Token_Point Or *last\type = #TE_Token_Backslash)
					;	token(i) = ""
				ElseIf *current\type = #TE_Token_Whitespace And *last\type = #TE_Token_Operator
					If *last\text\c = '~'
						token(i) = ""
					EndIf
				ElseIf (*current\type = #TE_Token_Operator And *current\text\c <> '~' And *current\text\c <> '*') And *last\type <> #TE_Token_Whitespace
					token(i - 1) + " "
				ElseIf (*current\type = #TE_Token_Unknown And *current\text\c <> '@' And *current\text\c <> '#' And *current\text\c <> '$') And *last\type <> #TE_Token_Whitespace
					token(i - 1) + " "
				ElseIf (*current\type = #TE_Token_Equal Or *current\type = #TE_Token_Compare) And *last\type <> #TE_Token_Whitespace
					If *last\type <> #TE_Token_Compare And *last\type <> #TE_Token_Equal
						token(i - 1) + " "
					EndIf
				ElseIf *current\type <> #TE_Token_Whitespace And *last\type = #TE_Token_Colon
					If *last2 And *last2\type <> #TE_Token_Colon
						token(i - 1) + " "
					EndIf
				ElseIf *current\type <> #TE_Token_Whitespace And (*last\type = #TE_Token_Comma Or *last\type = #TE_Token_Equal Or *last\type = #TE_Token_Compare)
					If *current\type <> #TE_Token_Compare
						token(i - 1) + " "
					EndIf
				ElseIf *current\type <> #TE_Token_Whitespace And *last\type = #TE_Token_Operator
					If *last\text\c <> '~' And *last\text\c <> '-' And *last\text\c <> '*'
						token(i - 1) + " "
					EndIf
				ElseIf *current\type <> #TE_Token_Whitespace And *last\type = #TE_Token_Unknown
					If *last\text\c <> '@' And *last\text\c <> '#' And *last\text\c <> '$'
						token(i - 1) + " "
					EndIf
				EndIf
				
				If (*current\type = #TE_Token_BracketOpen Or isVal) And *last\type = #TE_Token_Operator And lastIsVal2
					; If *last2 And *last2\type <> #TE_Token_Whitespace : token(i - 2) = RTrim(token(i - 2)) + " " : EndIf
					; If *last And *last\type <> #TE_Token_Whitespace : token(i - 1) = RTrim(token(i - 1)) + " " : EndIf
				EndIf
			EndIf
		Next
		
		If *textline\token(*textline\tokenCount)\type = #TE_Token_Whitespace
			*textline\tokenCount - 1
		EndIf
		
		For i = 1 To *textline\tokenCount
			text + token(i)
		Next
		
		ProcedureReturn Textline_SetText(*te, *textline, text, #TE_Styling_UpdateIndentation | #TE_Styling_UpdateFolding | #TE_Styling_CaseCorrection, *te\undo)
	EndProcedure
	
	;-
	;- ----------- HIGHLIGHT -----------
	;-
	
	Procedure SyntaxHighlight_Clear(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\syntaxHighlight()) = 0))
		
		Protected *textline.TE_TEXTLINE
		
		*te\highlightSyntax = #False
		
		ForEach *te\syntaxHighlight()
			*textline = *te\syntaxHighlight()\textline
			If *textline And *textline\syntaxHighlight()
				FillMemory(@*textLine\syntaxHighlight(), ArraySize(*textLine\syntaxHighlight()), 0, #PB_Byte)
				*textline\needRedraw = #True
				*te\redrawMode | #TE_Redraw_ChangedLined
			EndIf
		Next
		
		ClearList(*te\syntaxHighlight())
	EndProcedure
	
	Procedure SyntaxHighlight_Update(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected *textline.TE_TEXTLINE
		Protected lineSize, pos1, pos2
		
		ForEach *te\syntaxHighlight()
			*textline = *te\syntaxHighlight()\textline
			lineSize = Textline_Length(*textline) + 1
			
			ReDim *textline\syntaxHighlight(lineSize * #TE_CharSize)
		Next
		
		ForEach *te\syntaxHighlight()
			*textline = *te\syntaxHighlight()\textline
			lineSize = Textline_Length(*textline) + 1
			
			pos1 = Clamp(*te\syntaxHighlight()\startCharNr, 1, lineSize)
			pos2 = Clamp(*te\syntaxHighlight()\endCharNr, 1, lineSize)
			
			*textLine\syntaxHighlight(pos1) = *te\syntaxHighlight()\style
			If *textLine\syntaxHighlight(pos2) = 0
				*textLine\syntaxHighlight(pos2) = #TE_Style_None
			EndIf
			*textline\needRedraw = #True
		Next
		
		*te\redrawMode | #TE_Redraw_ChangedLined
		*te\highlightSyntax = #True
		
		ProcedureReturn ListSize(*te\syntaxHighlight())
	EndProcedure
	
	
	;-
	;- ----------- SELECTION -----------
	;-
		
	Procedure Selection_Get(*cursor.TE_CURSOR, *range.TE_RANGE)
		ProcedureReturnIf( (*cursor = #Null) Or (*range = #Null), #False)
		
		; return the selection of *cursor in *range
		;
		; *range\pos1 = top part of selection
		; *range\pos2 = lower part of selection
		
		If (*cursor\selection\lineNr < 1) Or ( (*cursor\position\lineNr = *cursor\selection\lineNr) And (*cursor\position\charNr = *cursor\selection\charNr))
			*range\pos1\lineNr = *cursor\position\lineNr
			*range\pos1\charNr = *cursor\position\charNr
			*range\pos2\lineNr = *cursor\position\lineNr
			*range\pos2\charNr = *cursor\position\charNr
			ProcedureReturn #False
		ElseIf (*cursor\position\lineNr < *cursor\selection\lineNr) Or (*cursor\position\lineNr = *cursor\selection\lineNr And *cursor\position\charNr < *cursor\selection\charNr)
			*range\pos1\lineNr = *cursor\position\lineNr
			*range\pos1\charNr = *cursor\position\charNr
			*range\pos2\lineNr = *cursor\selection\lineNr
			*range\pos2\charNr = *cursor\selection\charNr
		Else
			*range\pos1\lineNr = *cursor\selection\lineNr
			*range\pos1\charNr = *cursor\selection\charNr
			*range\pos2\lineNr = *cursor\position\lineNr
			*range\pos2\charNr = *cursor\position\charNr
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Selection_Start(*cursor.TE_CURSOR, lineNr, charNr)
		ProcedureReturnIf(*cursor = #Null)
		*cursor\selection\lineNr = lineNr
		*cursor\selection\charNr = charNr
	EndProcedure
	
	Procedure Selection_Delete(*te.TE_STRUCT, *cursor.TE_CURSOR, *undo.TE_UNDO = #Null)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected text.s
		Protected previousLineNr
		Protected selection.TE_RANGE
		Protected nrLines
		
		If Selection_Get(*cursor, selection) = #False
			ProcedureReturn #False
		EndIf
		
		nrLines = (selection\pos2\lineNr - selection\pos1\lineNr) + 1
		
		If Textline_FromLine(*te, selection\pos1\lineNr) = #Null
			ProcedureReturn #False
		EndIf
		
		If *cursor\position\lineNr >= *cursor\selection\lineNr
			previousLineNr = *cursor\position\lineNr
		Else
			previousLineNr = *cursor\selection\lineNr
		EndIf
		
		Undo_Add(*undo, #TE_Undo_DeleteText, selection\pos1\lineNr, selection\pos1\charNr, 0, 0, Text_Get(*te, selection\pos1\lineNr, selection\pos1\charNr, selection\pos2\lineNr, selection\pos2\charNr))
		
		If nrLines = 1
			*te\textLine()\text = Text_Cut(*te\textLine()\text, selection\pos1\charNr, selection\pos2\charNr - selection\pos1\charNr)
		ElseIf nrLines = 2
			text = Left(*te\textLine()\text, selection\pos1\charNr - 1)
			If NextElement(*te\textLine())
				text + Mid(*te\textLine()\text, selection\pos2\charNr)
				Textline_Delete(*te)
			EndIf
			*te\textLine()\text = text
		ElseIf nrLines > 2
			text = Left(*te\textLine()\text, selection\pos1\charNr - 1)
			While (nrLines > 2) And NextElement(*te\textLine())
				Textline_Delete(*te)
				nrLines - 1
			Wend
			If NextElement(*te\textLine())
				text + Mid(*te\textLine()\text, selection\pos2\charNr)
				Textline_Delete(*te)
			EndIf
			*te\textLine()\text = text
		EndIf
		
		*te\leftBorderOffset = BorderSize(*te)
		
		Style_Textline(*te, *te\textLine(), #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation)
		
		*cursor\position\textline = *te\textLine()
		*cursor\position\lineNr = ListIndex(*te\textLine()) + 1
		*cursor\position\visibleLineNr = LineNr_to_VisibleLineNr(*te, *cursor\position\lineNr)
		*cursor\position\charNr = selection\pos1\charNr
		*cursor\position\textline\needStyling = #True
		
		*cursor\position\textline\needStyling = #True
		
		Cursor_MoveMulti(*te, *cursor, previousLineNr, selection\pos1\lineNr - selection\pos2\lineNr, selection\pos1\charNr - selection\pos2\charNr)
		Selection_Clear(*te, *cursor)
		
		If ListSize(*te\textLine()) = 1
			*te\maxTextWidth = Textline_Width(*te, FirstElement(*te\textLine()))
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Selection_HighlightText(*te.TE_STRUCT, startLine, startCharNr, endLine, endCharNr)
		ProcedureReturnIf( (*te = #Null) Or (startLine <> endLine)); Or (ListSize(*te\cursor()) > 1)
		
		Protected highlightSelection.s = ""
		
		PushListPosition(*te\textLine())
		If Textline_FromLine(*te, startLine)
			highlightSelection = Text_Get(*te, startLine, startCharNr, endLine, endCharNr)
		EndIf
		PopListPosition(*te\textLine())
		
		If (highlightSelection = *te\commentChar) Or (Trim(Trim(highlightSelection, " "), #TAB$) = "")
			*te\highlightSelection = ""
		ElseIf highlightSelection Or *te\highlightSelection
			*te\highlightSelection = highlightSelection
			SyntaxHighlight_Clear(*te)
		EndIf
	EndProcedure
	
	Procedure Selection_HighlightClear(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		If *te\highlightSelection
			*te\highlightSelection = ""
			*te\redrawMode | #TE_Redraw_All;ChangedLined
		EndIf
	EndProcedure
	
	Procedure Selection_SetRange(*te.TE_STRUCT, *cursor.TE_CURSOR, lineNr, charNr, highLight = #True, checkOverlap = #True)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
; 		CopyStructure(*cursor\selection, *cursor\lastSelection, TE_POSITION)
		
		Protected previousLineNr = *cursor\selection\lineNr
		Protected previousCharNr = *cursor\selection\charNr
		Protected result = #False
		
		; lineNr = index into the "*te\textLine()"-List
		
		If lineNr > ListSize(*te\textLine())
			lineNr = ListSize(*te\textLine())
			charNr = Textline_LastCharNr(*te, lineNr)
		Else
			lineNr = Clamp(lineNr, 1, ListSize(*te\textLine()))
			charNr = Max(charNr, 1)
		EndIf
		
		Selection_Start(*cursor, lineNr, charNr)
		
		If *cursor\position\lineNr <> lineNr
			SyntaxHighlight_Clear(*te)
		ElseIf highLight And (ListSize(*te\cursor()) = 1)
			Selection_HighlightText(*te, *cursor\position\lineNr, *cursor\position\charNr, lineNr, charNr)
		EndIf
		
		If checkOverlap
			*cursor = Cursor_DeleteOverlapping(*te, *cursor)
		EndIf
		
		If *cursor
			If (*cursor\selection\lineNr <> previousLineNr) Or (*cursor\selection\charNr <> previousCharNr)
				*te\redrawMode | #TE_Redraw_All
			EndIf
			
			If (*cursor\position\lineNr <> *cursor\selection\lineNr) Or (*cursor\position\charNr <> *cursor\selection\charNr)
				result = #True
			EndIf
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Add(*range.TE_RANGE, lineNr, charNr)
		ProcedureReturnIf(*range = #Null)
		
		If (lineNr < *range\pos1\lineNr) Or ( (lineNr = *range\pos1\lineNr) And (charNr < *range\pos1\charNr))
			*range\pos1\lineNr = lineNr
			*range\pos1\charNr = charNr
		ElseIf (lineNr > *range\pos2\lineNr) Or ( (lineNr = *range\pos2\lineNr) And (charNr > *range\pos2\charNr))
			*range\pos2\lineNr = lineNr
			*range\pos2\charNr = charNr
		EndIf
	EndProcedure
	
	Procedure Selection_SetRectangle(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Cursor_Clear(*te, *cursor)
		
		Protected *firstLine.TE_TEXTLINE, *lastLine.TE_TEXTLINE
		
		If *cursor\firstPosition\lineNr < *cursor\position\lineNr
			*firstLine = *cursor\firstPosition\textline
			*lastLine = *cursor\position\textline
		Else
			*firstLine = *cursor\position\textline
			*lastLine = *cursor\firstPosition\textline
		EndIf
		
		If *firstLine And *lastLine
			ChangeCurrentElement(*te\textLine(), *firstLine)
			
			Repeat
				If *te\textLine() <> *cursor\position\textline
					Cursor_Add(*te, ListIndex(*te\textLine()) + 1, Textline_CharNrFromScreenPos(*te, *te\textLine(), *cursor\position\charX), #False)
				EndIf
			Until (*te\textLine() = *lastLine) Or (NextElement(*te\textLine()) = #Null)
			
			ForEach *te\cursor()
				Selection_SetRange(*te, *te\cursor(), *te\cursor()\position\lineNr, Textline_CharNrFromScreenPos(*te, *te\cursor()\position\textline, *cursor\firstPosition\charX), #False, #False)
				CopyStructure(*cursor\firstPosition, *te\cursor()\firstPosition, TE_POSITION)
			Next
			
			Find_SetSelectionCheckbox(*te)
		EndIf
		
		ProcedureReturn ListSize(*te\cursor())
	EndProcedure
	
	Procedure Selection_SelectAll(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)

		Cursor_Clear(*te, *te\maincursor)
		
		Cursor_Position(*te, *te\maincursor, 1, 1)
		
		ProcedureReturn Selection_SetRange(*te, *te\maincursor, ListSize(*te\textLine()), Textline_Length(LastElement(*te\textLine())) + 1)
	EndProcedure
	
	Procedure Selection_Clear(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		If Cursor_HasSelection(*cursor)
			*te\redrawMode | #TE_Redraw_All
		EndIf
		
		Selection_HighlightClear(*te)
		Selection_Start(*cursor, 0, 0)
	EndProcedure
	
	Procedure Selection_ClearAll(*te.TE_STRUCT, deleteCursors = #False)
		ProcedureReturnIf(*te = #Null)
		
		If deleteCursors
			Cursor_Clear(*te, *te\maincursor)
		EndIf
		
		ForEach *te\cursor()
			Selection_Start(*te\cursor(), 0, 0)
		Next
		
		Selection_HighlightClear(*te)
		
		If IsGadget(*te\find\chk_insideSelection)
			DisableGadget(*te\find\chk_insideSelection, #True)
		EndIf
	EndProcedure
	
	Procedure.s Selection_Text(*te.TE_STRUCT, delimiter.s = "")
		ProcedureReturnIf(*te = #Null, "")
		
		Protected.s result, lastText, currentText
		Protected count
		
		SortStructuredList(*te\cursor(), #PB_Sort_Ascending, OffsetOf(TE_CURSOR\number), TypeOf(TE_CURSOR\number))
		
		ForEach *te\cursor()
			;lastText = LCase(currentText)
			currentText = Text_Get(*te, *te\cursor()\position\lineNr, *te\cursor()\position\charNr, *te\cursor()\selection\lineNr, *te\cursor()\selection\charNr)
			
			If lastText <> LCase(currentText)
				If count
					result + delimiter
				EndIf
				
				result + currentText
				count + 1
			EndIf
		Next
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Unfold(*te.TE_STRUCT, startLine, endLine)
		ProcedureReturnIf( (*te = #Null) Or (ListSize(*te\textLine()) = 0))
	EndProcedure
	
	Procedure Selection_Move(*te.TE_STRUCT, direction)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentCursor = #Null) Or (direction = 0))
		
		Protected *cursor.TE_CURSOR = *te\currentCursor
		Protected selection.TE_RANGE
		Protected text.s
		
		direction = Clamp(direction, -1, 1)
		
		Cursor_Clear(*te, *cursor)
		
		If Cursor_HasSelection(*cursor) = #False
			Cursor_Position(*te, *cursor, *cursor\position\lineNr, 1)
			Selection_SetRange(*te, *cursor, *cursor\position\lineNr, Textline_LastCharNr(*te, *cursor\position\lineNr))
		EndIf
		
		If Selection_Get(*cursor, selection)
			Undo_Start(*te\undo)
			If (direction < 0) And (selection\pos1\lineNr > 1)
				Cursor_Position(*te, *cursor, selection\pos1\lineNr - 1, 1)
				Selection_SetRange(*te, *cursor, selection\pos1\lineNr, 1)
				text = Text_Get(*te, *cursor\position\lineNr, *cursor\position\charNr, *cursor\selection\lineNr, *cursor\selection\charNr)
				
				If Selection_Delete(*te, *cursor, *te\undo)
					If (selection\pos2\lineNr) > ListSize(*te\textLine())
						text = *te\newLineText + RTrim(text, *te\newLineText)
					EndIf
					Cursor_Position(*te, *cursor, selection\pos2\lineNr, 1)
					Textline_AddText(*te, *cursor, @text, Len(text), #TE_Styling_All, *te\undo)
					
					Cursor_Position(*te, *cursor, selection\pos1\lineNr - 1, 1)
					Selection_SetRange(*te, *cursor, selection\pos2\lineNr - 1, Textline_LastCharNr(*te, selection\pos2\lineNr - 1))
				EndIf
			ElseIf (direction > 0) And (selection\pos2\lineNr < ListSize(*te\textLine()))
				Cursor_Position(*te, *cursor, selection\pos2\lineNr + 1, 1)
				Selection_SetRange(*te, *cursor, selection\pos2\lineNr + 2, 1)
				
				text = Text_Get(*te, *cursor\position\lineNr, *cursor\position\charNr, *cursor\selection\lineNr, *cursor\selection\charNr)
				
				If (selection\pos2\lineNr + 2) > ListSize(*te\textLine())
					Cursor_Position(*te, *cursor, ListSize(*te\textLine()) - 1, Textline_LastCharNr(*te, ListSize(*te\textLine()) - 1))
				EndIf
				
				If Selection_Delete(*te, *cursor, *te\undo)
					Cursor_Position(*te, *cursor, selection\pos1\lineNr, 1)
					Textline_AddText(*te, *cursor, @text, Len(text), #TE_Styling_All, *te\undo)
					Selection_SetRange(*te, *cursor, selection\pos2\lineNr + 1, Textline_LastCharNr(*te, selection\pos2\lineNr + 1))
				EndIf
			Else
				Cursor_Position(*te, *cursor, selection\pos1\lineNr, 1)
				Selection_SetRange(*te, *cursor, selection\pos2\lineNr, Textline_LastCharNr(*te, selection\pos2\lineNr))
			EndIf
			Undo_Update(*te)
			
			*te\redrawMode | #TE_Redraw_ChangedLined
			*te\needFoldUpdate = #True
		EndIf
	EndProcedure
	
	Procedure Selection_Clone(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected text.s
		Protected lastLine
		
		Protected previousLineNr
		Protected previousCharNr
		
		previousLineNr = *cursor\position\lineNr
		previousCharNr = *cursor\position\charNr
		
		text.s = Text_Get(*te, *cursor\position\lineNr, *cursor\position\charNr, *cursor\selection\lineNr, *cursor\selection\charNr)
		
		If text = ""
			text = *te\newLineText + *cursor\position\textline\text
			Cursor_Position(*te, *cursor, *cursor\position\lineNr, Textline_Length(*cursor\position\textline) + 1)
		EndIf
		
		If text
			Textline_AddText(*te, *cursor, @text, Len(text), #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *te\undo)
			lastLine = *cursor\position\lineNr
			
			Cursor_Position(*te, *cursor, previousLineNr, previousCharNr)
			
			ProcedureReturn lastLine
		EndIf
	EndProcedure
	
	Procedure Selection_Comment(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected result = #False
		Protected i
		Protected selection.TE_RANGE
		Protected commentText.s = *te\commentChar + " "
		
		If Selection_Get(*cursor, selection) = #False
			selection\pos1\lineNr = *cursor\position\lineNr
			selection\pos2\lineNr = *cursor\position\lineNr
		EndIf
		
		If Textline_FromLine(*te, selection\pos1\lineNr)
			Repeat
				PushListPosition(*te\textLine())
				Cursor_Position(*te, *cursor, ListIndex(*te\textLine()) + 1, 1)
				If Textline_AddText(*te, *cursor, @commentText, Len(commentText), #TE_Styling_UpdateFolding, *te\undo)
					result = #True
				EndIf
				PopListPosition(*te\textLine())
			Until (ListIndex(*te\textLine()) >= selection\pos2\lineNr - 1) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		
		Cursor_Position(*te, *cursor, selection\pos2\lineNr, Textline_LastCharNr(*te, selection\pos2\lineNr))
		Selection_SetRange(*te, *cursor, selection\pos1\lineNr, 1)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Uncomment(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected result = #False
		Protected lineNr
		Protected selection.TE_RANGE, rng.TE_RANGE
		
		If Selection_Get(*cursor, selection) = #False
			selection\pos1\lineNr = *cursor\position\lineNr
			selection\pos2\lineNr = *cursor\position\lineNr
		EndIf
		
		If Textline_FromLine(*te, selection\pos1\lineNr)
			Repeat
				PushListPosition(*te\textLine())
				lineNr = ListIndex(*te\textLine()) + 1
				If Textline_FindText(@*te\textLine(), *te\commentChar + " ", @rng, #True) Or Textline_FindText(@*te\textLine(), *te\commentChar, @rng, #True)
					Cursor_Position(*te, *cursor, lineNr, rng\pos1\charNr)
					If Selection_SetRange(*te, *cursor, lineNr, rng\pos2\charNr, #False)
						Selection_Delete(*te, *cursor, *te\undo)
						result = #True
					EndIf
				EndIf
				PopListPosition(*te\textLine())
			Until (ListIndex(*te\textLine()) >= selection\pos2\lineNr - 1) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		
		Cursor_Position(*te, *cursor, selection\pos2\lineNr, Textline_LastCharNr(*te, *cursor\position\lineNr))
		Selection_SetRange(*te, *cursor, selection\pos1\lineNr, 1)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_MoveComment(*te.TE_STRUCT, dir)
		ProcedureReturnIf( (*te = #Null))
		
		; align selected comments
		
		Protected result = #False
		Protected lineNr
		Protected selection.TE_RANGE
		Protected *token.TE_TOKEN
		Protected charNr, column, commentColumn
		Protected text.s
		Protected i
		
		PushListPosition(*te\textLine())
		PushListPosition(*te\cursor())
		
		; find min/max column of selected comments
		ForEach *te\cursor()
			If Selection_Get(*te\cursor(), selection)
				If Textline_FromLine(*te, selection\pos1\lineNr)
					Repeat
						lineNr = ListIndex(*te\textLine()) + 1
						For i = 1 To *te\textLine()\tokenCount
							*token = @*te\textLine()\token(i)
							If *token\type = #TE_Token_Comment
								column = Textline_ColumnFromCharNr(*te, *te\currentView, *te\textLine(), *token\charNr)
								
								If (dir > 0) And ( (column < commentColumn) Or (commentColumn = 0))
									commentColumn = column
								ElseIf (dir < 0) And (column > commentColumn)
									If (i > 1) And (*te\textLine()\token(i - 1)\type = #TE_Token_Whitespace)
										commentColumn = column
									EndIf
								EndIf
								Break
							EndIf
						Next
					Until (lineNr >= selection\pos2\lineNr) Or (NextElement(*te\textLine()) = #Null)
				EndIf
			EndIf
		Next
		
		; move the comments according to the min max position
		ForEach *te\cursor()
			If Selection_Get(*te\cursor(), selection)
				If Textline_FromLine(*te, selection\pos1\lineNr)
					Repeat
						lineNr = ListIndex(*te\textLine()) + 1
						For i = 1 To *te\textLine()\tokenCount
							*token = @*te\textLine()\token(i)
							If *token\type = #TE_Token_Comment
								column = Textline_ColumnFromCharNr(*te, *te\currentView, *te\textLine(), *token\charNr)
								If (dir < 0) And (column = commentColumn)
									If (i > 1) And (*te\textLine()\token(i - 1)\type = #TE_Token_Whitespace)
										Cursor_Position(*te, *te\cursor(), lineNr, *token\charNr - 1, #False, #False)
										Selection_SetRange(*te, *te\cursor(), lineNr, *token\charNr, #False, #False)
										Selection_Delete(*te, *te\cursor(), *te\undo)
										result = #True
									EndIf
								ElseIf (dir > 0) And (column = commentColumn)
									Cursor_Position(*te, *te\cursor(), lineNr, *token\charNr)
									If *te\useRealTab
										Textline_AddChar(*te, *te\cursor(), #TAB, #False, 0, *te\undo)
									Else
										text = Space(Textline_NextTabSize(*te, *te\textLine(), *token\charNr))
										Textline_AddText(*te, *te\cursor(), @text, Len(text), 0, *te\undo)
									EndIf
									result = #True
								EndIf
								Break
							EndIf
						Next
					Until (lineNr >= selection\pos2\lineNr) Or (NextElement(*te\textLine()) = #Null)
				EndIf
				
				Cursor_Position(*te, *te\cursor(), selection\pos2\lineNr, Textline_LastCharNr(*te, *te\cursor()\position\lineNr))
				Selection_SetRange(*te, *te\cursor(), selection\pos1\lineNr, 1)
			EndIf
		Next
		
		PopListPosition(*te\cursor())
		PopListPosition(*te\textLine())
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Indent(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\lineNr = *cursor\selection\lineNr))
		
		Protected result = #False
		
		Protected charNr = *cursor\position\charNr
		Protected textLen = Textline_Length(*cursor\position\textline)
		Protected selTextLen
		
		Protected selection.TE_RANGE
		Protected previousLineNr = *cursor\position\lineNr
		Protected previousCharNr = *cursor\position\charNr
		Protected *token.TE_TOKEN
		Protected lastSel.TE_POSITION, lastPos.TE_POSITION
		CopyStructure(*cursor\selection, lastSel, TE_POSITION)
		CopyStructure(*cursor\position, lastPos, TE_POSITION)
		
		If Selection_Get(*cursor, selection) = #False
			ProcedureReturn #False
		EndIf
		
		PushListPosition(*te\textLine())
		selTextLen = Textline_Length(Textline_FromLine(*te, *cursor\selection\lineNr))
		If Textline_FromLine(*te, selection\pos1\lineNr)
			Repeat
				PushListPosition(*te\textLine())
				Cursor_Position(*te, *cursor, ListIndex(*te\textLine()) + 1, 1)
				result + Indentation_Add(*te, *cursor)
				PopListPosition(*te\textLine())
			Until (ListIndex(*te\textLine()) + 1 >= selection\pos2\lineNr) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		PopListPosition(*te\textLine())
		
		Cursor_Position(*te, *cursor, lastPos\lineNr, charNr + (Textline_Length(lastPos\textline) - textLen))
		If (lastSel\lineNr = *cursor\position\lineNr) And (lastSel\charNr = charNr)
			Selection_Clear(*te, *cursor)
		Else
			Selection_SetRange(*te, *cursor, lastSel\lineNr, lastSel\charNr + (Textline_Length(Textline_FromLine(*te, lastSel\lineNr)) - selTextLen))
		EndIf
		
		*te\needScrollUpdate = #False
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Unindent(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null)); Or (*cursor\position\lineNr = *cursor\selection\lineNr))
		
		Protected result = 0
		
		Protected charNr = *cursor\position\charNr
		Protected textLen = Textline_Length(*cursor\position\textline)
		Protected selTextLen
		Protected selection.TE_RANGE
		Protected lastSel.TE_POSITION, lastPos.TE_POSITION
		CopyStructure(*cursor\selection, lastSel, TE_POSITION)
		CopyStructure(*cursor\position, lastPos, TE_POSITION)
		lastSel\textline = Textline_FromLine(*te, lastSel\lineNr)
		
		If Selection_Get(*cursor, selection) = #False
			selection\pos1\lineNr = *cursor\position\lineNr
			selection\pos2\lineNr = *cursor\position\lineNr
		EndIf
		
		PushListPosition(*te\textLine())
		selTextLen = Textline_Length(Textline_FromLine(*te, *cursor\selection\lineNr))
		If Textline_FromLine(*te, selection\pos1\lineNr)
			Repeat
				PushListPosition(*te\textLine())
				Cursor_Position(*te, *cursor, ListIndex(*te\textLine()) + 1, 1)
				result + Indentation_LTrim(*te, *cursor)
				PopListPosition(*te\textLine())
			Until (ListIndex(*te\textLine()) + 1 >= selection\pos2\lineNr) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		
		Cursor_Position(*te, *cursor, lastPos\lineNr, charNr + (Textline_Length(lastPos\textline) - textLen))
		If (lastSel\lineNr = *cursor\position\lineNr) And (lastSel\charNr = charNr)
			Selection_Clear(*te, *cursor)
		Else
			Selection_SetRange(*te, *cursor, lastSel\lineNr, lastSel\charNr + (Textline_Length(lastSel\textline) - selTextLen))
		EndIf
		PopListPosition(*te\textLine())
		
		*te\needScrollUpdate = #False
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Beautify(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected result = 0
		Protected selection.TE_RANGE
		
		If Selection_Get(*cursor, selection) = #False
			selection\pos1\lineNr = *cursor\position\lineNr
			selection\pos2\lineNr = *cursor\position\lineNr
		EndIf
		
		PushListPosition(*te\textLine())
		If Textline_FromLine(*te, selection\pos1\lineNr)
			Repeat
				result + Textline_Beautify(*te, *te\textLine())
			Until (ListIndex(*te\textLine()) + 1 >= selection\pos2\lineNr) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		
		If result
			Indentation_Range(*te, selection\pos1\lineNr, selection\pos2\lineNr, *cursor)
		EndIf
		PopListPosition(*te\textLine())
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_IsAnythingSelected(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected result = #False
		Protected *selection.TE_RANGE
		
		PushListPosition(*te\cursor())
		ForEach *te\cursor()
			*selection = @*te\cursor()\selection
			
			If (*selection\pos1\lineNr <= 0) Or (*selection\pos2\lineNr <= 0)
			ElseIf (*selection\pos1\lineNr <> *selection\pos2\lineNr) Or
				(*selection\pos1\charNr <> *selection\pos2\charNr)
				result = #True
				Break
			EndIf
		Next
		PopListPosition(*te\cursor())
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Selection_Overlap(*sel1.TE_RANGE, *sel2.TE_RANGE)
		If *sel1\pos1\lineNr > *sel2\pos1\lineNr
			Swap *sel1, *sel2
		ElseIf (*sel1\pos1\lineNr = *sel2\pos2\lineNr) And (*sel1\pos1\charNr > *sel2\pos1\charNr)
			Swap *sel1, *sel2
		EndIf
		
		If *sel1\pos2\lineNr < *sel2\pos1\lineNr
			ProcedureReturn #False
		ElseIf (*sel1\pos2\lineNr = *sel2\pos1\lineNr) And (*sel1\pos2\charNr <= *sel2\pos1\charNr)
			ProcedureReturn #False
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Selection_FromTextLine(*te.TE_STRUCT, *textline.TE_TEXTLINE, *result.TE_RANGE)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null) Or (*result = #Null))
		
		Protected selection.TE_RANGE
		Protected lineNr = Textline_LineNr(*te, *textline)
		Protected found = #False
		
		PushListPosition(*te\cursor())
		ForEach *te\cursor()
			If Selection_Get(*te\cursor(), selection)
				If (selection\pos1\lineNr <= lineNr) And (selection\pos2\lineNr >= lineNr)
					If selection\pos1\lineNr = lineNr
						*result\pos1\lineNr = lineNr
						*result\pos1\charNr = selection\pos1\charNr
					ElseIf selection\pos1\lineNr < lineNr
						*result\pos1\charNr = 1
					EndIf
					If selection\pos2\lineNr = lineNr
						*result\pos2\lineNr = lineNr
						*result\pos2\charNr = selection\pos2\charNr
					ElseIf selection\pos2\lineNr > lineNr
						*result\pos2\charNr = Len(*textline\text)
					EndIf
					found = #True
				EndIf
			EndIf
		Next
		PopListPosition(*te\cursor())
		
		ProcedureReturn found
	EndProcedure
	
	Procedure Selection_ChangeCase(*te.TE_STRUCT, mode)
		ProcedureReturnIf(*te = #Null)
		
		Protected result
		Protected text.s, newTexxt.s
		
		ForEach *te\cursor()
			text = Text_Get(*te, *te\cursor()\position\lineNr, *te\cursor()\position\charNr, *te\cursor()\selection\lineNr, *te\cursor()\selection\charNr)
			
			If mode = #TE_Text_LowerCase
				newTexxt = LCase(text)
			Else
				newTexxt = UCase(text)
			EndIf
			
			If text <> newTexxt
				Selection_Delete(*te, *te\cursor(), *te\undo)
				Selection_Start(*te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr)
				result + Textline_AddText(*te, *te\cursor(), @newTexxt, Len(newTexxt), #TE_Styling_All, *te\undo)
			EndIf
		Next
		
		ProcedureReturn result
	EndProcedure
	
	;-
	;- ----------- CURSOR -----------
	;-
	
	Procedure Cursor_Add(*te.TE_STRUCT, lineNr, charNr, checkOverlap = #True, startSelection = #True)
		ProcedureReturnIf(*te = #Null)
		
		Protected *cursor.TE_CURSOR
		Protected selection.TE_RANGE
		
		If (*te\enableMultiCursor = #False) And (ListSize(*te\cursor()) > 0)
			ProcedureReturn *te\currentCursor
		EndIf
		
		If ListSize(*te\cursor()) >= #TE_MaxCursors
			ProcedureReturn #Null
		EndIf
		
		If checkOverlap
			ForEach *te\cursor()
				If (*te\cursor()\position\lineNr = lineNr) And (*te\cursor()\position\charNr = charNr)
					*cursor = Cursor_Delete(*te, *te\cursor())
					If *cursor
 						CopyStructure(*cursor\position, *te\cursorState\lastPosition, TE_POSITION)
						Selection_Start(*cursor, *cursor\position\lineNr, *cursor\position\charNr)
					EndIf
					ProcedureReturn *cursor
				EndIf
			Next
		EndIf
		
		*cursor = AddElement(*te\cursor())
		
		If *cursor
			If *te\maincursor = #Null
				*te\maincursor = *cursor
			EndIf
			
			*cursor\number = ListIndex(*te\cursor())
			*te\currentCursor = *cursor
			*te\currentCursor\visible = #True
			Selection_Start(*te\currentCursor, 0, 0)
			Cursor_Position(*te, *cursor, lineNr, charNr)
			
			Cursor_Sort(*te)
			
			If checkOverlap
				ChangeCurrentElement(*te\cursor(), *cursor)
				If PreviousElement(*te\cursor())
					If Selection_Get(*te\cursor(), selection)
						If Position_InsideRange(*cursor\position, selection)
							*cursor = Cursor_Delete(*te, *te\cursor())
						EndIf
					EndIf
				EndIf
				
				If *cursor
					Cursor_Sort(*te)
					
					ChangeCurrentElement(*te\cursor(), *cursor)
					If NextElement(*te\cursor())
						If Selection_Get(*te\cursor(), selection)
							If Position_InsideRange(*cursor\position, selection)
								*cursor = Cursor_Delete(*te, *te\cursor())
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
		If *cursor
			CopyStructure(*cursor\position, *te\cursorState\lastPosition, TE_POSITION)
			CopyStructure(*cursor\position, *cursor\firstPosition, TE_POSITION)
			If startSelection
				Selection_Start(*cursor, *cursor\position\lineNr, *cursor\position\charNr)
				Selection_Get(*cursor, *te\cursorState\firstSelection)
			EndIf
		EndIf
		
		PostEvent(#TE_Event_Cursor, *te\window, 0, #TE_EventType_Add)
		
		ProcedureReturn *cursor
	EndProcedure
	
	Procedure Cursor_Delete(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		If ListSize(*te\cursor()) = 1
			*te\maincursor = LastElement(*te\cursor())
			*te\currentCursor = *te\maincursor
			
			ProcedureReturn *te\maincursor
		EndIf
		
		If *cursor = *te\maincursor
			*te\maincursor = #Null
		EndIf
		If *cursor = *te\currentCursor
			*te\currentCursor = #Null
		EndIf
		
		If Cursor_HasSelection(*cursor)
			*te\redrawMode | #TE_Redraw_All
		EndIf
		
		ChangeCurrentElement(*te\cursor(), *cursor)
		*cursor = DeleteElement(*te\cursor(), 1)
		
		If *te\maincursor = #Null
			*te\maincursor = *cursor
		EndIf
		If *te\currentCursor = #Null
			*te\currentCursor = *cursor
		EndIf
		
		*te\redrawMode | #TE_Redraw_ChangedLined
		*cursor\position\textline\needRedraw = #True
		
		
		PostEvent(#TE_Event_Cursor, *te\window, 0, #TE_EventType_Remove)
		
		ProcedureReturn *cursor
	EndProcedure
	
	Procedure Cursor_AddMultiFromText(*te.TE_STRUCT, text.s)
		Protected i, textLen
		Protected *c.Character
		Protected *currentCursor.TE_CURSOR = *te\currentCursor
		Protected *cursor.TE_CURSOR
		
		If text
			textLen = Len(text)
			
			ForEach *te\textLine()
				*c = @*te\textLine()\text
				i = 0
				
				While *c\c
					i + 1
					If CompareMemoryString(*c, @text, *te\cursorState\compareMode, textLen) = #PB_String_Equal
						*cursor = Cursor_Add(*te, ListIndex(*te\textLine()) + 1, i, #False)
						If *cursor
							Selection_Start(*cursor, *cursor\position\lineNr, *cursor\position\charNr)
							Selection_SetRange(*te, *cursor, *cursor\position\lineNr, *cursor\position\charNr + textLen, #False, #False)
						EndIf
					EndIf
					*c + #TE_CharSize
				Wend
			Next
		EndIf
		
		*te\currentCursor = *currentCursor
	EndProcedure
	
	
	Procedure Cursor_DeleteOverlapping(*te.TE_STRUCT, *cursor.TE_CURSOR, joinSelections = #False)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected selection1.TE_RANGE
		Protected selection2.TE_RANGE
		Protected *currentCursor.TE_CURSOR
		Protected delete
		
		If ListSize(*te\cursor()) = 0
			ProcedureReturn #Null
		EndIf
		
		If ListIndex(*te\cursor()) >= 0
			*currentCursor = *te\cursor()
		EndIf
		
		Selection_Get(*cursor, selection1)
		
		Cursor_Sort(*te)
		
		ForEach *te\cursor()
			If *te\cursor() <> *cursor
				
				If *currentCursor = #Null
					*currentCursor = *te\cursor()
				EndIf
				
				delete = #False
				
				If (*te\cursor()\position\lineNr = *cursor\position\lineNr) And (*te\cursor()\position\charNr = *cursor\position\charNr)
					; SAME LOCATION
					delete = 1
				ElseIf Position_InsideRange(*te\cursor()\position, selection1)
					; INSIDE RANGE
					delete = 2
				ElseIf Selection_Get(*te\cursor(), selection2) And Cursor_HasSelection(*te\cursor()) And Selection_Overlap(selection1, selection2)
					;OVERLAP
					delete = 3
				EndIf
				
				If delete
					If *te\cursor() = *currentCursor
						*currentCursor = #Null
					EndIf
					
					If joinSelections And (delete > 1) And Selection_Get(*te\cursor(), selection2)
						Selection_Add(selection1, selection2\pos1\lineNr, selection2\pos1\charNr)
						Selection_Add(selection1, selection2\pos2\lineNr, selection2\pos2\charNr)
						
						If *cursor\selection\lineNr > 0
							If (*cursor\position\lineNr < *cursor\selection\lineNr) Or (*cursor\position\lineNr = *cursor\selection\lineNr And (*cursor\position\charNr < *cursor\selection\charNr))
								Cursor_Position(*te, *cursor, selection1\pos1\lineNr, selection1\pos1\charNr)
								Selection_Start(*cursor, selection1\pos2\lineNr, selection1\pos2\charNr)
							Else
								Cursor_Position(*te, *cursor, selection1\pos2\lineNr, selection1\pos2\charNr)
								Selection_Start(*cursor, selection1\pos1\lineNr, selection1\pos1\charNr)
							EndIf
						EndIf
					EndIf
					
					Cursor_Delete(*te, *te\cursor())
				EndIf
				
			EndIf
		Next
		
		If *currentCursor
			ChangeCurrentElement(*te\cursor(), *currentCursor)
		EndIf
		
		ProcedureReturn *currentCursor
	EndProcedure
	
	Procedure Cursor_Clear(*te.TE_STRUCT, *maincursor.TE_CURSOR)
		ProcedureReturnIf(*te = #Null)
		
		ForEach *te\cursor()
			If *te\cursor()\position\textline
				*te\cursor()\position\textline\needRedraw = #True
			EndIf
			If *te\cursor() <> *maincursor
				DeleteElement(*te\cursor())
			EndIf
		Next
		
		*te\maincursor = *maincursor
		*te\currentCursor = *maincursor
		*te\redrawMode | #TE_Redraw_ChangedLined
		
		PostEvent(#TE_Event_Cursor, *te\window, 0, #TE_EventType_Remove)
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Cursor_Set(*cursor.TE_CURSOR, *textline.TE_TEXTLINE, lineNr, visibleLineNr, charNr)
		ProcedureReturnIf(*cursor = #Null)
		
; 		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		
		*cursor\position\textline = *textline
		*cursor\position\lineNr = lineNr
		*cursor\position\visibleLineNr = visibleLineNr
		*cursor\position\charNr = charNr
	EndProcedure
	
	Procedure Cursor_LineHistoryAdd(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentCursor = #Null))
		
		Protected *cursor.TE_CURSOR = *te\currentCursor
		
		If Abs(*cursor\position\lineNr - *cursor\lastPosition\lineNr) > 20
			While ListSize(*te\lineHistory()) >= 20
				FirstElement(*te\lineHistory())
				DeleteElement(*te\lineHistory())
			Wend
			If LastElement(*te\lineHistory()) And (*te\lineHistory() = *cursor\lastPosition\lineNr)
				ProcedureReturn #False
			EndIf
			If AddElement(*te\lineHistory())
				*te\lineHistory() = *cursor\lastPosition\lineNr
				ProcedureReturn #True
			EndIf
		EndIf
	EndProcedure
	
	Procedure Cursor_LineHistoryGoto(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (*te\maincursor = #Null))
		
		If LastElement(*te\lineHistory())
			Cursor_Position(*te, *te\maincursor, *te\lineHistory(), 1)
			If ListSize(*te\lineHistory()) > 1
				DeleteElement(*te\lineHistory())
			EndIf
			
			Selection_ClearAll(*te)
		EndIf
	EndProcedure
	
	Procedure Cursor_Sort(*te.TE_STRUCT, sortOrder = #PB_Sort_Ascending)
		ProcedureReturnIf(*te = #Null)
		
		; 	sort the cursors
		;	1. by lineNr from low to high
		;	2. by charNr from low to high
		
		Protected *start.TE_CURSOR, startIndex, endIndex
		
		SortStructuredList(*te\cursor(), #PB_Sort_Ascending, OffsetOf(TE_cursor\position) + OffsetOf(TE_POSITION\lineNr), TypeOf(TE_POSITION\lineNr))
		
		ForEach *te\cursor()
			*start = *te\cursor()
			startIndex = ListIndex(*te\cursor())
			While NextElement(*te\cursor())
				If *te\cursor()\position\textline = *start\position\textline
					endIndex = ListIndex(*te\cursor())
				Else
					PreviousElement(*te\cursor())
					Break
				EndIf
			Wend
			If endIndex > startIndex
				SortStructuredList(*te\cursor(), sortOrder, OffsetOf(TE_cursor\position) + OffsetOf(TE_POSITION\charNr), #PB_Integer, startIndex, endIndex)
				SelectElement(*te\cursor(), endIndex)
			EndIf
		Next
	EndProcedure
	
	Procedure Cursor_MoveMulti(*te.TE_STRUCT, *cursor.TE_CURSOR, previousLineNr, dirY, dirX)
		ProcedureReturnIf(ListSize(*te\cursor()) < 2)
		
		PushListPosition(*te\cursor())
		ChangeCurrentElement(*te\cursor(), *cursor)
		
		CopyStructure(*cursor\selection, *cursor\lastSelection, TE_POSITION)
		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		
		While NextElement(*te\cursor())
			If dirX And (*te\cursor()\position\lineNr = previousLineNr)
				*te\cursor()\position\charNr + dirX
				
				If Cursor_HasSelection(*te\cursor())
					*te\cursor()\selection\charNr + dirX
				EndIf
			EndIf
			If dirY
				*te\cursor()\position\lineNr + dirY
				*te\cursor()\position\visibleLineNr + dirY
				*te\cursor()\position\textline = Textline_FromLine(*te, *te\cursor()\position\lineNr)
				
				If Cursor_HasSelection(*te\cursor())
					*te\cursor()\selection\lineNr + dirY
				EndIf
			EndIf
		Wend
		PopListPosition(*te\cursor())
	EndProcedure
	
	Procedure Cursor_Update(*te.TE_STRUCT, *cursor.TE_CURSOR, updateLastX)
		; needs to be called every time the cursorposition has changed.
		; - style the previous textline
		; - prepare redrawing all cursors
		
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected result = #False
		
		; 				Cursor_DeleteOverlapping(*te, *cursor)
		
		If updateLastX
			*cursor\position\charX = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr)
			*cursor\position\currentX = *cursor\position\charX
		EndIf
		
		If *cursor\lastPosition\textline And (*cursor\lastPosition\textline <> *cursor\position\textline) And *cursor\lastPosition\textline\needStyling
			;style the previous textline
			Style_Textline(*te, *cursor\lastPosition\textline, #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation)
			*cursor\lastPosition\textline\needStyling = #False
		EndIf
		
		If (*cursor\lastPosition\textline <> *cursor\position\textline) Or (*cursor\lastPosition\charNr <> *cursor\position\charNr)
			If *cursor\position\textline
				*cursor\position\textline\needRedraw = #True
			EndIf
			If *cursor\lastPosition\textline
				*cursor\lastPosition\textline\needRedraw = #True
			EndIf
			
			*te\cursorState\blinkState = 1
			*te\cursorState\blinkSuspend = 1
			
			result = #True
		EndIf
		
		If Cursor_HasSelection(*cursor) = #False
			Selection_HighlightClear(*te)
		EndIf
		
		*te\redrawMode | #TE_Redraw_ChangedLined
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Cursor_Move(*te.TE_STRUCT, *cursor.TE_CURSOR, dirY, dirX)
		; returnvalues:
		; #false	-	no current lineNr or cursorposition unchanged
		; #true		-	lineNr or charNr has changed
		
		ProcedureReturnIf( (*te = #Null) Or ListSize(*te\textLine()) = 0)
		ProcedureReturnIf( (dirX = 0) And (dirY = 0))
		
		Protected visibleLineNr
		
		; if cursor is inside folded block, jump outside
		Protected *textblock.TE_TEXTBLOCK = Folding_GetTextBlock(*te, *cursor\position\lineNr)
		If *textblock And (*textblock\firstLine\foldState & #TE_Folding_Folded)
			If *cursor\position\lineNr > *textblock\firstLineNr
				If dirX < 0
					ProcedureReturn Cursor_Position(*te, *cursor, *textblock\firstLineNr, Len(*textblock\firstLine\text) + 1, #False)
				ElseIf dirX > 0
					ProcedureReturn Cursor_Position(*te, *cursor, *textblock\lastLineNr + 1, 1, #False)
				EndIf
				
				If dirY < 0
					ProcedureReturn Cursor_Position(*te, *cursor, *textblock\firstLineNr, *cursor\position\charNr, #False, #False)
				Else
					ProcedureReturn Cursor_Position(*te, *cursor, *textblock\lastLineNr + 1, *cursor\position\charNr, #False, #False)
				EndIf
			EndIf
		EndIf
		
		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		
		If dirX
			If (*cursor\position\charNr + dirX) < 1
				If Cursor_Move(*te.TE_STRUCT, *cursor, -1, 0)
					*cursor\position\charNr = Max(1, Textline_Length(*cursor\position\textline) + 1)
				EndIf
			ElseIf ( (*cursor\position\charNr + dirX) > Textline_Length(*cursor\position\textline) + 1) And (*cursor\position\visibleLineNr < *te\visibleLineCount)
				If Cursor_Move(*te.TE_STRUCT, *cursor, 1, 0)
					*cursor\position\charNr = 1
				EndIf
			Else
				*cursor\position\charNr = Clamp(*cursor\position\charNr + dirX, 1, Textline_Length(*cursor\position\textline) + 1)
			EndIf
			
			ProcedureReturn Cursor_Update(*te, *cursor, #True)
		EndIf
		
		If dirY
			visibleLineNr = Clamp(*cursor\position\visibleLineNr + dirY, 1, *te\visibleLineCount)
			
			If Textline_FromVisibleLineNr(*te, visibleLineNr)
				*cursor\position\textline = *te\textLine()
				*cursor\position\lineNr = ListIndex(*te\textLine()) + 1
				*cursor\position\visibleLineNr = visibleLineNr
				
				If (*cursor\lastPosition\lineNr + dirY) < 1
					*cursor\position\charNr = 1
				ElseIf (*cursor\lastPosition\visibleLineNr + dirY) > *te\visibleLineCount
					*cursor\position\charNr = Textline_Length(*cursor\position\textline) + 1
				Else
					*cursor\position\charNr = Textline_CharNrFromScreenPos(*te, *cursor\position\textline, *cursor\position\currentX)
				EndIf
			EndIf
			
			ProcedureReturn Cursor_Update(*te, *cursor, #False)
		EndIf
	EndProcedure
	
	Procedure Cursor_Position(*te.TE_STRUCT, *cursor.TE_CURSOR, lineNr, charNr, ensureVisible = #True, updateLastX = #True)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (ListSize(*te\textLine()) = 0))
		
		If ensureVisible
			Protected *textblock.TE_TEXTBLOCK = Folding_GetTextBlock(*te, lineNr)
			If *textblock And (*textblock\firstLine\foldState & #TE_Folding_Folded)
				lineNr = *textblock\firstLineNr
			EndIf
		EndIf
		
		If Textline_FromLine(*te, lineNr)
			*cursor\position\textline = *te\textLine()
			*cursor\position\lineNr = ListIndex(*te\textLine()) + 1
			*cursor\position\visibleLineNr = LineNr_to_VisibleLineNr(*te, *cursor\position\lineNr)
			
			If lineNr > ListSize(*te\textLine())
				*cursor\position\charNr = Textline_Length(*te\textLine()) + 1
			ElseIf lineNr < 1
				*cursor\position\charNr = 1
			Else
				*cursor\position\charNr = Clamp(charNr, 1, Textline_Length(*te\textLine()) + 1)
			EndIf
		EndIf
		
		ProcedureReturn Cursor_Update(*te, *cursor, updateLastX)
	EndProcedure
	
	Procedure Cursor_GetScreenPos(*te.TE_STRUCT, *view.TE_VIEW, x, y, *result.TE_POSITION)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*result = #Null))
		
		x / DesktopResolutionX()
		y / DesktopResolutionY()
		
		*result\visibleLineNr = Clamp(*view\scroll\visibleLineNr + Round( (y - *te\topBorderSize) / *te\lineHeight, #PB_Round_Down), 1, *te\visibleLineCount)
		
		If Textline_FromVisibleLineNr(*te, *result\visibleLineNr)
			*result\textline = *te\textLine()
			*result\lineNr = ListIndex(*te\textLine()) + 1
			*result\charNr = Textline_CharNrFromScreenPos(*te, *te\textLine(), x - *te\leftBorderOffset + *view\scroll\charX)
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Cursor_FromScreenPos(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, x, y, addCursor = #False)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*cursor = #Null))
		
		Protected position.TE_POSITION
		
		If Cursor_GetScreenPos(*te, *view, x, y, position)
			If addCursor
				*cursor = Cursor_Add(*te, position\lineNr, position\charNr)
				
				If *cursor = #Null
					ProcedureReturn #Null
				EndIf
			Else
				Cursor_Position(*te, *cursor, position\lineNr, position\charNr)
			EndIf
		EndIf
		
		ProcedureReturn *cursor
	EndProcedure
	
	Procedure Cursor_HasSelection(*cursor.TE_CURSOR)
		ProcedureReturnIf((*cursor = #Null) Or (*cursor\selection\lineNr <= 0) Or (*cursor\selection\charNr <= 0))
		ProcedureReturnIf((*cursor\position\lineNr <> *cursor\selection\lineNr) Or (*cursor\position\charNr <> *cursor\selection\charNr), #True)
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Cursor_SelectionStart(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected selection.TE_RANGE
		
		PushListPosition(*te\cursor())
		If Selection_Get(*cursor, selection)
			Cursor_Position(*te, *cursor, selection\pos1\lineNr, selection\pos1\charNr)
			Selection_SetRange(*te, *cursor, selection\pos2\lineNr, selection\pos2\charNr)
		EndIf
		PopListPosition(*te\cursor())
	EndProcedure
	
	Procedure Cursor_SelectionEnd(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected selection.TE_RANGE
		
		PushListPosition(*te\cursor())
		If Selection_Get(*cursor, selection)
			Cursor_Position(*te, *cursor, selection\pos2\lineNr, selection\pos2\charNr)
			Selection_SetRange(*te, *cursor, selection\pos1\lineNr, selection\pos1\charNr)
			*te\redrawMode | #TE_Redraw_All
		EndIf
		PopListPosition(*te\cursor())
	EndProcedure
	
	Procedure Cursor_NextWord(*te.TE_STRUCT, *cursor.TE_CURSOR, direction)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*cursor\position\textline = #Null))
		
		Protected result = 0
		
		If Parser_TokenAtCharNr(*te, *cursor\position\textline, *cursor\position\charNr)
			If Parser_NextToken(*te, direction, #TE_Flag_NoWhiteSpace | #TE_Flag_NoBlankLines | #TE_Flag_Multiline)
				result = Cursor_Position(*te, *cursor, Textline_LineNr(*te, *te\parser\textline), *te\parser\token\charNr)
			EndIf
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Cursor_InsideComment(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null))
		
		Protected *textline.TE_TEXTLINE = *cursor\position\textline
		Protected i
		
		If Parser_TokenAtCharNr(*te, *textline, *cursor\position\charNr)
			For i = *te\parser\tokenIndex To 1 Step - 1
				If *textline\token(i)\type = #TE_Token_Comment
					ProcedureReturn #True
				EndIf
			Next
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Cursor_GotoLineNr(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf((*te = #Null) Or (*cursor = #Null))
		
		Protected gotoLineNr.s = InputRequester(*te\laguage\gotoTitle, *te\laguage\gotoMessage, "")
		
		If gotoLineNr
			Cursor_Position(*te, *cursor, Val(gotoLineNr), 1)
			Folding_UnfoldTextline(*te, *cursor\position\lineNr)
			Selection_ClearAll(*te)
			Scroll_Line(*te, *te\currentView, *cursor, *cursor\position\visibleLineNr - 4)
; 			*te\needScrollUpdate = #True
		EndIf
	EndProcedure
	
	Procedure Cursor_SignalChanges(*te.TE_STRUCT, *cursor.TE_CURSOR)
		ProcedureReturnIf((*te = #Null) Or (*cursor = #Null))
		
		Protected posChanged = Position_Changed(*cursor\position, *cursor\lastPosition)
		Protected selChanged = Position_Changed(*cursor\selection, *cursor\lastSelection)
		
		If selChanged Or posChanged
			If posChanged
				PostEvent(#TE_Event_Cursor, *te\window, *te\currentView\canvas, #TE_EventType_Change)
			EndIf
			If (posChanged Or selChanged) And Cursor_HasSelection(*cursor)
				PostEvent(#TE_Event_Selection, *te\window, *te\currentView\canvas, #TE_EventType_Change)
; 			ElseIf (posChanged Or selChanged) And (Cursor_HasSelection(*cursor) = 0 Or Position_Equal(*cursor\position, *cursor\selection))
			ElseIf (*cursor\lastSelection\lineNr > 0 And *cursor\lastSelection\charNr > 0) And (Cursor_HasSelection(*cursor) = 0 Or Position_Equal(*cursor\position, *cursor\selection))
				PostEvent(#TE_Event_Selection, *te\window, *te\currentView\canvas, #TE_EventType_Remove)
			EndIf
		EndIf
	EndProcedure
	
	;-
	;- ----------- DRAG & DROP -----------
	;-
	
	Procedure DragDrop_Start(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected dragTextPreviewSize = 32
		
		*te\cursorState\clickCount = 0
		*te\cursorState\state = #TE_CursorState_DragMove
		*te\cursorState\dragText = Selection_Text(*te)
		*te\cursorState\dragStart = 0
		
		Protected i
		Protected lineCount = Min(5, CountString(*te\cursorState\dragText, *te\newLineText) + 1)
		
		For i = 1 To lineCount
			If i = 5
				*te\cursorState\dragTextPreview + "..."
			Else
				Protected textLine.s = StringField(*te\cursorState\dragText, i, *te\newLineText)
				textLine = ReplaceString(textLine, #TAB$, " ")
				If Len(textLine) < dragTextPreviewSize
					*te\cursorState\dragTextPreview + Left(textLine, dragTextPreviewSize) + #CRLF$
				Else
					*te\cursorState\dragTextPreview + Left(textLine, dragTextPreviewSize) + "..." + #CRLF$
				EndIf
			EndIf
		Next
		
		If *te\cursorState\dragText = ""
			*te\cursorState\state = 0
		EndIf
		
		ProcedureReturn *te\cursorState\state
	EndProcedure
	
	Procedure DragDrop_Stop(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		*te\cursorState\dragText = ""
		*te\cursorState\dragTextPreview = ""
		*te\cursorState\state = 0
		*te\cursorState\dragStart = 0
		
		*te\redrawMode | #TE_Redraw_All
	EndProcedure
	
	Procedure DragDrop_Cancel(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (*te\cursorState\state = 0) Or (*te\currentCursor = #Null))
		
		DragDrop_Stop(*te)
		
		*te\cursorState\state = #TE_CursorState_Idle
	EndProcedure
	
	Procedure DragDrop_Drop(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentCursor = 0) Or (*te\cursorState\state = 0))
		
		Protected *newCursor.TE_CURSOR
		Protected *cursor.TE_CURSOR = *te\currentCursor
		Protected checkBorder = Bool(*te\cursorState\state & #TE_CursorState_DragCopy)
		Protected abort = #False
		Protected enableMultiCursor = *te\enableMultiCursor
		
		If Position_InsideSelection(*te, *te\currentView, *te\cursorState\mouseX, *te\cursorState\mouseY, checkBorder)
			abort = #True
		ElseIf *te\cursorState\dragText = ""
			abort = #True
		Else
			Undo_Start(*te\undo)
			
			*te\enableMultiCursor = #True
			*newCursor = Cursor_Add(*te, *te\cursorState\dragPosition\lineNr, *te\cursorState\dragPosition\charNr)
			*te\enableMultiCursor = enableMultiCursor
			
			If *newCursor
				*newCursor\number = -1
			Else
				Debug "Error in DragDrop_Drop: *newCursor = #Null"
				*newCursor = *cursor
			EndIf
			
			If *te\cursorState\state = #TE_CursorState_DragMove
				If LastElement(*te\cursor())
					Repeat
						If *te\cursor() <> *newCursor
							Selection_Delete(*te, *te\cursor(), *te\undo)
						EndIf
					Until PreviousElement(*te\cursor()) = #Null
				EndIf
			EndIf
			
			Selection_Start(*newCursor, *newCursor\position\lineNr, *newCursor\position\charNr)
			Textline_AddText(*te, *newCursor, @*te\cursorState\dragText, Len(*te\cursorState\dragText), #TE_Styling_All, *te\undo)
			
			Cursor_Clear(*te, *newCursor)
			
			Undo_Update(*te)
		EndIf
		
		DragDrop_Stop(*te)
		
		Draw(*te, *te\view)
	EndProcedure
	
	;-
	;- ----------- CLIPBOARD -----------
	;-
	
	Procedure ClipBoard_Cut(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected text.s
		
		ForEach *te\cursor()
			text + Text_Get(*te, *te\cursor()\position\lineNr, *te\cursor()\position\charNr, *te\cursor()\selection\lineNr, *te\cursor()\selection\charNr)
		Next
		
		If text <> ""
			SetClipboardText(text)
			
			ForEach *te\cursor()
				Selection_Delete(*te, *te\cursor(), *te\undo)
			Next
		EndIf
	EndProcedure
	
	Procedure ClipBoard_Copy(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected text.s
		
		ForEach *te\cursor()
			text + Text_Get(*te, *te\cursor()\position\lineNr, *te\cursor()\position\charNr, *te\cursor()\selection\lineNr, *te\cursor()\selection\charNr)
		Next
		
		If text <> ""
			SetClipboardText(text)
		EndIf
	EndProcedure
	
	Procedure ClipBoard_Paste(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected warning.s
		Protected text.s = GetClipboardText()
		
		If text = ""
			ProcedureReturn
		EndIf
		
		If ListSize(*te\cursor()) > 1
			If (ListSize(*te\cursor()) * Len(text)) > 1000000
				warning = *te\laguage\warningLongText
				warning = ReplaceString(warning, "%N1", Str(Len(text)))
				warning = ReplaceString(warning, "%N2", Str(ListSize(*te\cursor())))
				
				If MessageRequester(*te\laguage\warningTitle, warning, #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) <> #PB_MessageRequester_Yes
					ProcedureReturn #False
				EndIf
			EndIf
		EndIf
		
		ForEach *te\cursor()
			Folding_UnfoldTextline(*te, *te\cursor()\position\lineNr)
		Next
		Folding_Update(*te, -1, -1)
		
		ForEach *te\cursor()
			Selection_Delete(*te, *te\cursor(), *te\undo)
			
			If *te\enableSelectPastedText
				Selection_Start(*te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr)
			EndIf
			
			Textline_AddText(*te, *te\cursor(), @text, Len(text), #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation | #TE_Styling_UnfoldIfNeeded, *te\undo)
		Next
		
		If *te\enableSelectPastedText = #False
			Selection_ClearAll(*te)
		EndIf
		
		Draw(*te, *te\view, -1, #TE_Redraw_All)
		
		*te\needScrollUpdate = #True
	EndProcedure
	
	;-
	;- ----------- SCROLL -----------
	;-
	
	Procedure Scroll_Line(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, visibleLineNr, keepCursor = #True, updateGadget = #True)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*cursor = #Null) Or ((*view\scrollBarV\gadget) = 0))
		
		Protected selection.TE_RANGE
		Protected oldScrollLineNr = *view\scroll\visibleLineNr
		Protected oldLindeNr = *cursor\position\lineNr
		Protected lineNr
		
		visibleLineNr = Clamp(visibleLineNr, 1, *te\visibleLineCount)
		*view\scroll\visibleLineNr = Min(visibleLineNr, Max(1, *te\visibleLineCount - *view\pageHeight))
		
		If updateGadget And (*view\scrollBarV\gadget)
			widget::SetState(*view\scrollBarV\gadget, Clamp( ( (*view\scroll\visibleLineNr - 1) * #TE_MaxScrollbarHeight) / Max(1, *te\visibleLineCount - 1), 0, #TE_MaxScrollbarHeight))
		EndIf
		
		If keepCursor = #False
			If Textline_FromVisibleLineNr(*te, Clamp(*cursor\position\visibleLineNr, *view\scroll\visibleLineNr, *view\scroll\visibleLineNr + *view\pageHeight))
				lineNr =  ListIndex(*te\textLine()) + 1
				Cursor_Set(*cursor, *te\textLine(), lineNr, LineNr_to_VisibleLineNr(*te, lineNr), Textline_CharNrFromScreenPos(*te, *te\textLine(), *cursor\position\currentX))
				
				If lineNr <> oldLindeNr
					Selection_Clear(*te, *cursor)
				EndIf
				
				Cursor_Update(*te, *cursor, #False)
			EndIf
		EndIf
		
		*view\firstVisibleLineNr = *view\scroll\visibleLineNr
		*view\lastVisibleLineNr = Min(*view\scroll\visibleLineNr + *view\pageHeight, *te\visibleLineCount)
		
		*te\redrawMode | #TE_Redraw_All
		
		If *view\scroll\visibleLineNr <> oldScrollLineNr
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Scroll_Char(*te.TE_STRUCT, *view.TE_VIEW, charX)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or ((*view\scrollBarH\gadget) = 0))
		
		If *te\maxLineWidth
			*view\scroll\charX = Min(charX, Max(0, (*te\maxTextWidth % *te\maxLineWidth) - *view\pageWidth))
		Else
			*view\scroll\charX = Min(charX, Max(0, *te\maxTextWidth - *view\pageWidth))
		EndIf
		
		*view\scroll\charX = Clamp(*view\scroll\charX, 0, Int(widget::GetAttribute(*view\scrollBarH\gadget, constants::#__Bar_Maximum) * *view\scrollBarH\scale))
		
		widget::SetState(*view\scrollBarH\gadget, *view\scroll\charX / *view\scrollBarH\scale)
		
		*te\redrawMode | #TE_Redraw_All
	EndProcedure
	
	Procedure Scroll_HideScrollBarH(*te.TE_STRUCT, *view.TE_VIEW, isHidden)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or ((*view\scrollBarH\gadget) = 0))
		
		Protected result = 0
		Protected x = *view\x
		Protected y = *view\y
		Protected width = *view\width
		Protected height = *view\height
		
		If *view\scrollBarV\isHidden = #False
			width - *te\scrollbarWidth
		EndIf
		
		If ( (*view\scrollBarH\enabled = #TE_ScrollbarAlwaysOn) Or (isHidden = #False)) And (*view\scrollBarH\isHidden = #True)
			; show horizontal scrollbar
			
			*view\scrollBarH\isHidden = #False
			ResizeGadget(*view\canvas, x, y, width, height - *te\scrollbarWidth)
			widget::Resize(*view\scrollBarV\gadget, x + width, y, *te\scrollbarWidth, height)
			widget::Resize(*view\scrollBarH\gadget, x, y + height - *te\scrollbarWidth, width, *te\scrollbarWidth)
			
			widget::Hide(*view\scrollBarH\gadget, #False)
			
			result = 1
		ElseIf (isHidden = #True) And (*view\scrollBarH\isHidden = #False)
			; hide horizontal scrollbar
			
			*view\scrollBarH\isHidden = #True
			ResizeGadget(*view\canvas, x, y, width, height)
			widget::Resize(*view\scrollBarV\gadget, x + width, y, *te\scrollbarWidth, height)
			
			widget::Hide(*view\scrollBarH\gadget, #True)
			
			result = 1
		Else;If *view\scrollBarV\isHidden = #False
			widget::Resize(*view\scrollBarV\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(*view\canvas))
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Scroll_HideScrollBarV(*te.TE_STRUCT, *view.TE_VIEW, isHidden)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or ((*view\scrollBarV\gadget) = 0))
		
		Protected x = *view\x
		Protected y = *view\y
		Protected width = *view\width
		Protected height = *view\height
		
		If *view\scrollBarH\isHidden = #False
			height - *te\scrollbarWidth
		EndIf
		
		If ( (*view\scrollBarV\enabled = #TE_ScrollbarAlwaysOn) Or (isHidden = #False)) And (*view\scrollBarV\isHidden = #True)
			; show verical scrollbar
			*view\scrollBarV\isHidden = #False
			ResizeGadget(*view\canvas, x, y, width - *te\scrollbarWidth, height)
			widget::Resize(*view\scrollBarV\gadget, x + width - *te\scrollbarWidth, y, *te\scrollbarWidth, height)
			widget::Resize(*view\scrollBarH\gadget, x, y + height, width - *te\scrollbarWidth, *te\scrollbarWidth)
			
			widget::Hide(*view\scrollBarV\gadget, #False)
		ElseIf (isHidden = #True) And (*view\scrollBarV\isHidden = #False)
			; hide verical scrollbar
			*view\scrollBarV\isHidden = #True
			ResizeGadget(*view\canvas, x, y, width, height)
			widget::Resize(*view\scrollBarH\gadget, x, y + height, width, *te\scrollbarWidth)
			widget::Hide(*view\scrollBarV\gadget, #True)
		Else;If *view\scrollBarV\isHidden = #False
			widget::Resize(*view\scrollBarV\gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GadgetHeight(*view\canvas))
		EndIf
	EndProcedure
	
	Procedure Scroll_Update(*te.TE_STRUCT, *view.TE_VIEW, *cursor.TE_CURSOR, previousVisibleLineNr, previousCharNr, updateNeeded = #True)
		ProcedureReturnIf((*te = #Null) Or (*view = #Null) Or (*cursor = #Null))
		ProcedureReturnIf(updateNeeded = #False)
		
		*te\needScrollUpdate = #False
		
		Protected oldScrollLineNr = *view\scroll\visibleLineNr
		Protected pos, result = #False
		
		Protected viewWidth = (*view\width - *te\font(0)\width(' ')) * *view\zoom - *te\leftBorderOffset
		Protected viewHeight = (*view\height - *te\topBorderSize) * *view\zoom
		Protected width, height
		Protected scrollbarChanged
		Protected counter
		Protected maxTextWidth
		
		If *te\maxLineWidth
			maxTextWidth = Min(*te\maxTextWidth, *te\maxLineWidth)
		Else
			maxTextWidth = *te\maxTextWidth
		EndIf
		
		Repeat
			scrollbarChanged = 0
			
			If *view\scrollBarV\isHidden
				width = viewWidth
			Else
				width = viewWidth - *te\scrollbarWidth
			EndIf
			
			If *view\scrollBarH\isHidden
				height = viewHeight
			Else
				height = viewHeight - *te\scrollbarWidth
			EndIf
			
			*view\pageHeight = Max(1, Int(height / *te\lineHeight) - 1)
			
			If *view\scrollBarV\enabled
				If (*view\scrollBarV\enabled = #TE_ScrollbarAlwaysOn) Or (*te\visibleLineCount > *view\pageHeight + 1)
					scrollbarChanged + Scroll_HideScrollBarV(*te, *view, #False)
				Else
					scrollbarChanged + Scroll_HideScrollBarV(*te, *view, #True)
				EndIf
			EndIf
			
			*view\pageWidth = width - 1
			If *view\scrollBarH\enabled
				If (*view\scrollBarH\enabled = #TE_ScrollbarAlwaysOn) Or (maxTextWidth > *view\pageWidth)
					scrollbarChanged + Scroll_HideScrollBarH(*te, *view, #False)
				Else
					scrollbarChanged + Scroll_HideScrollBarH(*te, *view, #True)
				EndIf
			EndIf
			
			counter + 1
		Until (scrollbarChanged = 0) Or (counter > 1)
		
		If (*view\scrollBarV\gadget)
			widget::SetAttribute(*view\scrollBarV\gadget, constants::#__Bar_PageLength, Min(#TE_MaxScrollbarHeight, (*view\pageHeight * #TE_MaxScrollbarHeight) / Max(1, *te\visibleLineCount - 1)))
		EndIf
		If previousVisibleLineNr <> *cursor\position\visibleLineNr
			*view\scroll\visibleLineNr = Min(*view\scroll\visibleLineNr, Max(1, *te\visibleLineCount - *view\pageHeight))
			
			pos = *cursor\position\visibleLineNr - *view\scroll\visibleLineNr
			If pos < 0
				Scroll_Line(*te, *view, *cursor, *view\scroll\visibleLineNr + pos)
			ElseIf pos > *view\pageHeight
				Scroll_Line(*te, *view, *cursor, *view\scroll\visibleLineNr + pos - *view\pageHeight)
			EndIf
			
			result = #True
		EndIf
		
		If (*view\scrollBarH\gadget)
			widget::SetAttribute(*view\scrollBarH\gadget, constants::#__Bar_PageLength, *view\pageWidth / *view\scrollBarH\scale)
			widget::SetAttribute(*view\scrollBarH\gadget, constants::#__Bar_Maximum, Max(maxTextWidth, *view\pageWidth) / *view\scrollBarH\scale)
			
			If previousCharNr <> *cursor\position\charNr
				*view\scroll\charX = Min(*view\scroll\charX, Max(0, maxTextWidth - *view\pageWidth))
				*view\scroll\charX = Clamp(*view\scroll\charX, 0, Int(widget::GetAttribute(*view\scrollBarH\gadget, constants::#__Bar_Maximum) * *view\scrollBarH\scale))
				
				Protected charX = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr)
				
				pos = charX - *view\scroll\charX
				
				If pos < *te\font(0)\width(' ') * 4
					Scroll_Char(*te, *view, *view\scroll\charX + pos - *te\font(0)\width(' ') * 4)
				ElseIf pos > *view\pageWidth - *te\font(0)\width(' ')
					Scroll_Char(*te, *view, *view\scroll\charX + pos - (*view\pageWidth - *te\font(0)\width(' ')))
					
				EndIf
				
				result = #True
			EndIf
		EndIf
		
		*view\firstVisibleLineNr = *view\scroll\visibleLineNr
		*view\lastVisibleLineNr = Min(*view\scroll\visibleLineNr + *view\pageHeight, *te\visibleLineCount)
		
		If oldScrollLineNr <> *view\scroll\visibleLineNr
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Scroll_UpdateAllViews(*te.TE_STRUCT, *view.TE_VIEW, *currentView.TE_VIEW, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (*view = #Null))
		
		If *view = *currentView
			Scroll_Update(*te, *view, *cursor, -1, -1)
		Else
			Scroll_Update(*te, *view, *cursor, *cursor\position\visibleLineNr, -*cursor\position\charNr)
		EndIf
		
		Scroll_UpdateAllViews(*te, *view\child[0], *currentView, *cursor)
		Scroll_UpdateAllViews(*te, *view\child[1], *currentView, *cursor)
	EndProcedure
	
	
	;-
	;- ----------- FIND / REPLACE -----------
	;-
	
	Procedure Find_AddRecent(*te.TE_STRUCT, text.s, gadget, maxRecent = 10)
		ProcedureReturnIf( (*te = #Null) Or (text = "") Or (IsGadget(gadget) = 0))
		
		Protected i
		
		For i = 0 To CountGadgetItems(gadget) - 1
			If GetGadgetItemText(gadget, i) = text
				SetGadgetState(gadget, i)
				
				ProcedureReturn #False
			EndIf
		Next
		
		AddGadgetItem(gadget, 0, text)
		SetGadgetState(gadget, 0)
		
		If CountGadgetItems(gadget) > maxRecent
			RemoveGadgetItem(gadget, maxRecent)
		EndIf
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Find_Next(*te.TE_STRUCT, startLineNr, startCharNr, endLineNr, endCharNr, flags)
		ProcedureReturnIf( (*te = #Null) Or (*te\find\text = ""), -1)
		
		Protected find.s = *te\find\text
		Protected text.s, replace.s
		Protected *textLine.TE_TEXTLINE
		Protected *token.TE_TOKEN
		Protected charNr
		Protected textLength
		Protected findLength, typeStart, typeEnd
		Protected result = #False, error
		Protected matchFound
		Protected matchLength
		
		PushListPosition(*te\textLine())
		
		*textLine = Textline_FromLine(*te, startLineNr)
		findLength = Len(find)
		typeStart = TokenType(*te\parser, Asc(Left(find, 1)))
		typeEnd = TokenType(*te\parser, Asc(Right(find, 1)))
		
		If (*te\find\flags & #TE_Find_CaseSensitive) = 0
			find = LCase(find)
		EndIf
		
		While (*textLine <> #Null) And (result = #False) And (startLineNr <= endLineNr)
			text = *textLine\text
			replace = *textLine\text
			matchFound = #False
			
			If startLineNr = endLineNr
				textLength = endCharNr - findLength + 1
			Else
				textLength = Len(text) - findLength + 1
			EndIf
			
			If *te\find\flags & #TE_Find_RegEx
				
				If IsRegularExpression(#TE_Find_RegEx)
					If ExamineRegularExpression(#TE_Find_RegEx, Mid(text, startCharNr))
						If NextRegularExpressionMatch(#TE_Find_RegEx)
							matchFound = #True
							matchLength = RegularExpressionMatchLength(#TE_Find_RegEx)
							charNr = startCharNr + RegularExpressionMatchPosition(#TE_Find_RegEx) - 1
						EndIf
					EndIf
				EndIf
				
			Else
				
				If (*te\find\flags & #TE_Find_CaseSensitive) = 0
					text = LCase(text)
				EndIf
				
				For charNr = startCharNr To textLength
					error = #False
					
					If (*te\find\flags & #TE_Find_NoComments) Or (*te\find\flags & #TE_Find_NoStrings)
						If Parser_TokenAtCharNr(*te, *textLine, charNr)
							If (*te\find\flags & #TE_Find_NoComments) And (*te\parser\token\type = #TE_Token_Comment)
								error = #True
							EndIf
							If (*te\find\flags & #TE_Find_NoStrings) And (*te\parser\token\type = #TE_Token_String)
								error = #True
							EndIf
						EndIf
					EndIf
					
					If (error = #False) And (Mid(text, charNr, findLength) = find)
						If *te\find\flags & #TE_Find_WholeWords
							If (charNr > 1) And (typeStart = TokenType(*te\parser, Asc(Mid(text, charNr - 1, 1))))
								error = #True
							EndIf
							If (charNr < textLength) And (typeEnd = TokenType(*te\parser, Asc(Mid(text, charNr + findLength, 1))))
								error = #True
							EndIf
						EndIf
						
						If error = #False
							matchFound = #True
							matchLength = findLength
							
							Break
						EndIf
					EndIf
				Next
			EndIf
			
			If matchFound
				If (startLineNr = endLineNr) And ( (charNr + matchLength - 1) > endCharNr)
				Else
					Folding_UnfoldTextline(*te, ListIndex(*te\textLine()) + 1)
					Cursor_Position(*te, *te\currentCursor, startLineNr, charNr + matchLength)
					Selection_SetRange(*te, *te\currentCursor, startLineNr, charNr, #False)
					
					*te\find\startPos\lineNr = startLineNr
					*te\find\startPos\charNr = charNr + matchLength
					
					If (flags & #TE_Find_ReplaceAll) Or (flags & #TE_Find_Replace)
						If find <> *te\find\replace
							Selection_Delete(*te, *te\currentCursor, *te\undo)
							Textline_AddText(*te, *te\currentCursor, @*te\find\replace, Len(*te\find\replace), #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *te\undo)
							
							If startLineNr = endLineNr
								*te\find\endPos\charNr + (Len(*te\find\replace) - matchLength)
							EndIf
						EndIf
						*te\find\replaceCount + 1
					EndIf
					
					result = startLineNr
				EndIf
			EndIf
			
			startCharNr = 1
			
			If flags & #TE_Find_Previous
				startLineNr - 1
				*textLine = PreviousElement(*te\textLine())
			Else
				startLineNr + 1
				*textLine = NextElement(*te\textLine())
			EndIf
		Wend
		
		PopListPosition(*te\textLine())
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Find_Start(*te.TE_STRUCT, *cursor.TE_CURSOR, startLineNr, startCharNr, find.s, replace.s, flags)
		ProcedureReturnIf( (*te = #Null) Or (*cursor = #Null) Or (find = ""))
		
		Protected selection.TE_RANGE
		Protected result
		
		Cursor_Clear(*te, *cursor)
		Selection_Get(*cursor, selection)
		
		If (flags & #TE_Find_InsideSelection) And Selection_IsAnythingSelected(*te)
			startLineNr = selection\pos1\lineNr
			startCharNr = selection\pos1\charNr
			*te\find\endPos\lineNr = selection\pos2\lineNr
			*te\find\endPos\charNr = selection\pos2\charNr - 1
		EndIf
		
		If flags & #TE_Find_ReplaceAll
			
			If (flags & #TE_Find_InsideSelection) = 0
				startLineNr = 1
				startCharNr = 1
				*te\find\endPos\lineNr = ListSize(*te\textLine())
				*te\find\endPos\charNr = Textline_Length(LastElement(*te\textLine()))
			EndIf
			
		ElseIf flags & #TE_Find_StartAtCursor
			
			If Selection_IsAnythingSelected(*te)
				startLineNr = selection\pos1\lineNr
				startCharNr = selection\pos1\charNr
			Else
				startLineNr = *cursor\position\lineNr
				startCharNr = *cursor\position\charNr
			EndIf
			
			If (startLineNr = *te\find\startPos\lineNr) And (startCharNr = *te\find\startPos\charNr)
				If Selection_IsAnythingSelected(*te)
					startLineNr = selection\pos2\lineNr
					startCharNr = selection\pos2\charNr
				Else
					startCharNr + 1
				EndIf
			EndIf
			
			*te\find\endPos\lineNr = ListSize(*te\textLine())
			*te\find\endPos\charNr = Textline_Length(LastElement(*te\textLine()))
		EndIf
		
		*te\find\text = find
		*te\find\replace = replace
		*te\find\replaceCount = 0
		*te\find\flags = Find_Flags(*te)
		
		If *te\find\flags & #TE_Find_RegEx
			If CreateRegularExpression(#TE_Find_RegEx, GetGadgetText(*te\find\cmb_search)) = 0
				MessageRequester(*te\laguage\errorTitle, *te\laguage\errorRegEx + ":" + #CRLF$ + RegularExpressionError(), #PB_MessageRequester_Error)
				ProcedureReturn 0
			EndIf
		EndIf
		
		result = Find_Next(*te, startLineNr, startCharNr, *te\find\endPos\lineNr, *te\find\endPos\charNr, flags)
		
		If result
			Find_AddRecent(*te, find, *te\find\cmb_search)
			
			If (flags & #TE_Find_Replace) Or (flags & #TE_Find_ReplaceAll)
				Find_AddRecent(*te, replace, *te\find\cmb_replace)
			EndIf
			
			If (flags & #TE_Find_ReplaceAll) = 0
				Scroll_Update(*te, *te\currentView, *cursor, result - 3, *cursor\position\charNr)
				Scroll_Line(*te, *te\currentView, *cursor, LineNr_to_VisibleLineNr(*te, result - 3))
				
				SyntaxHighlight_Update(*te)
				
				If Selection_Get(*cursor, selection)
					Selection_HighlightText(*te, selection\pos1\lineNr, selection\pos1\charNr, selection\pos2\lineNr, selection\pos2\charNr)
				EndIf
				
				Draw(*te, *te\view)
			EndIf
			
		ElseIf (result = #False) And (flags & #TE_Find_ReplaceAll = 0)
			
			If flags & #TE_Find_Previous
				If MessageRequester(*te\laguage\messageTitleFindReplace, *te\laguage\messageNoMoreMatchesEnd, #PB_MessageRequester_Info | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
					*te\find\endPos\lineNr = ListSize(*te\textLine())
					*te\find\endPos\charNr = Textline_Length(LastElement(*te\textLine()))
					
					result = Find_Next(*te, ListSize(*te\textLine()), Textline_Length(LastElement(*te\textLine())), *te\find\endPos\lineNr, *te\find\endPos\charNr, flags)
					If result = #False
						MessageRequester(*te\laguage\messageTitleFindReplace, *te\laguage\messageNoMoreMatches)
					EndIf
				EndIf
			Else
				If MessageRequester(*te\laguage\messageTitleFindReplace, *te\laguage\messageNoMoreMatchesStart, #PB_MessageRequester_Info | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
					*te\find\endPos\lineNr = ListSize(*te\textLine())
					*te\find\endPos\charNr = Textline_Length(LastElement(*te\textLine()))
					
					result = Find_Next(*te, 1, 1, *te\find\endPos\lineNr, *te\find\endPos\charNr, flags)
					If result = #False
						MessageRequester(*te\laguage\messageTitleFindReplace, *te\laguage\messageNoMoreMatches)
					EndIf
				EndIf
			EndIf
		EndIf
		
		If *te\needFoldUpdate
			Folding_Update(*te, -1, -1)
		EndIf
		Draw(*te, *te\currentView)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Find_Show(*te.TE_STRUCT, text.s)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\find\wnd_findReplace) = 0))
		
		Protected *view.TE_VIEW = *te\currentView
		
		If (text <> "") And (IsGadget(*te\find\chk_regEx) And (GetGadgetState(*te\find\chk_regEx) = 0))
			SetGadgetText(*te\find\cmb_search, text)
		EndIf
		
		ResizeWindow(*te\find\wnd_findReplace, 
		GadgetX(*view\canvas, #PB_Gadget_ScreenCoordinate) + (*view\width - WindowWidth(*te\find\wnd_findReplace)) / 2, 
		GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate) + (*view\height - WindowHeight(*te\find\wnd_findReplace)) / 2, 
		#PB_Ignore, #PB_Ignore)
		
		HideWindow(*te\find\wnd_findReplace, 0)
		SetActiveWindow(*te\find\wnd_findReplace)
		SetActiveGadget(*te\find\cmb_search)
		
		*te\find\isVisible = #True
	EndProcedure
	
	Procedure Find_Close(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\find\wnd_findReplace) = 0))
		
		HideWindow(*te\find\wnd_findReplace, #True)
		SetActiveWindow(*te\window)
		SetActiveGadget(*te\currentView\canvas)
		
		*te\find\isVisible = #False
	EndProcedure
	
	Procedure Find_Flags(*te.TE_STRUCT)
		ProcedureReturnIf(*te = #Null)
		
		Protected flags
		
		If IsGadget(*te\find\chk_caseSensitive) And GetGadgetState(*te\find\chk_caseSensitive)
			flags | #TE_Find_CaseSensitive
		EndIf
		If IsGadget(*te\find\chk_wholeWords) And GetGadgetState(*te\find\chk_wholeWords)
			flags | #TE_Find_WholeWords
		EndIf
		If IsGadget(*te\find\chk_noComments) And GetGadgetState(*te\find\chk_noComments)
			flags | #TE_Find_NoComments
		EndIf
		If IsGadget(*te\find\chk_noStrings) And GetGadgetState(*te\find\chk_noStrings)
			flags | #TE_Find_NoStrings
		EndIf
		If IsGadget(*te\find\chk_insideSelection) And GetGadgetState(*te\find\chk_insideSelection)
			flags | #TE_Find_InsideSelection
		EndIf
		If IsGadget(*te\find\chk_regEx) And GetGadgetState(*te\find\chk_regEx)
			flags | #TE_Find_RegEx
		EndIf
		
		ProcedureReturn flags
	EndProcedure
	
	Procedure Find_SetSelectionCheckbox(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or IsGadget(*te\find\chk_insideSelection) = 0)
		
		If Selection_IsAnythingSelected(*te)
			DisableGadget(*te\find\chk_insideSelection, #False)
		Else
			DisableGadget(*te\find\chk_insideSelection, #True)
		EndIf
	EndProcedure
	
	;-
	;- ----------- AUTOCOMPLETE -----------
	;-
	
	Procedure Autocomplete_Hide(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\autocomplete\wnd_autocomplete) = 0))
		
		If *te\autocomplete\isVisible
			*te\autocomplete\isVisible = #False
			HideWindow(*te\autocomplete\wnd_autocomplete, #True)
			SetActiveWindow(*te\window)
			SetActiveGadget(*te\currentView\canvas)
			
			ProcedureReturn #True
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure Autocomplete_Show(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\autocomplete\wnd_autocomplete) = 0) Or (IsGadget(*te\autocomplete\lst_listBox) = 0) Or (*te\autocomplete\enabled = #False))
		
		Protected *view.TE_VIEW = *te\currentView
		Protected *cursor.TE_CURSOR = *te\currentCursor
		Protected lText.s, textLen, xPos, yPos, height, AutocompleteCount
		Protected tokenIndex
		Protected *token.TE_TOKEN
		Protected *prevToken.TE_TOKEN
		Protected style
		
		If Parser_TokenAtCharNr(*te, *cursor\position\textline, *cursor\position\charNr - 1)
			*token = *te\parser\token
			
			If (*token\type = #TE_Token_Text)
				lText = LCase(Left(TokenText(*token), *cursor\position\charNr - *token\charNr))
				textLen = Len(lText)
			Else
				ProcedureReturn #False
			EndIf
		Else
			ProcedureReturn #False
		EndIf
		
		If (textLen >= *te\autocomplete\minCharacterCount)
			NewList keyItem.TE_KEYWORDITEM()
			
			; if current token is a structure don't add keywords!
			*prevToken = Parser_NextToken(*te, -1)
			If *prevToken = #Null Or *prevToken\type <> #TE_Token_Backslash
				ForEach *te\keyWord()
					If *te\autocomplete\mode = #TE_Autocomplete_FindAtBegind
						If Len(*te\keyWord()\name) > textLen
							If Left(LCase(*te\keyWord()\name), textLen) = lText
								If AddElement(keyItem())
									keyItem()\name = *te\keyWord()\name
									keyItem()\length = Len(*te\keyWord()\name)
								EndIf
							EndIf
						EndIf
					ElseIf *te\autocomplete\mode = #TE_Autocomplete_FindAny
						If FindString(LCase(*te\keyWord()\name), lText)
							If AddElement(keyItem())
								keyItem()\name = *te\keyWord()\name
								keyItem()\length = Len(*te\keyWord()\name)
							EndIf
						EndIf
					EndIf
				Next
			EndIf
			
			ForEach *te\autoCompleteList()
				If (Len(*te\autoCompleteList()) > textLen)
					If (Left(LCase(*te\autoCompleteList()), textLen) = lText)
						If AddElement(keyItem())
							keyItem()\name = *te\autoCompleteList()
							keyItem()\length = Len(*te\autoCompleteList())
						EndIf
					EndIf
				EndIf
			Next
			
			SortStructuredList(keyItem(), #PB_Sort_Ascending, OffsetOf(TE_KEYWORDITEM\length), #PB_Long)
			
			ClearGadgetItems(*te\autocomplete\lst_listBox)
			ForEach keyItem()
				AddGadgetItem(*te\autocomplete\lst_listBox, -1, keyItem()\name)
			Next
			
			If ListSize(keyItem()) > 0
				xPos = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr - textLen) - *view\scroll\charX + *te\leftBorderOffset
				xpos = Clamp(xPos, *te\leftBorderOffset, WindowWidth(*te\window) - WindowWidth(*te\autocomplete\wnd_autocomplete))
				xPos / (*view\zoom)
				
				yPos = (*cursor\position\visibleLineNr - *view\scroll\visibleLineNr + 1) * *te\lineHeight + *te\topBorderSize
				yPos / (*view\zoom)
				
				; "hack" to correctly display the autocomplete-list
				CompilerSelect #PB_Compiler_OS
					CompilerCase #PB_OS_Windows
						height = Min(*te\autocomplete\maxRows, ListSize(keyItem())) * *te\autocomplete\font\height + 4
					CompilerCase #PB_OS_MacOS
						height = Min(*te\autocomplete\maxRows, ListSize(keyItem())) * (*te\autocomplete\font\height + 6)
					CompilerCase #PB_OS_Linux
						height = Min(*te\autocomplete\maxRows, ListSize(keyItem())) * (*te\autocomplete\font\height + 6)
				CompilerEndSelect
				
				height = (height + Min(0, WindowHeight(*te\window) - (yPos + height) - MenuHeight())) / DesktopResolutionY()
				
				SetGadgetState(*te\autocomplete\lst_listBox, 0)
				
				ResizeWindow(*te\autocomplete\wnd_autocomplete, xPos + GadgetX(*view\canvas, #PB_Gadget_ScreenCoordinate), yPos + GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate), #PB_Ignore, height)
				ResizeGadget(*te\autocomplete\lst_listBox, 0, 0, #PB_Ignore, WindowHeight(*te\autocomplete\wnd_autocomplete))
				
				If *te\autocomplete\isVisible = #False
					HideWindow(*te\autocomplete\wnd_autocomplete, #False)
				EndIf
				
				*te\autocomplete\isVisible = #True
			Else
				Autocomplete_Hide(*te)
			EndIf
		Else
			Autocomplete_Hide(*te)
		EndIf
		
		SetActiveWindow(*te\window)
		SetActiveGadget(*view\canvas)
	EndProcedure
	
	Procedure Autocomplete_Insert(*te.TE_STRUCT)
		ProcedureReturnIf( (*te = #Null) Or (IsWindow(*te\autocomplete\wnd_autocomplete) = 0) Or (IsGadget(*te\autocomplete\lst_listBox) = 0))
		
		Protected *cursor.TE_CURSOR
		Protected result = #False
		Protected autocomplete.s, textLeft.s, charNr
		Protected tokenIndex
		Protected *token.TE_TOKEN
		
		autocomplete = GetGadgetItemText(*te\autocomplete\lst_listBox, GetGadgetState(*te\autocomplete\lst_listBox))
		If autocomplete
			ForEach *te\cursor()
				*cursor = *te\cursor()
				
				*token = Parser_TokenAtCharNr(*te, *cursor\position\textline, *cursor\position\charNr - 1)
				If *token
					textLeft = Left(TokenText(*token), *cursor\position\charNr - *token\charNr)
					charNr = *cursor\position\charNr
					
					Selection_SetRange(*te, *cursor, *cursor\position\lineNr, *cursor\position\charNr - Len(textLeft), #False)
					Selection_Delete(*te, *cursor, *te\undo)
					Textline_AddText(*te, *cursor, @autocomplete, Len(autocomplete), #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation, *te\undo)
					
					*cursor\position\currentX = Textline_CharNrToScreenPos(*te, *cursor\position\textline, *cursor\position\charNr)
					
					result = #True
				EndIf
			Next
		EndIf
		
		Autocomplete_Hide(*te)
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Autocomplete_UpdateDictonary(*te.TE_STRUCT, startLine = 0, endLine = 0)
		ProcedureReturnIf( (*te = #Null) Or (*te\enableDictionary = #False))
		
		Protected key.s
		Protected regEx = CreateRegularExpression(#PB_Any, "[#*]?\w+[\d+]?[$]?") ; match [*/#]text[number]
		
		If IsRegularExpression(regEx) = 0
			ProcedureReturn 0
		EndIf
		
		If Parser_TokenAtCharNr(*te, *te\currentCursor\position\textline, *te\currentCursor\position\charNr - 1)
			Protected textAtCursor.s = LCase(TokenText(*te\parser\token))
		EndIf
		
		If startLine <= 0
			startLine = 1
		EndIf
		If endLine <= 0
			endLine = ListSize(*te\textLine())
		EndIf
		
		ClearMap(*te\autoCompleteList())
		
		PushListPosition(*te\textLine())
		If Textline_FromLine(*te, startLine)
			Repeat
				Protected text.s = *te\textLine()\text
				
				If ExamineRegularExpression(regEx, text)
					While NextRegularExpressionMatch(regEx)
						If Parser_TokenAtCharNr(*te, *te\textLine(), RegularExpressionMatchPosition(regEx))
							If (*te\parser\token\type = #TE_Token_Text)
								key.s = LCase(RegularExpressionMatchString(regEx))
								If textAtCursor <> key
									If FindMapElement(*te\keyWord(), key) = 0
										If FindMapElement(*te\autoCompleteList(), key) = 0
											*te\autoCompleteList(key) = RegularExpressionMatchString(regEx)
										EndIf
									EndIf
								Else
									textAtCursor = ""
								EndIf
							EndIf
						EndIf
					Wend
				EndIf
			Until (ListIndex(*te\textLine()) > endLine) Or (NextElement(*te\textLine()) = #Null)
		EndIf
		PopListPosition(*te\textLine())
		
		FreeRegularExpression(regEx)
		
		ProcedureReturn 1
	EndProcedure
	
	;-
	;- ----------- MARKER -----------
	;-	
	
	Procedure Marker_Add(*te.TE_STRUCT, *textline.TE_TEXTLINE, markerType)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null))
		
		If *textline\marker & markerType
			*textline\marker & ~markerType
		Else
			*textline\marker | markerType
		EndIf
		*textline\needRedraw = #True
		
		*te\redrawMode | #TE_Redraw_ChangedLined
		
		ProcedureReturn #True
	EndProcedure
	
	Procedure Marker_Jump(*te.TE_STRUCT, markerType)
		ProcedureReturnIf(*te = #Null)
		
		Protected *currentLine.TE_TEXTLINE = *te\currentcursor\position\textline
		Protected lineNr = 0
		
		ChangeCurrentElement(*te\textLine(), *te\currentcursor\position\textline)
		
		While (lineNr = 0) And NextElement(*te\textLine())
			If *te\textLine()\marker & markerType
				lineNr = ListIndex(*te\textLine()) + 1
			EndIf
		Wend
		
		If lineNr = 0
			ForEach *te\textLine()
				If *te\textLine() = *currentLine
					Break
				ElseIf *te\textLine()\marker & markerType
					lineNr = ListIndex(*te\textLine()) + 1
					Break
				EndIf
			Next
		EndIf
		
		If lineNr
			Cursor_Position(*te, *te\currentCursor, LineNr_to_VisibleLineNr(*te, lineNr), 1)
			Scroll_Line(*te, *te\currentView, *te\currentCursor, *te\currentCursor\position\visibleLineNr)
			ProcedureReturn #True
		Else
			ChangeCurrentElement(*te\textLine(), *currentLine)
			ProcedureReturn #False
		EndIf
	EndProcedure
	
	;-
	;- ----------- DRAW -----------
	;-
	
	Procedure Draw_Box(x.d, y.d, width.d, height.d, color, fillColor = #TE_Ignore, lineWidth.d = #TE_VectorDrawWidth)
		If fillColor <> #TE_Ignore
			AddPathBox(x + #TE_VectorDrawAdjust, y + #TE_VectorDrawAdjust, width, height)
			VectorSourceColor(fillColor)
			FillPath()
		EndIf
		If color <> #TE_Ignore
			AddPathBox(x + #TE_VectorDrawAdjust, y + #TE_VectorDrawAdjust, width, height)
			VectorSourceColor(color)
			StrokePath(lineWidth)
		EndIf
		
		ResetPath()
	EndProcedure
	
	Procedure Draw_Circle(x.d, y.d, radius.d, color, fillColor = #TE_Ignore)
		If fillColor <> #TE_Ignore
			VectorSourceColor(fillColor)
			AddPathCircle(x + #TE_VectorDrawAdjust, y + #TE_VectorDrawAdjust, radius)
			FillPath(#PB_Path_Preserve)
		EndIf
		If color <> #TE_Ignore
			VectorSourceColor(color)
			AddPathCircle(x + #TE_VectorDrawAdjust, y + #TE_VectorDrawAdjust, radius)
			StrokePath(#TE_VectorDrawWidth)
		EndIf
		
		ResetPath()
	EndProcedure
	
	Procedure Draw_Line(x1.d, y1.d, width.d, height.d, color, lineWidth.d = #TE_VectorDrawWidth)
		MovePathCursor(x1 + #TE_VectorDrawAdjust, y1 + #TE_VectorDrawAdjust)
		AddPathLine(width, height, #PB_Path_Relative)
		
		VectorSourceColor(color)
		StrokePath(lineWidth, #PB_Path_RoundEnd)
	EndProcedure
	
	Procedure Draw_DotLine(x1.d, y1.d, x2.d, y2.d, width.d, distance.d, color)
		If distance <= 0
			distance = 0.1
		EndIf
		
		MovePathCursor(x1 + #TE_VectorDrawAdjust, y1 + #TE_VectorDrawAdjust)
		AddPathLine(x2, y2, #PB_Path_Relative)
		VectorSourceColor(color)
		
		DotPath(width, distance, #PB_Path_RoundEnd)
	EndProcedure
	
	Procedure Draw_Text(*te.TE_STRUCT, x.d, y.d, text.s, textColor, fillColor = #TE_Ignore)
		Protected width = VectorTextWidth(text)
		
		If fillColor <> #TE_Ignore
			Protected height = VectorTextHeight(text)
			Draw_Box(x, y, width, height, textColor, fillColor)
		EndIf
		
		MovePathCursor(x + #TE_VectorDrawAdjust, y + #TE_VectorDrawAdjust)
		VectorSourceColor(textColor)
		DrawVectorText(text)
		
		ProcedureReturn width
	EndProcedure
	
	Procedure Draw_DragText(*te.TE_STRUCT, x.d, y.d)
		ProcedureReturnIf(*te = #Null)
		
		Protected width = VectorTextWidth(*te\cursorState\dragTextPreview)
		Protected height = VectorTextHeight(*te\cursorState\dragTextPreview)
		x = Clamp(x + 10, *te\leftBorderOffset + 10, *te\currentView\x + *te\currentView\width - (width + 2))
		y = Clamp(y - height - 10, *te\topBorderSize, *te\currentView\y + *te\currentView\height - (height + 2))
		
		; 		Draw_Box(x - 1, y - 1, width + 2, height + 2, RGBA(255, 255, 255, 64), RGBA(64, 64, 64, 64))
		Draw_Box(x - 1, y - 1, width + 2, height + 2, RGBA(255, 255, 255, 64), RGBA(64, 64, 64, 128))
		Draw_Text(*te, x, y, *te\cursorState\dragTextPreview, RGBA(255, 255, 255, 255))
	EndProcedure
	
	Procedure Draw_WhiteSpace(x.d, y.d, width.d, height.d, char, color)
		Protected h2.d, w2.d, w3
		
		Draw_Box(x, y, width - 1, height - 1, color, #TE_Ignore, 0.5)
		If char = ' '
			Draw_Box(x + width / 2 - 1, y + height / 2, 1, 1, color)
		ElseIf char = #TAB
			h2 = Max(1, height * 0.2)
			w2 = Max(1, width - 3)
			w3 = Max(width * 0.5, width - height)
			x = x + 2
			y = y + height / 2
			Draw_Line(x, y, w2, 0, color, 0.5)
			Draw_Line(x + w2, y, -w3, -h2, color, 0.5)
			Draw_Line(x + w2, y, -w3, h2, color, 0.5)
		EndIf
	EndProcedure
	
	Procedure Draw_FoldIcon(*te.TE_STRUCT, x.d, y.d, size.d, size2.d, foldState)
		Protected sizeH = size / 2
		
		Draw_Box(x - sizeH, y - sizeH, sizeH * 2, sizeH * 2, *te\colors\foldIconBorder, *te\colors\lineNrBackground)
		
		Draw_Line(x - sizeH + 2, y, size - 4, 0, *te\colors\foldIcon)
		If foldState = #TE_Folding_Folded
			Draw_Line(x, y - sizeH + 2, 0, size - 4, *te\colors\foldIcon)
		Else
			Draw_Line(x, y + sizeH, 0, size2 - size - 3, *te\colors\foldIconBorder)
		EndIf
	EndProcedure
	
	Procedure Draw_Marker(*te.TE_STRUCT, x.d, y.d, style)
		Protected h = *te\lineHeight - 2
		Protected w = *te\lineHeight / 2
		
		If style & #TE_Marker_Breakpoint
			Draw_Box(x, y, BorderSize(*te) - h + 2, h, RGBA(255, 128, 128, 255), RGBA(128, 0, 0, 255))
		EndIf
		
		If style & #TE_Marker_Bookmark
			MovePathCursor(x + #TE_VectorDrawAdjust - 1, y + #TE_VectorDrawAdjust + 2)
			AddPathLine( w, 0, #PB_Path_Relative)
			AddPathLine( -w / 2, h / 2 - 2, #PB_Path_Relative)
			AddPathLine( w / 2, h / 2 - 2, #PB_Path_Relative)
			AddPathLine( -w, 0, #PB_Path_Relative)
			ClosePath()
			VectorSourceColor(RGBA( 0, 200, 0, 255))
			FillPath(#PB_Path_Preserve)
			VectorSourceColor(RGBA(255, 255, 255, 255))
			StrokePath(1)
		EndIf
	EndProcedure
	
	Procedure Draw_Cursor(*te.TE_STRUCT, x.d, y.d, width.d, height.d, cursorType)
		ProcedureReturnIf(*te = #Null)
		
		If cursorType = #TE_Cursor_Normal
			If *te\cursorState\overwrite
				;Draw_Box(x, y + height - #TE_VectorDrawWidth, width, 1, *te\colors\cursor, *te\colors\cursor)
				Draw_Line(x, y + height - 2, width, 0, *te\colors\cursor, 1.5)
			Else
				; 				Draw_Box(x, y, 1, height, *te\colors\cursor, *te\colors\cursor)
				Draw_Line(x + #TE_VectorDrawWidth, y + 1.75, 0, height - 3.5, *te\colors\cursor, 1.5)
				
			EndIf
		ElseIf cursorType = #TE_Cursor_DragDrop
			Draw_DotLine(x, y, 0, height, 3, 6, *te\colors\cursor)
			
			If *te\cursorState\state = #TE_CursorState_DragCopy
				Protected w.d = height * 0.5
				Protected h.d = w * 0.5
				
				Draw_Box(x + h, y, w, w, *te\colors\cursor, *te\colors\currentBackground)
				Draw_Line(x + h + h, y + 2, 0, w - 4, *te\colors\cursor)
				Draw_Line(x + h + 2, y + h, w - 4, 0, *te\colors\cursor)
			EndIf
		EndIf
	EndProcedure
	
	Procedure Draw_LeftBorder(*te.TE_STRUCT, *textline.TE_TEXTLINE, lineNr, x, y, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*textline = #Null))
		
		Protected foldiconSize = FoldiconSize(*te)
		Protected xFoldLine = *te\leftBorderOffset - (*te\lineHeight * 0.5) + 1
		Protected height = *te\lineHeight
		Protected *font.TE_FONT = @*te\font(0)
		Protected color
		
		If *te\enableLineNumbers
			If *te\enableShowCurrentLine And *cursor And (lineNr = *cursor\position\lineNr)
				color = *te\colors\currentLineNr
			Else
				color = *te\colors\lineNr
			EndIf
			
			Draw_Box(0, y, *te\leftBorderOffset - *te\lineHeight, height, *te\colors\lineNrBackground, *te\colors\lineNrBackground)
			Draw_Box(*te\leftBorderOffset - *te\lineHeight, y, *te\lineHeight - #TE_VectorDrawWidth, height, *te\colors\foldIconBackground, *te\colors\foldIconBackground)
		EndIf
		
		If *te\textLine()\marker
			Draw_Marker(*te, 0, y, *te\textLine()\marker)
		EndIf
		
		If *font\id And *te\enableLineNumbers
			VectorFont(*font\id)
			Draw_Text(*te, x, y, RSet(Str(lineNr), Int(Log10(ListSize(*te\textLine())) + 1)), color)
		EndIf
		
		If *te\enableFolding
			If *textline\foldState > 0
				Draw_FoldIcon(*te, xFoldLine, y + height / 2, foldiconSize, height, *textline\foldState)
				If *textline\foldSum > 0
					Draw_Line(xFoldLine, y - 1, 0, (height - FoldiconSize) / 2 + 1, *te\colors\foldIconBorder)
				EndIf
				If (*textline\foldSum > 0) And ( (*textline\foldSum + *textline\foldCount) > 0)
					Draw_Line(xFoldLine, y + (height + FoldiconSize) / 2, 0, (height - FoldiconSize) / 2 + 1, *te\colors\foldIconBorder)
				EndIf
			ElseIf (*textline\foldState < 0) And (*textline\foldSum > 0)
				If (*textline\foldSum + *textline\foldCount) > 0
					Draw_Line(xFoldLine, y - 1, 0, height + 1, *te\colors\foldIconBorder)
				Else
					Draw_Line(xFoldLine, y - 1, 0, height / 2 + 1, *te\colors\foldIconBorder)
				EndIf
				Draw_Line(xFoldLine, y + height / 2, FoldiconSize * 0.5, 0, *te\colors\foldIconBorder)
			ElseIf *textline\foldSum > 0
				Draw_Line(xFoldLine, y - 1, 0, height + 1, *te\colors\foldIconBorder)
			EndIf
		EndIf
	EndProcedure
	
	
	
	Procedure Draw_Textline(*te.TE_STRUCT, *view.TE_VIEW, *textLine.TE_TEXTLINE, lineNr, x.d, y.d, backgroundColor, *cursor.TE_CURSOR)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*textLine = #Null), y)
		
		Protected *t.Character
		Protected *font.TE_FONT, fontNr
		Protected charNr
		Protected selected
		Protected style, styleFcolor, styleBcolor, fColor, bColor, underline, underlineColor
		Protected width.d, tabWidth.d
		Protected height.d = *te\lineHeight
		Protected maxHeight.d = VectorOutputHeight() * *view\zoom
		Protected maxWidth.d = VectorOutputWidth() * *view\zoom; - *te\font(0)\width(' ')
		Protected xStart.d = x
		Protected findIndentation = #True, indentationPos
		Protected highlightSize
		Protected drawCursor
		Protected selection.TE_RANGE, fullRowSelected = #False
		
		
		*font = @*te\font(0)
		charNr = 1
		styleFColor = *te\textStyle(0)\fColor
		styleBcolor = #TE_Ignore
		fColor = styleFcolor
		bColor = styleBcolor
		
		If *te\useRealTab
			tabWidth = Max(1, *font\width(#TAB) * *te\tabSize)
		Else
			tabWidth = Max(1, *font\width(' ') * *te\tabSize)
		EndIf
		
		If IsFont(*font\nr)
			VectorFont(*font\id)
		EndIf
		
		If *textLine\text
			*t = @*textLine\text
		Else
			*t = @""
		EndIf
		
		If *cursor
			Selection_Get(*cursor, selection)
			If lineNr > selection\pos1\lineNr And lineNr < selection\pos2\lineNr
				fullRowSelected = #True
			EndIf
		EndIf
		
		Repeat
			style = Style_FromCharNr(*textLine, charNr)
			If style
				If *te\textStyle(style)\fColor <> #TE_Ignore
					fColor = *te\textStyle(style)\fColor
				EndIf
				If highlightSize = 0
					If *te\textStyle(style)\bColor <> #TE_Ignore
						styleBcolor = *te\textStyle(style)\bcolor
					Else
						styleBcolor = #TE_Ignore
					EndIf
				EndIf
				If *te\textStyle(style)\fontNr <> #TE_Ignore
					fontNr = Clamp(*te\textStyle(style)\fontNr, 0, ArraySize(*te\font()))
					*font = @*te\font(fontNr)
					If IsFont(*font\nr)
						VectorFont(*font\id)
					EndIf
				Else
					*font = @*te\font(0)
					If IsFont(*font\nr)
						VectorFont(*font\id)
					EndIf
				EndIf
			EndIf
			
			If *te\enableHighlightSelection And *te\highlightSelection And (*te\cursorState\state = 0)
				If highlightSize
					highlightSize - 1
					If highlightSize = 0
						styleBcolor = #TE_Ignore
					EndIf
				EndIf
				If highlightSize = 0
					highlightSize = Len(*te\highlightSelection)
					If CompareMemoryString(*t, @*te\highlightSelection, *te\highlightMode, highlightSize) = #PB_String_Equal
						styleBcolor = *te\textStyle(#TE_Style_Highlight)\bColor
					Else
						highlightSize = 0
					EndIf
				EndIf
			ElseIf *te\highlightSyntax
				If charNr <= ArraySize(*textLine\syntaxHighlight())
					style = *textLine\syntaxHighlight(charNr)
					If style = #TE_Style_None
						underline = 0
						styleBcolor = #TE_Ignore
					ElseIf style
						If *te\textStyle(style)\underlined
							underline = 1
							underlineColor = *te\textStyle(style)\fColor
						EndIf
						styleBcolor = *te\textStyle(style)\bColor
					EndIf
				EndIf
			EndIf
			
			drawCursor = 0
			If (*te\cursorState\state > 0) And (lineNr = *te\cursorState\dragPosition\lineNr) And (charNr = *te\cursorState\dragPosition\charNr)
				drawCursor = #TE_Cursor_DragDrop
			EndIf
			
			selected = fullRowSelected
			Protected testSelection = #True
			While *cursor And testSelection
				testSelection = #False
				
				If (*te\cursorState\state = 0) And (lineNr = *cursor\position\lineNr) And (charNr = *cursor\position\charNr)
					drawCursor = #TE_Cursor_Normal
				EndIf
				
				If selected = #False
					If (lineNr < selection\pos1\lineNr) Or (lineNr > selection\pos2\lineNr)
						; line is above or under selection
					ElseIf (lineNr = selection\pos1\lineNr) And (charNr < selection\pos1\charNr)
						; char is before selection
					ElseIf (lineNr = selection\pos2\lineNr) And (charNr >= selection\pos2\charNr)
						; char is behind selection
						If NextElement(*te\cursor()) And (*te\cursor()\position\lineNr = lineNr Or *te\cursor()\selection\lineNr = lineNr)
							*cursor = *te\cursor()
							Selection_Get(*cursor, selection)
							testSelection = #True
						Else
							PreviousElement(*te\cursor())
							*cursor = #Null
						EndIf
					Else
						selected = #True
					EndIf
				EndIf
			Wend
			
			
			
			If selected
				bColor = *te\colors\selectionBackground
			Else
				bColor = styleBcolor
			EndIf
			
			Select *t\c
				Case #TAB
					width = tabWidth - Mod( (x - xStart) + tabWidth, tabWidth)
					
					Draw_Box(x, y - 0.5, width + 1, height + 1, #TE_Ignore, bColor)
				Default
					width = *font\width(*t\c)
					
					Draw_Box(x, y - 0.5, width + 1, height + 1, #TE_Ignore, bColor)
					
					If selected And (*te\colors\selectedTextColor <> #TE_Ignore)
						Draw_Text(*te, x, y, Chr(*t\c), *te\colors\selectedTextColor)
					Else
						Draw_Text(*te, x, y, Chr(*t\c), fcolor)
					EndIf
			EndSelect
			
			If underline
				Draw_Line(x, y + height - 1, width, 0, underlineColor)
			EndIf
			
			If *te\enableShowWhiteSpace
				If (*t\c = ' ') Or (*t\c = #TAB)
					If selected
						Draw_WhiteSpace(x, y, width, height, *t\c, backgroundColor)
					Else
						Draw_WhiteSpace(x, y, width, height, *t\c, *te\colors\indentationGuides)
					EndIf
				EndIf
			EndIf
			
			If *te\enableIndentationLines And findIndentation
				If *t\c > 32
					findIndentation = #False
				Else
					indentationPos = xStart + (Int( (x - xStart) / tabWidth)) * tabWidth
					Draw_DotLine(indentationPos + #TE_VectorDrawWidth * 3, y + 1, 0, height - 2, 1, height / 4, *te\colors\indentationGuides)
				EndIf
			EndIf
			
			If drawCursor And (*te\cursorState\blinkState Or *te\cursorState\state > 0)
				Draw_Cursor(*te, x, y, width, height, drawCursor)
			EndIf
			
			charNr + 1
			x + width
			
			If *t\c = 0
				Break
			EndIf
			
			If *te\maxLineWidth < 0
				If x >= maxWidth
					x = xStart
					y + height
				EndIf
			ElseIf *te\maxLineWidth > 0
				If x >= *te\maxLineWidth
					x = xStart
					y + height
				EndIf
				maxWidth = x + 1
			EndIf
			
			*t + #TE_CharSize
		Until (x > maxWidth) Or (y > maxHeight)
		
		If *textLine\foldState = #TE_Folding_Folded
			Draw_Circle(x, y + height * 0.5, 0.5, *te\textStyle(#TE_Style_Comment)\fColor, *te\textStyle(#TE_Style_Comment)\fColor)
			x + height * 0.25
			Draw_Circle(x, y + height * 0.5, 0.5, *te\textStyle(#TE_Style_Comment)\fColor, *te\textStyle(#TE_Style_Comment)\fColor)
			x + height * 0.255
			Draw_Circle(x, y + height * 0.5, 0.5, *te\textStyle(#TE_Style_Comment)\fColor, *te\textStyle(#TE_Style_Comment)\fColor)
		EndIf
		
		ProcedureReturn y
	EndProcedure
	
	Procedure Draw_View(*te.TE_STRUCT, *view.TE_VIEW, redrawAll = #True)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		Protected backgroundColor
		Protected lineNr, lastLineNr
		Protected maxHeight, maxWidth
		Protected x, y, newY, dragTextX, dragTextY, cursorY = -1
		Protected selection.TE_RANGE
		Protected *cursor.TE_CURSOR = #Null
		Protected *textBlock.TE_TEXTBLOCK = #Null
		
		If IsGadget(*view\canvas) And StartVectorDrawing(CanvasVectorOutput(*view\canvas))
			If *view = *te\currentView
				backgroundColor = *te\colors\currentBackground
			Else
				backgroundColor = *te\colors\inactiveBackground
			EndIf
			
			If redrawAll
				VectorSourceColor(backgroundColor)
				FillVectorOutput()
			EndIf
			
			If *view\zoom
				ScaleCoordinates(1.0 / *view\zoom, 1.0 / *view\zoom)
			EndIf
			
			ScaleCoordinates(DesktopResolutionX(), DesktopResolutionY())
			
			If (*view\scroll\visibleLineNr >= 1) And (*view\scroll\visibleLineNr <= *te\visibleLineCount)
				maxHeight = VectorOutputHeight() * *view\zoom
				maxWidth = VectorOutputWidth() * *view\zoom
				
				x = *te\leftBorderOffset - *view\scroll\charX
				y = *te\topBorderSize
				
				
				PushListPosition(*te\cursor())
				PushListPosition(*te\textLine())
				
				If Textline_FromVisibleLineNr(*te, *view\scroll\visibleLineNr)
					lastLineNr = LineNr_from_VisibleLineNr(*te, *view\lastVisibleLineNr)
					*textBlock = FirstElement(*te\textBlock())
					
					Selection_Get(FirstElement(*te\cursor()), selection)
					ResetList(*te\cursor())
					
					Repeat
						newY = y
						lineNr = ListIndex(*te\textLine()) + 1
						
						If *cursor And (lineNr > selection\pos2\lineNr)
							*cursor = #Null
						EndIf
						
						While (*cursor = #Null) And (lineNr >= selection\pos1\lineNr) And NextElement(*te\cursor())
							Selection_Get(*te\cursor(), selection)
							If (lineNr <= selection\pos2\lineNr)
								*cursor = *te\cursor()
							EndIf
						Wend
						
						If *te\textLine()\needRedraw Or redrawAll
							
							
							If redrawAll = 0
								Draw_Box(0, y, VectorOutputWidth() * *view\zoom, *te\lineHeight, #TE_Ignore, backgroundColor)
							EndIf
							
							If *te\enableShowCurrentLine
								If *te\currentCursor And (lineNr = *te\currentCursor\position\lineNr) And (*te\cursorState\state <= 0)
									cursorY = y
									If *view = *te\currentView
										Draw_Box(*te\leftBorderOffset - #TE_VectorDrawWidth * 0.5, y, VectorOutputWidth() * *view\zoom, *te\lineHeight, #TE_Ignore, *te\colors\currentLineBackground)
									Else
										Draw_Box(*te\leftBorderOffset - #TE_VectorDrawWidth * 0.5, y, VectorOutputWidth() * *view\zoom, *te\lineHeight, #TE_Ignore, *te\colors\inactiveLineBackground)
									EndIf
								EndIf
							EndIf
							
							Protected lastCursorIndex = ListIndex(*te\cursor())
							newY = Draw_Textline(*te, *view, *te\textLine(), lineNr, x, y, backgroundColor, *cursor)
							
							If (ListIndex(*te\cursor()) > lastCursorIndex)
								*cursor = *te\cursor()
								Selection_Get(*cursor, selection)
							EndIf
							;Draw_Box(500, y, 50, *te\lineHeight, #TE_Ignore, rcol)
						EndIf
						
						If (*te\cursorState\state > 0) And (*te\cursorState\dragPosition\lineNr = lineNr)
							dragTextX = *te\cursorState\mouseX
							dragTextY = y
						EndIf
						
						Draw_LeftBorder(*te, *te\textLine(), lineNr, *te\leftBorderSize, y, *cursor)
						
						While *textBlock And *textBlock\firstLineNr < lineNr
							*textBlock = NextElement(*te\textBlock())
						Wend
						If *textBlock And (lineNr >= *textBlock\firstLineNr) And (*textBlock\firstLine\foldState & #TE_Folding_Folded)
							If *textBlock\lastLine = #Null
								Break
							ElseIf *textBlock\lastLineNr > lineNr
								ChangeCurrentElement(*te\textLine(), *textBlock\lastLine)
								lineNr = ListIndex(*te\textLine()) + 1
							EndIf
						EndIf
						
						y = newY + *te\lineHeight
					Until (y > maxHeight) Or (lineNr > lastLineNr) Or (NextElement(*te\textLine()) = #Null)
					
					If cursorY <> -1
						If *view = *te\currentView
							Draw_Box(*te\leftBorderOffset - #TE_VectorDrawWidth * 0.5, cursorY, VectorOutputWidth() * *view\zoom, *te\lineHeight, *te\colors\currentLine, #TE_Ignore)
						Else
							Draw_Box(*te\leftBorderOffset - #TE_VectorDrawWidth * 0.5, cursorY, VectorOutputWidth() * *view\zoom, *te\lineHeight, *te\colors\currentLine, #TE_Ignore)
						EndIf
					EndIf
					
					If (*te\cursorState\state > 0) And (*view = *te\currentView)
						Draw_DragText(*te, dragTextX, dragTextY)
					EndIf
					
				EndIf
				PopListPosition(*te\textLine())
				PopListPosition(*te\cursor())
			EndIf
			
			StopVectorDrawing()
		EndIf
		
		Draw_View(*te, *view\child[0], redrawAll)
		Draw_View(*te, *view\child[1], redrawAll)
		
; ; 		If StartDrawing( CanvasOutput( *view\canvas ) )
; ; 		  If *view\scrollBarV\gadget
; ; 		    ;Debug widget::WidgetX(*view\scrollBarV\gadget)
; ; 		    widget::Draw( *view\scrollBarV\gadget )
; ; 		  EndIf
; ; 		  If *view\scrollBarH\gadget
; ; 		    widget::Draw( *view\scrollBarH\gadget )
; ; 		  EndIf
; ; 		  StopDrawing( )
; ; 		EndIf
      widget::ReDraw( widget::root() )
	EndProcedure
	
	Procedure Draw(*te.TE_STRUCT, *view.TE_VIEW, cursorBlinkState = -1, redrawMode = 0)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null))
		
		Protected redrawAll = #False
		
		If redrawMode & #TE_Redraw_All
			redrawAll = #True
		ElseIf (redrawMode = 0) And (*te\redrawMode & #TE_Redraw_All)
			redrawAll = #True
		ElseIf *te\cursorState\state > 0
			redrawAll = #True
		EndIf
		
		If cursorBlinkState = -1
			*te\cursorState\blinkState = 1
			*te\cursorState\blinkSuspend = 1
		EndIf
		
		
		Draw_View(*te, *view, redrawAll)
		
		
		ForEach *te\textLine()
			*te\textLine()\needRedraw = #False
		Next
		
		    
        
		*te\redrawMode = 0
	EndProcedure
	
	;-
	;- ----------- READ XML -----------
	;-
	
	Procedure Settings_ReadXml(*te.TE_STRUCT, node)
		Protected subNode, text.s, value.s
		Protected col, colR, colG, colB, colA
		
		subNode = ChildXMLNode(node)
		While subNode
			Select LCase(GetXMLNodeName(node))
					
				Case "settings"
					
					text = Trim(GetXMLAttribute(subNode, "name"))
					value = Trim(GetXMLAttribute(subNode, "value"))
					
					Select LCase(text)
						Case "enablescrollbarhorizontal" : *te\enableScrollBarHorizontal = Val(value)
						Case "enablescrollbarvertical" : *te\enableScrollBarVertical = Val(value)
						Case "enablestyling" : *te\enableStyling = Val(value)
						Case "enablelinenumbers" : *te\enableLineNumbers = Val(value)
						Case "enableshowcurrentline" : *te\enableShowCurrentLine = Val(value)
						Case "enablecasecorrection" : *te\enableCaseCorrection = Val(value)
						Case "enablefolding" : *te\enableFolding = Val(value)
						Case "enableshowwhitespace" : *te\enableShowWhiteSpace = Val(value)
						Case "enableindentationlines" : *te\enableIndentationLines = Val(value)
						Case "enableindentation" : *te\enableIndentation = Val(value)
						Case "enableautocomplete" : *te\enableAutoComplete = Val(value)
						Case "enabledictionary" : *te\enableDictionary = Val(value)
						Case "enablesyntaxcheck" : *te\enableSyntaxCheck = Val(value)
						Case "enablebeautify" : *te\enableBeautify = Val(value)
						Case "enablemulticursor" : *te\enableMultiCursor = Val(value)
						Case "enablesplitscreen" : *te\enableSplitScreen = Val(value)
						Case "enablehighlightselection" : *te\enableHighlightSelection = Val(value)
						Case "enableselectpastedtext" : *te\enableSelectPastedText = Val(value)
						Case "userealtab" : *te\useRealTab = Val(value)
						Case "tabsize" : *te\tabSize = Val(value)
						Case "fontname" : *te\fontName = value
						Case "lineheight" : *te\lineHeight = Val(value)
						Case "maxlinewidth" : *te\maxLineWidth = Val(value)
						Case "scrollbarwidth" : *te\scrollbarWidth = Val(value)
						Case "topbordersize" : *te\topBorderSize = Val(value)
						Case "leftbordersize" : *te\leftBorderSize = Val(value)
						Case "newlinechar" : *te\newLineChar = Val(value)
							*te\newLineText = Chr(*te\newLineChar)
						Case "cursorblinkdelay" : *te\cursorState\blinkDelay = Val(value)
						Case "cursorclickspeed" : *te\cursorState\clickSpeed = Val(value)
						Case "highlightmode"
							Select LCase(value)
								Case "nocase" : *te\highlightMode = #PB_String_NoCase
								Case "casesensitive" : *te\highlightMode = #PB_String_CaseSensitive
							EndSelect
						Case "indentationmode"
							Select LCase(value)
								Case "auto" : *te\indentationMode = #TE_Indentation_Auto
								Case "block" : *te\indentationMode = #TE_Indentation_Block
								Case "none" : *te\indentationMode = #TE_Indentation_None
							EndSelect
						Case "cursorcomparemode"
							Select LCase(value)
								Case "nocase" : *te\cursorState\compareMode = #PB_String_NoCase
								Case "casesensitive" : *te\cursorState\compareMode = #PB_String_CaseSensitive
							EndSelect
					EndSelect
					
				Case "colors"
					
					text = Trim(GetXMLAttribute(subNode, "name"))
					value = Trim(GetXMLAttribute(subNode, "value"))
					If value = ""
						col = #TE_Ignore
					Else
						colR = Val(Trim(StringField(value, 1, ",")))
						colG = Val(Trim(StringField(value, 2, ",")))
						colB = Val(Trim(StringField(value, 3, ",")))
						If Trim(StringField(value, 4, ",")) = ""
							colA = 255
						Else
							colA = Val(Trim(StringField(value, 4, ",")))
						EndIf
						col = RGBA(colR, colG, colB, colA)
					EndIf
					
					Select LCase(text)
						Case "defaulttextcolor" : *te\colors\defaultTextColor = col
						Case "selectedtextcolor" : *te\colors\selectedTextColor = col
						Case "cursor" : *te\colors\cursor = col
						Case "inactivebackground" : *te\colors\inactiveBackground = col
						Case "currentbackground" : *te\colors\currentBackground = col
						Case "selectionbackground" : *te\colors\selectionBackground = col
						Case "currentline" : *te\colors\currentLine = col
						Case "currentlinebackground" : *te\colors\currentLineBackground = col
						Case "inactivelinebackground" : *te\colors\inactiveLineBackground = col
						Case "indentationguides" : *te\colors\indentationGuides = col
						Case "repeatedselections" : *te\colors\repeatedSelections = col
						Case "linenr" : *te\colors\lineNr = col
						Case "currentlinenr" : *te\colors\currentLineNr = col
						Case "linenrbackground" : *te\colors\lineNrBackground = col
						Case "foldicon" : *te\colors\foldIcon = col
						Case "foldiconborder" : *te\colors\foldIconBorder = col
						Case "foldiconbackground" : *te\colors\foldIconBackground = col
					EndSelect
					
			EndSelect
			
			subNode = NextXMLNode(subNode)
		Wend
	EndProcedure
	
	Procedure Settings_OpenXml(*te.TE_STRUCT, fileName.s)
		ProcedureReturnIf( (*te = #Null) Or (fileName = ""))
		
		Protected xml, mainNode, node
		Protected result = #False
		
		If fileName <> ""
			xml = LoadXML(#PB_Any, fileName)
			
			If IsXML(xml)
				mainNode = MainXMLNode(xml)
				If mainNode
					node = ChildXMLNode(mainNode)
					While node
						Settings_ReadXml(*te, node)
						node = NextXMLNode(node)
					Wend
					result = #True
				EndIf
			EndIf
		EndIf
		
		If result = #False
			MessageRequester(*te\laguage\errorTitle, ReplaceString(*te\laguage\errorNotFound, "%N1", fileName), #PB_MessageRequester_Error)
		Else
			*te\leftBorderOffset = BorderSize(*te)
			
			Style_SetFont(*te, *te\fontName, *te\lineHeight)
			Style_SetDefaultStyle(*te)
			
			With *te\autocomplete
				If IsGadget(\lst_listBox) And \font\id And IsFont(\font\nr)
					SetGadgetFont(\lst_listBox, *te\autocomplete\font\id)
				EndIf
			EndWith
			
			Draw(*te, *te\view, -1, #TE_Redraw_All)
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	Procedure Styling_ReadXml(*te.TE_STRUCT, node)
		ProcedureReturnIf( (*te = #Null) Or (node = #Null))
		
		Protected subNode, text.s, key.s, style, caseCorrection, flags.s, flag, i
		Protected folding, indentBefore, indentAfter
		
		subNode = ChildXMLNode(node)
		While subNode
			Select LCase(GetXMLNodeName(node))
					
				Case "styling"
					
					text = GetXMLAttribute(subNode, "name")
					If text
						style = 0
						Select LCase(text)
							Case "none" : style = #TE_Style_None
							Case "keyword" : style = #TE_Style_Keyword
							Case "function" : style = #TE_Style_Function
							Case "structure" : style = #TE_Style_Structure
							Case "text" : style = #TE_Style_Text
							Case "string" : style = #TE_Style_String
							Case "quote" : style = #TE_Style_Quote
							Case "comment" : style = #TE_Style_Comment
							Case "number" : style = #TE_Style_Number
							Case "pointer" : style = #TE_Style_Pointer
							Case "constant" : style = #TE_Style_Constant
							Case "operator" : style = #TE_Style_Operator
							Case "backslash" : style = #TE_Style_Backslash
							Case "comma" : style = #TE_Style_Comma
							Case "bracket" : style = #TE_Style_Bracket
							Case "label" : style = #TE_Style_Label
							Case "highlight" : style = #TE_Style_Highlight
							Case "codematch" : style = #TE_Style_CodeMatch
							Case "codemismatch" : style = #TE_Style_CodeMismatch
							Case "bracketmatch" : style = #TE_Style_BracketMatch
							Case "bracketmismatch" : style = #TE_Style_BracketMismatch
								;Default					: style = #TE_Style_None
								
						EndSelect
						
						Protected fontNr
						Protected fontName.s = Trim(GetXMLAttribute(subNode, "fontNr"))
						Protected fColorRGBA
						Protected fColor.s = Trim(GetXMLAttribute(subNode, "foreColor"))
						Protected bColorRGBA
						Protected bColor.s = Trim(GetXMLAttribute(subNode, "backColor"))
						Protected underlined
						
						Select LCase(fontName)
							Case "ignore" : fontNr = #TE_Ignore
							Default : : fontNr = Val(fontName)
						EndSelect
						
						If fColor
							If CountString(fColor, ",") = 2
								fColorRGBA = RGBA(Val(StringField(fColor, 1, ",")), 
								Val(StringField(fColor, 2, ",")), 
								Val(StringField(fColor, 3, ",")), 
								255)
							Else
								fColorRGBA = RGBA(Val(StringField(fColor, 1, ",")), 
								Val(StringField(fColor, 2, ",")), 
								Val(StringField(fColor, 3, ",")), 
								Val(StringField(fColor, 4, ",")))
							EndIf
						Else
							fColorRGBA = #TE_Ignore
						EndIf
						
						If bColor
							If CountString(bColor, ",") = 2
								bColorRGBA = RGBA(Val(StringField(bColor, 1, ",")), 
								Val(StringField(bColor, 2, ",")), 
								Val(StringField(bColor, 3, ",")), 
								255)
							Else
								bColorRGBA = RGBA(Val(StringField(bColor, 1, ",")), 
								Val(StringField(bColor, 2, ",")), 
								Val(StringField(bColor, 3, ",")), 
								Val(StringField(bColor, 4, ",")))
							EndIf
							
						Else
							bColorRGBA = #TE_Ignore
						EndIf
						
						Select LCase(GetXMLAttribute(subNode, "underlined"))
							Case "true", "1" : underlined = #True
							Default : underlined = #False
						EndSelect
						
						Style_Set(*te, style, fontNr, fColorRGBA, bColorRGBA, underlined)
					EndIf
					
				Case "keywords"
					
					text = GetXMLAttribute(subNode, "name")
					text = RemoveString(text, #CR$)
					text = RemoveString(text, #LF$)
					text = RemoveString(text, #TAB$)
					text = RemoveString(text, " ")
					
					If text
						flags = GetXMLAttribute(subNode, "style")
						
						If flags = ""
							style = #TE_Ignore
						Else
							style = 0
							For i = CountString(flags, ",") + 1 To 1 Step - 1
								Select LCase(StringField(flags, i, ","))
									Case "none" : style = #TE_Style_None
									Case "keyword" : style = #TE_Style_Keyword
									Case "function" : style = #TE_Style_Function
									Case "structure" : style = #TE_Style_Structure
									Case "text" : style = #TE_Style_Text
									Case "string" : style = #TE_Style_String
									Case "comment" : style = #TE_Style_Comment
									Case "number" : style = #TE_Style_Number
									Case "pointer" : style = #TE_Style_Pointer
									Case "constant" : style = #TE_Style_Constant
									Case "operator" : style = #TE_Style_Operator
									Case "backslash" : style = #TE_Style_Backslash
									Case "comma" : style = #TE_Style_Comma
									Case "bracket" : style = #TE_Style_Bracket
									Case "highlight" : style = #TE_Style_Highlight
									Case "codematch" : style = #TE_Style_CodeMatch
									Case "codemismatch" : style = #TE_Style_CodeMismatch
									Case "bracketmatch" : style = #TE_Style_BracketMatch
									Case "bracketmismatch" : style = #TE_Style_BracketMismatch
								EndSelect
							Next
						EndIf
						
						folding = Val(GetXMLAttribute(subNode, "fold"))
						indentBefore = Val(StringField(GetXMLAttribute(subNode, "indent"), 1, ","))
						indentAfter = Val(StringField(GetXMLAttribute(subNode, "indent"), 2, ","))
						
						If GetXMLAttribute(subNode, "casecorrect") = ""
							caseCorrection = #True
						Else
							caseCorrection = #TE_Ignore
						EndIf
						
						For i = CountString(text, ",") + 1 To 1 Step -1
							key = StringField(text, i, ",")
							KeyWord_Add(*te, key, style, caseCorrection)
							If folding
								KeyWord_Folding(*te, key, folding)
							EndIf
							If indentBefore Or indentAfter
								KeyWord_Indentation(*te, key, indentBefore, indentAfter)
							EndIf
						Next
					EndIf
					
				Case "syntax"
					
					text = GetXMLAttribute(subNode, "name")
					If text
						flags = GetXMLAttribute(subNode, "flags")
						flag = 0
						If flags
							For i = CountString(flags, ",") + 1 To 1 Step - 1
								Select LCase(StringField(flags, i, ","))
									Case "compiler" : flag | #TE_Flag_Compiler
									Case "container" : flag | #TE_Flag_Container
									Case "procedure" : flag | #TE_Flag_Procedure
									Case "return" : flag | #TE_Flag_Return
									Case "loop" : flag | #TE_Flag_Loop
									Case "break" : flag | #TE_Flag_Break
									Case "continue" : flag | #TE_Flag_Continue
								EndSelect
							Next
						EndIf
						
						Syntax_Add(*te, text, flag)
					EndIf
					
				Case "linecontinuation"
					
					text = GetXMLAttribute(subNode, "name")
					If text
						key = ""
						For i = CountString(text, " ") + 1 To 1 Step -1
							If key : key + Chr(10) : EndIf
							key + StringField(text, i, " ")
						Next
						KeyWord_LineContinuation(*te, key)
					EndIf
					
				Case "comments"
					
					text = GetXMLAttribute(subNode, "comment")
					If text
						*te\commentChar = text
					EndIf
					
					text = GetXMLAttribute(subNode, "uncomment")
					If text
						*te\uncommentChar = text
					EndIf
					
			EndSelect
			
			subNode = NextXMLNode(subNode)
		Wend
	EndProcedure
	
	Procedure Styling_OpenXml(*te.TE_STRUCT, fileName.s)
		ProcedureReturnIf( (*te = #Null) Or (fileName = ""))
		
		Protected xml, mainNode, node
		Protected result = #False
		
		If fileName <> ""
			xml = LoadXML(#PB_Any, fileName)
			
			If IsXML(xml)
				
				ClearMap(*te\keyWord())
				
				mainNode = MainXMLNode(xml)
				If mainNode
					node = ChildXMLNode(mainNode)
					While node
						Styling_ReadXml(*te, node)
						node = NextXMLNode(node)
					Wend
					result = #True
				EndIf
				
				ForEach *te\textLine()
					Style_Textline(*te, *te\textLine(), #TE_Styling_All)
				Next
			EndIf
		EndIf
		
		If result = #False
			MessageRequester(*te\laguage\errorTitle, ReplaceString(*te\laguage\errorNotFound, "%N1", fileName), #PB_MessageRequester_Error)
		EndIf
		
		ProcedureReturn result
	EndProcedure
	
	
	;-
	;- ----------- EVENT HANDLING -----------
	;-
	
	Procedure Event_Keyboard(*te.TE_STRUCT, *view.TE_VIEW, event_type)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (IsGadget(*te\currentView\canvas) = 0))
		
		Protected key, modifiers
		Protected styleFlags
		Protected nrLinesToPageStart
		Protected overwriteMode = *te\cursorState\overwrite
		Protected clearSelection = #True
		Protected autocompleteShow = #False
		Protected autocompleteKey = 0
		Protected updateScroll = #True
		Protected needredraw = #False
		Protected *cursor.TE_CURSOR
		Protected addLineHistory = #True
		Protected undoCount = ListSize(*te\undo\entry())
		Protected oldScrollLine = *view\scroll\visibleLineNr
		
		If *te\cursorState\state > 0
			; we are in drag/drop mode
			; escape key	- cancel
			; ctrl key		- copy / move
			
			key = GetGadgetAttribute(*view\canvas, #PB_Canvas_Key)
			modifiers = GetGadgetAttribute(*view\canvas, #PB_Canvas_Modifiers)
			If key = #PB_Shortcut_Escape
				DragDrop_Cancel(*te)
				Draw(*te, *view)
			Else
				If modifiers & #PB_Canvas_Control
					*te\cursorState\state = #TE_CursorState_DragCopy
				Else
					*te\cursorState\state = #TE_CursorState_DragMove
				EndIf
				
				If (event_type = #PB_EventType_KeyDown) Or (event_type = #PB_EventType_KeyUp)
					Draw(*te, *view)
				EndIf
			EndIf
			
			ProcedureReturn
		EndIf
		
		If event_type = #PB_EventType_KeyUp
			Undo_Update(*te)
			If *te\undo\clearRedo And (ListSize(*te\undo\entry()) > *te\undo\index)
				Undo_Clear(*te\redo)
			EndIf
			
			*te\undo\start = 0
			*te\undo\clearRedo = #True
			
			ProcedureReturn #True
		EndIf
		
		*te\undo\index = Undo_Start(*te\undo)
		*te\undo\start = 1
		*te\needScrollUpdate = #True
		
		ForEach *te\cursor()
			; save the current cursor position and selection
 			CopyStructure(*te\cursor()\position, *te\cursor()\lastPosition, TE_POSITION)
			CopyStructure(*te\cursor()\selection, *te\cursor()\lastSelection, TE_POSITION)
		Next
		
		If event_type = #PB_EventType_Input
			
			key = GetGadgetAttribute(*view\canvas, #PB_Canvas_Input)
			autocompleteShow = #True
			
			Select key
					
				Case 127
					
					key = 0
					
				Case 32 To #TE_CharRange
					
					Select key
						Case 'a' To 'z', 'A' To 'Z', '_', '0' To '9', 128 To #TE_CharRange
							styleFlags = #TE_Styling_UnfoldIfNeeded
							; 							Case ' '
							; 								styleFlags = #TE_Styling_UnfoldIfNeeded
						Default
							styleFlags = #TE_Styling_CaseCorrection | #TE_Styling_UpdateFolding
					EndSelect
					
					If LastElement(*te\cursor())
						Repeat
							*cursor = *te\cursor()
							
							If Selection_Delete(*te, *cursor, *te\undo)
								overwriteMode = #False
							Else
								overwriteMode = *te\cursorState\overwrite
							EndIf
							Textline_AddChar(*te, *cursor, key, overwriteMode, styleFlags, *te\undo)
							
							Folding_UnfoldTextline(*te, *cursor\position\lineNr)
							
							If *cursor\position\textline
								*cursor\position\textline\needStyling = #True
							EndIf
							; Scroll_Update(*te, *view, *te\cursor(), *te\cursor()\lastPosition\lineNr, *te\cursor()\lastPosition\charNr)
						Until PreviousElement(*te\cursor()) = #Null
					EndIf
					
				Default
					
					key = 0
					
			EndSelect
			
			If Parser_TokenAtCharNr(*te, *te\currentCursor\position\textline, *te\currentCursor\position\charNr - 1)
				If (*te\parser\token\type = #TE_Token_Text); Or (*te\parser\token\type = #TE_Token_Pointer) Or (*te\parser\token\type = #TE_Token_Constant) Or (*te\parser\token\type = #TE_Token_Structure)
					autocompleteShow = #True
				Else
					Autocomplete_UpdateDictonary(*te)
					autocompleteShow = #False
				EndIf
			EndIf
			
			*te\redrawMode = #TE_Redraw_ChangedLined
			
		ElseIf event_type = #PB_EventType_KeyDown
			
			key = GetGadgetAttribute(*view\canvas, #PB_Canvas_Key)
			modifiers = GetGadgetAttribute(*view\canvas, #PB_Canvas_Modifiers)
			autocompleteShow = #False
			
			If (ListSize(*te\textLine()) = 0)
				; this should not happen - but if there is no textline, add one
				If Textline_Add(*te)
					Cursor_Position(*te, *te\currentCursor, 1, 1)
					*view\scroll\visibleLineNr = 1
					*view\scroll\charX = 1
				EndIf
			EndIf
			
			If modifiers & #PB_Canvas_Shift
				ForEach *te\cursor()
					If *te\cursor()\selection\lineNr < 1
						Selection_Start(*te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr)
;						CopyStructure(*te\cursor()\position, *te\cursor()\firstPosition, TE_POSITION)
					EndIf
				Next
				
				If key = #PB_Shortcut_Insert
					key = #PB_Shortcut_V
					modifiers = #PB_Canvas_Control
				EndIf
				
			EndIf
			
			If (modifiers & #PB_Canvas_Shift) Or (modifiers & #PB_Canvas_Control)
				clearSelection = #False
			Else
				clearSelection = #True
			EndIf
			
			Select key
					
				Case #PB_Shortcut_Escape
					
					Cursor_Clear(*te, *te\maincursor)
					
					DragDrop_Cancel(*te)
					
				Case #PB_Shortcut_Insert
					
					*te\cursorState\overwrite = Bool(Not *te\cursorState\overwrite)
					needredraw = #True
					
				Case #PB_Shortcut_F1
					
					ForEach *te\cursor()
						Selection_Beautify(*te, *te\cursor())
					Next
					Indentation_Range(*te, *te\currentCursor\position\lineNr, *te\currentCursor\selection\lineNr, *te\currentCursor)
					clearSelection = #False
					
				Case #PB_Shortcut_F2
					
					If modifiers & #PB_Canvas_Control
						Marker_Add(*te, *te\currentCursor\position\textline, #TE_Marker_Bookmark)
					Else
						Marker_Jump(*te, #TE_Marker_Bookmark)
					EndIf
					needredraw = #True
					
				Case #PB_Shortcut_F3
					
					If modifiers & #PB_Canvas_Shift
						Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Previous)
					Else
						Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Next)
					EndIf
					
					clearSelection = #False
					
				Case #PB_Shortcut_F4
					
					If modifiers & #PB_Canvas_Control
						ForEach *te\textBlock()
							needredraw + Folding_Toggle(*te, *te\textBlock()\firstLineNr)
						Next
					Else
						needredraw + Folding_Toggle(*te, *te\currentCursor\position\lineNr)
					EndIf
					
				Case #PB_Shortcut_F9
					
					Marker_Add(*te, *te\currentcursor\position\textline, #TE_Marker_Breakpoint)
					needredraw = #True
					
				Case #PB_Shortcut_A
					
					If modifiers & #PB_Canvas_Control
						If Selection_SelectAll(*te)
							*te\needScrollUpdate = #False
						EndIf
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_B
					
					If modifiers & #PB_Canvas_Control
						
						ForEach *te\cursor()
							If modifiers & #PB_Canvas_Shift
								Selection_Uncomment(*te, *te\cursor())
							Else
								Selection_Comment(*te, *te\cursor())
							EndIf
						Next
						
						clearSelection = #False
						modifiers = 0
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_C
					
					If modifiers & #PB_Canvas_Control
						ClipBoard_Copy(*te)
					EndIf
					
					key = 0
					
				Case #PB_Shortcut_D
					
					If modifiers & #PB_Canvas_Control
						ForEach *te\cursor()
							If Selection_Clone(*te, *te\cursor())
								needredraw = #True
							EndIf
						Next
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_E
					
					If modifiers & #PB_Canvas_Control
						If modifiers & #PB_Canvas_Shift
							Selection_MoveComment(*te, -1)
						Else
							Selection_MoveComment(*te, 1)
						EndIf
						
						modifiers = 0
					Else
						key = 0
					EndIf
					
					clearSelection = #False
					updateScroll = #False
					*te\needScrollUpdate = #False
					
				Case #PB_Shortcut_F
					
					If modifiers & #PB_Canvas_Control
						
						If *te\currentCursor\position\lineNr = *te\currentCursor\selection\lineNr
							Find_Show(*te, Text_Get(*te, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, *te\currentCursor\selection\lineNr, *te\currentCursor\selection\charNr))
						Else
							Find_Show(*te, "")
						EndIf
						ProcedureReturn
						key = 0
					EndIf
					
					clearSelection = #False
					
				Case #PB_Shortcut_G
					
					If modifiers & #PB_Canvas_Control
						Cursor_GotoLineNr(*te, *te\currentCursor)
					EndIf
					
				Case #PB_Shortcut_I
					
					If modifiers & #PB_Canvas_Control
						ForEach *te\cursor()
							Indentation_Range(*te, *te\cursor()\position\lineNr, *te\cursor()\selection\lineNr, *te\cursor(), #TE_Indentation_Auto)
						Next
						updateScroll = #False
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_L
					
					If modifiers = (#PB_Canvas_Control | #PB_Canvas_Alt)
						Selection_ChangeCase(*te, #TE_Text_LowerCase)
					ElseIf modifiers = (#PB_Canvas_Control | #PB_Canvas_Shift)
						Cursor_AddMultiFromText(*te, Text_Get(*te, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, *te\currentCursor\selection\lineNr, *te\currentCursor\selection\charNr))
						updateScroll = #False
					ElseIf modifiers = #PB_Canvas_Control
						Cursor_LineHistoryGoto(*te)
						addLineHistory = #False
						*te\needScrollUpdate = #True
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_U
					
					If modifiers = (#PB_Canvas_Control | #PB_Canvas_Alt)
						Selection_ChangeCase(*te, #TE_Text_UpperCase)
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_V
					
					If modifiers & #PB_Canvas_Control
						ClipBoard_Paste(*te)
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_X
					
					If modifiers & #PB_Canvas_Control
						ClipBoard_Cut(*te)
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_Y
					
					If modifiers & #PB_Canvas_Control
						Undo_Update(*te)
						If Undo_Do(*te, *te\redo, *te\undo)
							*te\undo\clearRedo = #False
						EndIf
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_Z
					
					If modifiers & #PB_Canvas_Control
						Undo_Update(*te)
						Undo_Do(*te, *te\undo, *te\redo)
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_Tab
					
					If *te\autocomplete\isVisible
						autocompleteKey = #PB_Shortcut_Tab
					ElseIf (modifiers & #PB_Canvas_Control) = 0
						ForEach *te\cursor()
							If modifiers & #PB_Canvas_Shift
								If Selection_Unindent(*te, *te\cursor())
									*te\cursor()\lastPosition\charNr = *te\cursor()\position\charNr
									updateScroll = #False
									clearSelection = #False
								EndIf
							Else
								If Selection_Indent(*te, *te\cursor())
									*te\cursor()\lastPosition\charNr = *te\cursor()\position\charNr
									updateScroll = #False
									clearSelection = #False
								Else
									Selection_Delete(*te, *te\cursor(), *te\undo)
									Indentation_Add(*te, *te\cursor())
									clearSelection = #True
								EndIf
							EndIf
						Next
						
						If modifiers & #PB_Canvas_Shift
							modifiers = 0
						EndIf
					Else
						key = 0
					EndIf
					
				Case #PB_Shortcut_Back
					
					If LastElement(*te\cursor())
						Repeat
							
							If modifiers & #PB_Canvas_Control
								
								If modifiers & #PB_Canvas_Shift
									Cursor_Position(*te, *te\cursor(), *te\cursor()\position\lineNr, 1)
								Else
									Cursor_NextWord(*te, *te\cursor(), -1)
								EndIf
								
								Selection_SetRange(*te, *te\cursor(), *te\currentCursor\lastPosition\lineNr, *te\currentCursor\lastPosition\charNr, #False)
								If Selection_Delete(*te, *te\cursor(), *te\undo)
									*te\cursor()\lastPosition\lineNr = -1
								EndIf
								
								modifiers = 0
								
							Else
								
								If Selection_Delete(*te, *te\cursor(), *te\undo) = #False
									If Textline_JoinPreviousLine(*te, *te\cursor(), *te\cursor()\position\textline, *te\undo) = #False
										Protected nextChar1 = Textline_CharAtPos(*te\cursor()\position\textline, *te\cursor()\position\charNr - 1)
										Protected nextChar2 = Textline_CharAtPos(*te\cursor()\position\textline, *te\cursor()\position\charNr)
										If (nextChar1 = '(' And nextChar2 = ')') Or (nextChar1 = '[' And nextChar2 = ']') Or (nextChar1 = '{' And nextChar2 = '}')
											Cursor_Move(*te, *te\cursor(), 0, -1)
											Selection_SetRange(*te, *te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr + 2, #False)
										Else
											Selection_SetRange(*te, *te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr - 1, #False)
										EndIf
										
										Selection_Delete(*te, *te\cursor(), *te\undo)
									EndIf
								EndIf
								
							EndIf
							
						Until PreviousElement(*te\cursor()) = #Null
					EndIf
					
					needredraw = #True
					
					If ListSize(*te\cursor()) = 1
						autocompleteShow = #True
					EndIf
					
				Case #PB_Shortcut_Delete
					
					If LastElement(*te\cursor())
						Repeat
							If modifiers & #PB_Canvas_Control
								If Parser_TokenAtCharNr(*te, *te\cursor()\position\textline, *te\cursor()\position\charNr)
									Selection_SetRange(*te, *te\cursor(), *te\cursor()\position\lineNr, *te\cursor()\position\charNr + (*te\parser\token\charNr + *te\parser\token\size - *te\cursor()\position\charNr), #False)
								EndIf
							EndIf
							
							If Selection_Delete(*te, *te\cursor(), *te\undo) = #False
								If Textline_JoinNextLine(*te, *te\cursor(), *te\undo) = #False
									Selection_SetRange(*te, *te\cursor(), *te\cursor()\position\lineNr, Min(*te\cursor()\position\charNr + 1, Textline_Length(*te\cursor()\position\textline) + 1), #False)
									Selection_Delete(*te, *te\cursor(), *te\undo)
								EndIf
							EndIf
						Until (PreviousElement(*te\cursor()) = #Null)
					EndIf
					
				Case #PB_Shortcut_Return
					
					If LastElement(*te\cursor())
						Repeat
							Folding_UnfoldTextline(*te, *te\cursor()\position\lineNr)
						Until PreviousElement(*te\cursor()) = #Null
					EndIf
					Folding_Update(*te, -1, -1)
					
					If LastElement(*te\cursor())
						Repeat
							Selection_Delete(*te, *te\cursor(), *te\undo)
							Protected *textline.TE_TEXTLINE = *te\cursor()\position\textline
							
							If (modifiers & #PB_Canvas_Shift)
								Textline_Beautify(*te, *textline)
								Style_Textline(*te, *textline, #TE_Styling_All)
								Indentation_Range(*te, *te\cursor()\position\lineNr, *te\cursor()\position\lineNr, *te\cursor())
							ElseIf Textline_AddText(*te, *te\cursor(), @*te\newLineText, Len(*te\newLineText), #TE_Styling_All, *te\undo)
								If *te\cursor()\position\textline <> *textline
									Textline_Beautify(*te, *textline)
								EndIf
								Textline_Beautify(*te, *te\cursor()\position\textline)
								
								Protected indentation = Indentation_Range(*te, *te\cursor()\position\lineNr - 1, *te\cursor()\position\lineNr, #Null, *te\indentationMode)
								Cursor_Position(*te, *te\cursor(), *te\cursor()\position\lineNr, indentation)
							EndIf
						Until PreviousElement(*te\cursor()) = #Null
					EndIf
					
					clearSelection = #True
					needredraw = #True
					
				Case #PB_Shortcut_Home
					
					If modifiers & #PB_Canvas_Control
						Cursor_Position(*te, *te\currentCursor, 1, 1)
					Else
						ForEach *te\cursor()
							Cursor_Position(*te, *te\cursor(), *te\cursor()\position\lineNr, Textline_Start(*te\cursor()\position\textline, *te\cursor()\position\charNr))
						Next
					EndIf
					
				Case #PB_Shortcut_End
					
					If modifiers & #PB_Canvas_Control
						Cursor_Position(*te, *te\currentCursor, ListSize(*te\textLine()) + 1, 1)
					Else
						ForEach *te\cursor()
							Cursor_Position(*te, *te\cursor(), *te\cursor()\position\lineNr, Textline_Length(*te\cursor()\position\textline) + 1)
						Next
					EndIf
					
				Case #PB_Shortcut_Left
					
					ForEach *te\cursor()
						If (modifiers & #PB_Canvas_Shift = 0) And Cursor_HasSelection(*te\cursor())
							Cursor_SelectionStart(*te, *te\cursor())
							clearSelection = #True
; 							Selection_Clear(*te, *te\cursor())
						ElseIf modifiers & #PB_Canvas_Control
							Cursor_NextWord(*te, *te\cursor(), -1)
						ElseIf (modifiers & #PB_Canvas_Alt) = 0
							needredraw + Cursor_Move(*te, *te\cursor(), 0, -1)
							needredraw = 1
						EndIf
					Next
					
				Case #PB_Shortcut_Right
					
					ForEach *te\cursor()
						PushListPosition(*te\cursor())
						If (modifiers & #PB_Canvas_Shift = 0) And Cursor_HasSelection(*te\cursor())
							Cursor_SelectionEnd(*te, *te\cursor())
							clearSelection = #True
; 							Selection_Clear(*te, *te\cursor())
						ElseIf modifiers & #PB_Canvas_Control
							Cursor_NextWord(*te, *te\cursor(), 1)
						ElseIf modifiers & #PB_Canvas_Alt = 0
							needredraw + Cursor_Move(*te, *te\cursor(), 0, 1)
							needredraw = 1
						EndIf
						PopListPosition(*te\cursor())
					Next
					
				Case #PB_Shortcut_Up
					
					If *te\autocomplete\isVisible
						autocompleteKey = #PB_Shortcut_Up
						key = 0
					Else
						If modifiers & #PB_Canvas_Control
							If modifiers & #PB_Canvas_Alt
								If FirstElement(*te\cursor())
									*cursor = Cursor_Add(*te, *te\cursor()\position\lineNr - 1, Textline_CharNrFromScreenPos(*te, Textline_FromLine(*te, *te\cursor()\position\lineNr - 1), *te\maincursor\position\charX))
									If *cursor
										Scroll_Update(*te, *view, *cursor, -1, -1)
									EndIf
								EndIf
							ElseIf (modifiers & #PB_Canvas_Shift)
								Selection_Move(*te, -1)
							Else
								Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr - 1, #False)
							EndIf
						Else
							ForEach *te\cursor()
								needredraw + Cursor_Move(*te, *te\cursor(), -1, 0)
							Next
						EndIf
					EndIf
					
				Case #PB_Shortcut_Down
					
					If *te\autocomplete\isVisible
						autocompleteKey = #PB_Shortcut_Down
						key = 0
					Else
						If modifiers & #PB_Canvas_Control
							If modifiers & #PB_Canvas_Alt
								If LastElement(*te\cursor())
									*cursor = Cursor_Add(*te, *te\cursor()\position\lineNr + 1, Textline_CharNrFromScreenPos(*te, Textline_FromLine(*te, *te\cursor()\position\lineNr + 1), *te\maincursor\position\charX))
									If *cursor
										Scroll_Update(*te, *view, *cursor, -1, -1)
									EndIf
								EndIf
							ElseIf modifiers & #PB_Canvas_Shift
								Selection_Move(*te, 1)
							Else
								Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr + 1, #False)
							EndIf
						Else
							ForEach *te\cursor()
								needredraw + Cursor_Move(*te, *te\cursor(), 1, 0)
							Next
						EndIf
					EndIf
					
				Case #PB_Shortcut_PageUp
					
					nrLinesToPageStart = *te\currentCursor\position\visibleLineNr - Textline_TopLine(*te)
					ForEach *te\cursor()
						Cursor_Move(*te, *te\cursor(), -*view\pageHeight, 0)
					Next
					
					Scroll_Line(*te, *view, *te\currentCursor, *te\currentCursor\position\visibleLineNr - nrLinesToPageStart)
					
				Case #PB_Shortcut_PageDown
					
					nrLinesToPageStart = *te\currentCursor\position\visibleLineNr - Textline_TopLine(*te)
					ForEach *te\cursor()
						Cursor_Move(*te, *te\cursor(), *view\pageHeight, 0)
					Next
					
					Scroll_Line(*te, *view, *te\currentCursor, *te\currentCursor\position\visibleLineNr - nrLinesToPageStart)
					
				Case #PB_Shortcut_Add
					
					If modifiers = #PB_Canvas_Control
						needredraw = View_Zoom(*te, *view, 1)
					EndIf
					
				Case #PB_Shortcut_Subtract
					
					If modifiers = #PB_Canvas_Control
						needredraw = View_Zoom(*te, *view, -1)
					EndIf
					
				Case #PB_Shortcut_Pad0
					
					If modifiers = #PB_Canvas_Control
						needredraw = View_Zoom(*te, *view, 0)
					EndIf
					
				Default
					
					key = 0
					
			EndSelect
			
			If key
				*te\redrawMode = #TE_Redraw_All
			Else
				*te\redrawMode = #TE_Redraw_ChangedLined
			EndIf
			
		EndIf
		
		If key Or autocompleteKey
			
			If (event_type <> #PB_EventType_Input) And undoCount And (undoCount <> ListSize(*te\undo\entry()))
				Autocomplete_UpdateDictonary(*te.TE_STRUCT)
			EndIf
			
			If Cursor_HasSelection(*te\currentCursor)
				If (*te\currentCursor\position\lineNr = *te\currentCursor\selection\lineNr)
					Selection_HighlightText(*te, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, *te\currentCursor\selection\lineNr, *te\currentCursor\selection\charNr)
				Else
					Selection_HighlightClear(*te)
				EndIf
			EndIf
			
			If clearSelection
				needredraw = #True
  				Selection_ClearAll(*te)
			EndIf
			
			ForEach *te\cursor()
				If Position_Changed(*te\cursor()\lastPosition, *te\cursor()\position)
					Cursor_DeleteOverlapping(*te, *te\cursor(), #True)
				EndIf
			Next
			
			If *te\currentCursor
				If (*te\currentCursor\position\textline <> *te\currentCursor\lastPosition\textline)
					autocompleteShow = #False
				EndIf
			EndIf
			
			If *te\enableAutoComplete And autocompleteShow
				Autocomplete_Show(*te)
			EndIf
			
			If *te\autocomplete\isVisible
				If autocompleteKey = #PB_Shortcut_Up
					SetGadgetState(*te\autocomplete\lst_listBox, Max(0, GetGadgetState(*te\autocomplete\lst_listBox) - 1))
				ElseIf autocompleteKey = #PB_Shortcut_Down
					SetGadgetState(*te\autocomplete\lst_listBox, GetGadgetState(*te\autocomplete\lst_listBox) + 1)
				ElseIf autocompleteKey = #PB_Shortcut_Tab
					Autocomplete_Insert(*te)
				ElseIf autocompleteShow = #False
					Autocomplete_Hide(*te)
				EndIf
			EndIf
			
			If *te\needFoldUpdate
				Folding_Update(*te, -1, -1)
			EndIf
			
			If updateScroll Or *te\needScrollUpdate
				;  				Scroll_Update(*te, *te\currentView, *te\currentCursor, -1, -1, *te\needScrollUpdate)
				Scroll_UpdateAllViews(*te, *te\view, *te\currentView, *te\currentCursor)
			EndIf
			
			If ListSize(*te\cursor()) = 1 And Cursor_HasSelection(*te\currentCursor) = #False
				Parser_SyntaxCheckStart(*te, *te\currentCursor)
			Else
				*te\highlightSyntax = 0
			EndIf
			
			If (modifiers & #PB_Canvas_Shift) And (*te\currentCursor\position\lineNr = *te\currentCursor\lastPosition\lineNr) And (*te\currentCursor\position\charNr <> *te\currentCursor\lastPosition\charNr)
				*te\redrawMode | #TE_Redraw_All
			Else
				ForEach *te\cursor()
					If (*te\cursor()\lastSelection\lineNr <> *te\cursor()\selection\lineNr)
						*te\redrawMode | #TE_Redraw_All
						Break
					EndIf
				Next
			EndIf
			
			Cursor_SignalChanges(*te, *te\currentCursor)
		EndIf
		
		Find_SetSelectionCheckbox(*te)
		
		If key And addLineHistory
			Cursor_LineHistoryAdd(*te)
		EndIf
		
		If *view\scroll\visibleLineNr <> oldScrollLine
			needredraw = #True
		Else
			ForEach *te\cursor()
				If Position_Changed(*te\cursor()\position, *te\cursor()\lastPosition)
					needredraw = #True
					Break
				ElseIf Position_Changed(*te\cursor()\selection, *te\cursor()\lastSelection)
					needredraw = #True
					Break
				EndIf
			Next
		EndIf
		
		If needredraw
			Draw(*te, *te\view, -1, *te\redrawMode)
		EndIf
		
	EndProcedure
	
	Procedure Event_Mouse(*te.TE_STRUCT, *view.TE_VIEW, event_type)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (*te\currentCursor = #Null) Or (IsGadget(*view\canvas) = 0))
		
		Protected time = ElapsedMilliseconds()
		Protected mx, my, modifiers, buttons
		Protected addCursor = #False
		Protected *cursor.TE_CURSOR = *te\currentCursor
		Protected *token.TE_TOKEN
		Protected mousePosition = #TE_MousePosition_TextArea
		Protected selection.TE_RANGE
		Protected position.TE_POSITION
		Protected needRedraw = #False
		
		mx = GetGadgetAttribute(*view\canvas, #PB_Canvas_MouseX) * *view\zoom
		my = GetGadgetAttribute(*view\canvas, #PB_Canvas_MouseY) * *view\zoom
		modifiers = *te\cursorState\modifiers
		buttons = *te\cursorState\buttons
		
		*te\cursorState\buttons = GetGadgetAttribute(*view\canvas, #PB_Canvas_Buttons)
		*te\cursorState\modifiers = GetGadgetAttribute(*view\canvas, #PB_Canvas_Modifiers)
		*te\cursorState\mouseX = mx / DesktopResolutionX()
		*te\cursorState\mouseY = my / DesktopResolutionY()
		*te\cursorState\windowMouseX = WindowMouseX(*te\window)
		*te\cursorState\windowMouseY = WindowMouseY(*te\window)
		*te\cursorState\deltaX = *te\cursorState\desktopMouseX - DesktopMouseX()
		*te\cursorState\deltaY = *te\cursorState\desktopMouseY - DesktopMouseY()
		*te\cursorState\desktopMouseY = DesktopMouseY()
		*te\cursorState\desktopMouseX = DesktopMouseX()
		
		Selection_Get(*cursor, selection)
		
		If *te\enableLineNumbers And (*te\cursorState\mouseX <= (*te\leftBorderOffset - *te\lineHeight))
			mousePosition = #TE_MousePosition_LineNumber
		ElseIf *te\cursorState\mouseX < *te\leftBorderOffset
			mousePosition = #TE_MousePosition_FoldState
		EndIf
		
		If *te\cursorState\state > 0
			If modifiers & #PB_Canvas_Control
				*te\cursorState\state = #TE_CursorState_DragCopy
			Else
				*te\cursorState\state = #TE_CursorState_DragMove
			EndIf
		EndIf
		
		If (buttons & #PB_Canvas_LeftButton) = 0
			*te\cursorState\dragStart = #False
		EndIf
		
		CopyStructure(*cursor\position, *cursor\lastPosition, TE_POSITION)
		CopyStructure(*cursor\selection, *cursor\lastSelection, TE_POSITION)
		
		Select event_type
				
			Case #PB_EventType_LeftButtonDown
				
				Autocomplete_Hide(*te)
				
				If (time - *te\cursorState\firstClickTime) > *te\cursorState\clickSpeed
					*te\cursorState\clickCount = 0
				EndIf
				*te\cursorState\firstClickTime = time
				
				If Cursor_GetScreenPos(*te, *view, mx, my, position) = #False
					ProcedureReturn
				EndIf
				
				If (position\lineNr = *te\cursorState\lastPosition\lineNr) And (position\charNr = *te\cursorState\lastPosition\charNr)
					*te\cursorState\clickCount + 1
				Else
					*te\cursorState\clickCount = 1
				EndIf
				
				If *te\cursorState\clickCount = 1
					If (modifiers & #PB_Canvas_Shift) = 0
						
						If *te\cursorState\dragStart = #False
							If modifiers & #PB_Canvas_Control
								*cursor = Cursor_Add(*te, position\lineNr, position\charNr)
								Cursor_SignalChanges(*te, *cursor)
								Draw(*te, *view, -1, #TE_Redraw_All)
								ProcedureReturn
							ElseIf (mousePosition <> #TE_MousePosition_FoldState) And (modifiers & #PB_Canvas_Alt = 0)
								Cursor_Clear(*te, *cursor)
							EndIf
						EndIf
						
						If mousePosition = #TE_MousePosition_TextArea
							If Position_InsideSelection(*te, *view, *te\cursorState\mouseX, *te\cursorState\mouseY)
								*te\cursorState\dragStart = #True
								CopyStructure(position, *te\cursorState\lastPosition, TE_POSITION)
								ProcedureReturn
							EndIf
						EndIf
						
						*te\cursorState\firstClickX = mx
						*te\cursorState\firstClickY = my
						CopyStructure(position, *cursor\firstPosition, TE_POSITION)
					EndIf
				EndIf
				
				If mousePosition = #TE_MousePosition_LineNumber
					
					If modifiers & #PB_Canvas_Control
						Selection_SelectAll(*te)
					Else
						If modifiers & #PB_Canvas_Shift
							If position\lineNr < *cursor\firstPosition\lineNr
								Cursor_Position(*te, *cursor, position\lineNr, 1, #False)
								Selection_SetRange(*te, *cursor, *te\cursorState\firstSelection\pos2\lineNr, *te\cursorState\firstSelection\pos2\charNr)
							Else
								Cursor_Position(*te, *cursor, position\lineNr + 1, 1, #False)
								Selection_SetRange(*te, *cursor, *te\cursorState\firstSelection\pos1\lineNr, *te\cursorState\firstSelection\pos1\charNr)
							EndIf
						Else
							Cursor_Position(*te, *cursor, position\lineNr + 1, 1, #False)
							Selection_SetRange(*te, *cursor, position\lineNr, 1)
							Selection_Get(*cursor, *te\cursorState\firstSelection)
							CopyStructure(position, *cursor\firstPosition, TE_POSITION)
						EndIf
					EndIf
					
				ElseIf mousePosition = #TE_MousePosition_FoldState
					
					If position\textline And (position\textline\foldState > 0)
						Folding_Toggle(*te, position\lineNr)
						*te\cursorState\state = -1
					EndIf
					
				ElseIf mousePosition = #TE_MousePosition_TextArea
					
					If *te\cursorState\clickCount = 1
						
						If (modifiers & #PB_Canvas_Shift = 0) And (modifiers & #PB_Canvas_Control = 0); And (*te\cursorState\state = 0)
							Selection_Start(*cursor, position\lineNr, position\charNr)
						EndIf
						
						Cursor_Position(*te, *cursor, position\lineNr, position\charNr)
						
						CopyStructure(*cursor\position, *cursor\firstPosition, TE_POSITION)
						
						If (modifiers & #PB_Canvas_Shift) = 0
							Selection_Get(*cursor, *te\cursorState\firstSelection)
						EndIf
						
					ElseIf *te\cursorState\clickCount = 2
						
						If (position\lineNr = *te\cursorState\lastPosition\lineNr) And (position\charNr = *te\cursorState\lastPosition\charNr)
							; double-click:		select the word under the cursor
							
							If Parser_TokenAtCharNr(*te, position\textline, Min(position\charNr, Textline_Length(position\textline)))
								Selection_SetRange(*te, *cursor, position\lineNr, *te\parser\token\charNr)
								Cursor_Position(*te, *cursor, position\lineNr, *te\parser\token\charNr + *te\parser\token\size)
								
								CopyStructure(*cursor\position, *cursor\firstPosition, TE_POSITION)
								Selection_Get(*cursor, *te\cursorState\firstSelection)
							EndIf
							
						EndIf
						
					ElseIf *te\cursorState\clickCount = 3
						; tripple-click:	select whole line
						
						Selection_SetRange(*te, *cursor, position\lineNr, 1)
						Cursor_Position(*te, *cursor, position\lineNr + 1, 1)
						
						CopyStructure(*cursor\position, *cursor\firstPosition, TE_POSITION)
						Selection_Get(*cursor, *te\cursorState\firstSelection)
						
						DebugRange("", *te\cursorState\firstSelection)
						
; 					Else
; 						
; 						*te\cursorState\clickCount = 0
						
; 					ElseIf (*te\cursorState\clickCount = 4)
; 						; quad-click:		select all
; 						
; 						Selection_SelectAll(*te)
					EndIf
					
				EndIf
				
				If *te\needFoldUpdate
					Folding_Update(*te, -1, -1)
				EndIf
				
				Cursor_DeleteOverlapping(*te, *cursor)
				
				If ListSize(*te\cursor()) = 1 And Cursor_HasSelection(*te\currentCursor) = #False
					Parser_SyntaxCheckStart(*te, *te\currentCursor)
				Else
					*te\highlightSyntax = 0
				EndIf
				
				Cursor_LineHistoryAdd(*te)
				
				Selection_HighlightClear(*te)
				Selection_HighlightText(*te, *cursor\position\lineNr, *cursor\position\charNr, *cursor\selection\lineNr, *cursor\selection\charNr)
				
				needRedraw = #True
				
				CopyStructure(position, *te\cursorState\lastPosition, TE_POSITION)
				
				Find_SetSelectionCheckbox(*te)
				
			Case #PB_EventType_LeftButtonUp
				
				If (time - *te\cursorState\firstClickTime) > *te\cursorState\clickSpeed
					*te\cursorState\clickCount = 0
				EndIf
				
				If *te\cursorState\clickCount = 3
					*te\cursorState\clickCount = 0
				EndIf
				
				If *te\cursorState\state = #TE_CursorState_Idle
					*te\cursorState\state = 0
					Draw(*te, *view, -1, #TE_Redraw_All)
				ElseIf (*te\cursorState\state = #TE_CursorState_DragCopy) Or (*te\cursorState\state = #TE_CursorState_DragMove)
					DragDrop_Drop(*te)
				ElseIf mousePosition = #TE_MousePosition_TextArea
					If *te\cursorState\clickCount = 1
						If Cursor_GetScreenPos(*te, *view, mx, my, position)
							If Position_Equal(position, *te\cursorState\lastPosition)
								If (modifiers & #PB_Canvas_Shift) = 0 And (modifiers & #PB_Canvas_Control) = 0
									Selection_Clear(*te, *cursor)
								EndIf
								If (modifiers & #PB_Canvas_Control) = 0
									Cursor_Clear(*te, *cursor)
								EndIf
								
								Cursor_Position(*te, *cursor, *te\cursorState\lastPosition\lineNr, *te\cursorState\lastPosition\charNr)
								Draw(*te, *view, -1, #TE_Redraw_All)
								
							EndIf
						EndIf
					EndIf
				EndIf
				
				*view\scroll\autoScroll = #False
				RemoveWindowTimer(*te\window, #TE_Timer_Scroll)
				
				Find_SetSelectionCheckbox(*te)
				
			Case #PB_EventType_RightButtonDown
				
				Autocomplete_Hide(*te)
				
				Draw(*te, *view, -1, #TE_Redraw_All)
				
			Case #PB_EventType_RightButtonUp
				
				DisplayPopupMenu(*te\popupMenu, WindowID(*te\window))
				
			Case #PB_EventType_MiddleButtonDown
				
				Autocomplete_Hide(*te)
				
			Case #PB_EventType_MouseMove
				
				If *te\cursorState\dragStart And (*te\cursorState\clickCount = 1)
					DragDrop_Start(*te)
				EndIf
				
				If *te\cursorState\state
					*te\redrawMode = #TE_Redraw_All
				EndIf
				
				*view\scroll\scrollDelay = 0
				If buttons & #PB_Canvas_LeftButton
					Protected yTop = DesktopScaledY(GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate) + (*te\lineHeight * 0.5))
					Protected yBottom = DesktopScaledY(GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate) + GadgetHeight(*view\canvas) - (*te\lineHeight * 0.5))
					If (*te\cursorState\desktopMouseY < yTop) Or (*te\cursorState\desktopMouseY > yBottom)
						If *view\scroll\autoScroll = #False
							*view\scroll\autoScroll = #True
							RemoveWindowTimer(*te\window, #TE_Timer_Scroll)
							AddWindowTimer(*te\window, #TE_Timer_Scroll, 25)
						EndIf
 						ProcedureReturn
					Else
						*view\scroll\autoScroll = #False
						RemoveWindowTimer(*te\window, #TE_Timer_Scroll)
					EndIf
				EndIf
				
				If mousePosition = #TE_MousePosition_TextArea
					SetGadgetAttribute(*view\canvas, #PB_Canvas_Cursor, #PB_Cursor_IBeam)
				ElseIf mousePosition = #TE_MousePosition_LineNumber
					SetGadgetAttribute(*view\canvas, #PB_Canvas_Cursor, #PB_Cursor_Hand)
				Else
					SetGadgetAttribute(*view\canvas, #PB_Canvas_Cursor, #PB_Cursor_Default)
				EndIf
				
 				If buttons = #PB_Canvas_LeftButton
					
 					If Cursor_GetScreenPos(*te, *view, mx, my, position); And Position_Changed(*cursor\lastPosition, position)
 						
 						If *te\cursorState\state
							CopyStructure(position, *te\cursorState\dragPosition, TE_POSITION)
						Else
							
							If Position_InsideRange(position, *te\cursorState\firstSelection, #False) And (*te\cursorState\clickCount > 1)
								Selection_SetRange(*te, *cursor, *te\cursorState\firstSelection\pos1\lineNr, *te\cursorState\firstSelection\pos1\charNr)
								Cursor_Position(*te, *cursor, *te\cursorState\firstSelection\pos2\lineNr, *te\cursorState\firstSelection\pos2\charNr)
							Else
								If (mousePosition = #TE_MousePosition_LineNumber) Or (Abs(*te\cursorState\firstSelection\pos1\lineNr - *te\cursorState\firstSelection\pos2\lineNr) = 1 And *te\cursorState\firstSelection\pos1\charNr = 1 And *te\cursorState\firstSelection\pos1\charNr = 1)
									If position\lineNr < *te\cursorState\firstSelection\pos1\lineNr
										Cursor_Position(*te, *cursor, position\lineNr, 1)
										Selection_SetRange(*te, *cursor, *te\cursorState\firstSelection\pos2\lineNr, *te\cursorState\firstSelection\pos2\charNr)
									Else
										Cursor_Position(*te, *cursor, position\lineNr + 1, 1)
										Selection_SetRange(*te, *cursor, *te\cursorState\firstSelection\pos1\lineNr, *te\cursorState\firstSelection\pos1\charNr)
									EndIf
								Else
									CopyStructure(*te\cursorState\firstSelection, selection, TE_RANGE)
									Selection_Add(selection, position\lineNr, position\charNr)
									
									Cursor_Position(*te, *cursor, position\lineNr, position\charNr)
									
									If Position_InsideRange(position, selection, #False) < 0
										Selection_SetRange(*te, *cursor, selection\pos2\lineNr, selection\pos2\charNr)
									Else
										Selection_SetRange(*te, *cursor, selection\pos1\lineNr, selection\pos1\charNr)
									EndIf
									
								EndIf
							EndIf
							
							If modifiers & #PB_Canvas_Alt
								Selection_SetRectangle(*te, *cursor)
							Else
								Cursor_DeleteOverlapping(*te, *cursor)
								
								If *cursor\position\lineNr = *cursor\selection\lineNr
									Selection_HighlightText(*te, *cursor\position\lineNr, *cursor\position\charNr, *cursor\selection\lineNr, *cursor\selection\charNr)
								Else
									Selection_HighlightClear(*te)
								EndIf
							EndIf
							
						EndIf
						
					EndIf
					
					needRedraw = #True
				EndIf
		EndSelect
		
		If *te\needFoldUpdate
			Folding_Update(*te, -1, -1)
		EndIf
		If *te\needScrollUpdate
			Scroll_Update(*te, *te\currentView, *te\currentCursor, *te\currentCursor\position\visibleLineNr, -1, *te\needScrollUpdate)
			Scroll_UpdateAllViews(*te, *te\view, *te\currentView, *te\currentCursor)
		EndIf
		
		If needRedraw
			*te\redrawMode | #TE_Redraw_All
			
			If *te\redrawMode
				If Position_Equal(*te\currentCursor\position, *te\currentCursor\lastPosition)
					Draw(*te, *te\view, 1)
				Else
					Draw(*te, *te\view, -1)
				EndIf
			EndIf
		EndIf
		
		Cursor_SignalChanges(*te, *te\currentCursor)
	EndProcedure
	
	Procedure Event_MouseWheel(*te.TE_STRUCT, *view.TE_VIEW, event_type)
		ProcedureReturnIf( (*te = #Null) Or (*view = #Null) Or (IsGadget(*view\canvas) = 0))
		
		Protected mx = GetGadgetAttribute(*view\canvas, #PB_Canvas_MouseX)
		Protected my = GetGadgetAttribute(*view\canvas, #PB_Canvas_MouseY)
		Protected buttons = GetGadgetAttribute(*view\canvas, #PB_Canvas_Buttons)
		Protected modifiers = GetGadgetAttribute(*view\canvas, #PB_Canvas_Modifiers)
		Protected direction = GetGadgetAttribute(*view\canvas, #PB_Canvas_WheelDelta)
		
		If modifiers = #PB_Canvas_Control
			View_Zoom(*te, *view, direction)
		Else
			If modifiers & #PB_Canvas_Shift
				Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr - direction * 13)
			Else
				Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr - direction * 3)
			EndIf
			
			If (modifiers & #PB_Canvas_Alt) And (buttons & #PB_Canvas_LeftButton)
				If Cursor_FromScreenPos(*te, *view, *te\currentCursor, mx, my)
					Selection_SetRectangle(*te, *te\currentCursor)
				EndIf
			EndIf
		EndIf
		
		Draw(*te, *te\view)
	EndProcedure
	
	Procedure Event_ScrollBar()
		Protected gNr = EventGadget()
		If IsGadget(gnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *view.TE_VIEW = GetGadgetData(gNr)
		ProcedureReturnIf( (*view = #Null) Or (*view\editor = #Null))
		
		Protected *te.TE_STRUCT = *view\editor
		ProcedureReturnIf(*te = #Null)
		
		If *te\currentCursor And (*view <> *te\currentView)
			*te\currentView = *view
			Scroll_Update(*te, *view, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr)
		EndIf
		
		If gNr = *view\scrollBarV\gadget
			Protected lineNr = ( (GetGadgetState(gNr) + 1) * *te\visibleLineCount) / #TE_MaxScrollbarHeight
			Scroll_Line(*te, *view, *te\currentCursor, lineNr, #True, #False)
		EndIf
		
		If gNr = *view\scrollBarH\gadget
			Scroll_Char(*te, *view, Int(GetGadgetState(gNr) * *view\scrollBarH\scale))
		EndIf
		
		Draw(*te, *te\view)
	EndProcedure
	
	Procedure Event_Timer()
		Protected wNr = EventWindow()
		If IsWindow(wnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *te.TE_STRUCT = GetWindowData(wNr)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentView = #Null) Or IsGadget(*te\currentView\canvas) = 0)
		
		Protected *view.TE_VIEW = *te\currentView
		
		Protected position.TE_POSITION
		Protected yTop, yBottom, scrollLines, xSize, ySize
		Protected lineNr, *textLine.TE_TEXTLINE
		Protected time = ElapsedMilliseconds()
		Protected scrolling = #False
		
		If EventTimer() = #TE_Timer_CursorBlink
			
			If *te\cursorState\blinkSuspend
				*te\cursorState\blinkSuspend = 0
				*te\cursorState\blinkState = 1
			Else
				*te\cursorState\blinkState = Bool(Not *te\cursorState\blinkState)
			EndIf
			
			ForEach *te\cursor()
				If *te\cursor()\position\textline
					*te\cursor()\position\textline\needRedraw = #True
				EndIf
			Next
			Draw(*te, *te\view, *te\cursorState\blinkState, #TE_Redraw_ChangedLined)
			
		ElseIf EventTimer() = #TE_Timer_Scroll
			
			lineNr = *te\currentCursor\position\lineNr
			
			If *view\scroll\autoScroll And ( (time > *view\scroll\scrollTime) Or (*view\scroll\scrollDelay = 0))
				yTop = DesktopScaledY(GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate) + (*te\lineHeight * 0.5))
				yBottom = DesktopScaledY(GadgetY(*view\canvas, #PB_Gadget_ScreenCoordinate) + GadgetHeight(*view\canvas) - (*te\lineHeight * 0.5))
				
				If *te\cursorState\desktopMouseY < yTop
					ySize = Min(*te\lineHeight * 2, yTop - *te\cursorState\desktopMouseY)
					xSize = Min(25, Abs(*te\cursorState\deltaX))
					
					scrollLines = Max(1, (ySize * 3) / (*te\lineHeight * 2.0)) + xSize
					scrolling = Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr - scrollLines)
					lineNr = Textline_TopLine(*te)
					
					*view\scroll\scrollDelay = Clamp(250 - (ySize * 250) / (*te\lineHeight + xSize), 0, 250)
				ElseIf *te\cursorState\desktopMouseY > yBottom
					ySize = Min(*te\lineHeight * 2, *te\cursorState\desktopMouseY - yBottom)
					xSize = Min(25, Abs(*te\cursorState\deltaX))
					
					scrollLines = Max(1, (ySize * 3) / (*te\lineHeight * 2.0)) + xSize
					scrolling = Scroll_Line(*te, *view, *te\currentCursor, *view\scroll\visibleLineNr + scrollLines)
					lineNr = Textline_BottomLine(*te)
					
					*view\scroll\scrollDelay = Clamp(250 - (ySize * 250) / (*te\lineHeight + xSize), 0, 250)
				EndIf
			EndIf
			
			If Cursor_GetScreenPos(*te, *view, DesktopScaledX(*te\cursorState\mouseX), DesktopScaledY(*te\cursorState\mouseY), position)
				If *te\cursorState\state = 0
					Cursor_Position(*te, *te\currentCursor, lineNr, position\charNr)
					*view\scroll\scrollTime = time + *view\scroll\scrollDelay
					
					If *te\cursorState\modifiers & #PB_Canvas_Alt
						Selection_SetRectangle(*te, *te\currentCursor)
					EndIf
				Else
					*te\cursorState\dragPosition\lineNr = position\lineNr
					*te\cursorState\dragPosition\charNr = position\charNr
				EndIf
			EndIf
			
			Cursor_SignalChanges(*te, *te\currentCursor)
			
			Draw(*te, *view)
			
		EndIf
	EndProcedure
	
	Procedure Event_Autocomplete()
		Protected gNr = EventGadget()
		If IsGadget(gnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *te.TE_STRUCT = GetGadgetData(gNr)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentView = #Null) Or IsGadget(*te\autocomplete\lst_listBox) = 0)
		
		Select EventType()
			Case #PB_EventType_LeftDoubleClick
				Autocomplete_Insert(*te)
				Draw(*te, *te\view, -1)
		EndSelect
		
		SetActiveGadget(*te\currentView\canvas)
	EndProcedure
	
	Procedure Event_FindReplace()
		Protected wNr = EventWindow()
		If IsWindow(wnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *te.TE_STRUCT = GetWindowData(wNr)
		Protected flags
		
		ProcedureReturnIf( (*te = #Null) Or (*te\currentView = #Null) Or (IsGadget(*te\currentView\canvas) = 0))
		
		Select Event()
				
			Case #PB_Event_CloseWindow
				
				If EventWindow() = *te\find\wnd_findReplace
					Find_Close(*te)
				EndIf
				ProcedureReturn
				
			Case #PB_Event_Menu
				
				If EventMenu() = #TE_Menu_EscapeKey
					Find_Close(*te)
					ProcedureReturn
				ElseIf EventMenu() = #TE_Menu_ReturnKey
					If Position_Equal(*te\currentCursor\position, *te\find\startPos)
						Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Next)
					Else
						flags = Find_Flags(*te)
						Find_Start(*te, *te\currentCursor, 0, 0, GetGadgetText(*te\find\cmb_search), "", flags | #TE_Find_Next | #TE_Find_StartAtCursor)
					EndIf
					ProcedureReturn
				EndIf
				
			Case #PB_Event_Gadget
				
				flags = Find_Flags(*te)
				
				Select EventGadget()
						
					Case *te\find\chk_regEx
						DisableGadget(*te\find\chk_caseSensitive, GetGadgetState(*te\find\chk_regEx))
						DisableGadget(*te\find\chk_wholeWords, GetGadgetState(*te\find\chk_regEx))
						
					Case *te\find\btn_close
						
						Find_Close(*te)
						
					Case *te\find\chk_replace
						
						If GetGadgetState(*te\find\chk_replace) = 1
							DisableGadget(*te\find\cmb_replace, 0)
							DisableGadget(*te\find\btn_replace, 0)
							DisableGadget(*te\find\btn_replaceAll, 0)
						Else
							DisableGadget(*te\find\cmb_replace, 1)
							DisableGadget(*te\find\btn_replace, 1)
							DisableGadget(*te\find\btn_replaceAll, 1)
						EndIf
						
					Case *te\find\btn_findNext
						
						If Position_Equal(*te\currentCursor\position, *te\find\startPos)
							Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Next)
						Else
							Find_Start(*te, *te\currentCursor, 0, 0, GetGadgetText(*te\find\cmb_search), "", flags | #TE_Find_Next | #TE_Find_StartAtCursor)
						EndIf
						
					Case *te\find\btn_findPrevious
						
						If Position_Equal(*te\currentCursor\position, *te\find\startPos)
							Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Previous)
						Else
							Find_Start(*te, *te\currentCursor, 0, 0, GetGadgetText(*te\find\cmb_search), "", flags | #TE_Find_Previous | #TE_Find_StartAtCursor)
						EndIf
						
					Case *te\find\btn_replace
						
						Undo_Start(*te\undo)
						If GetGadgetState(*te\find\chk_replace) = 1
							If Cursor_HasSelection(*te\currentCursor)
								Cursor_SelectionStart(*te, *te\currentCursor)
							EndIf
							
							If Find_Start(*te, *te\currentCursor, 0, 0, GetGadgetText(*te\find\cmb_search), GetGadgetText(*te\find\cmb_replace), flags | #TE_Find_Next | #TE_Find_Replace | #TE_Find_StartAtCursor)
								Find_Start(*te, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, GetGadgetText(*te\find\cmb_search), "", #TE_Find_Next)
							EndIf
						EndIf
						Undo_Update(*te)
						
					Case *te\find\btn_replaceAll
						
						Undo_Start(*te\undo)
						If GetGadgetState(*te\find\chk_replace) = 1
							flags = Find_Flags(*te)
							If Find_Start(*te, *te\currentCursor, 0, 0, GetGadgetText(*te\find\cmb_search), GetGadgetText(*te\find\cmb_replace), flags | #TE_Find_Next | #TE_Find_ReplaceAll)
								While Find_Next(*te, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr, *te\find\endPos\lineNr, *te\find\endPos\charNr, flags | #TE_Find_Next | #TE_Find_ReplaceAll)
								Wend
								Scroll_Line(*te, *te\currentView, *te\currentCursor, *te\currentCursor\position\lineNr - 3)
								Draw(*te, *te\view, -1)
							EndIf
							MessageRequester(*te\laguage\messageTitleFindReplace, ReplaceString(*te\laguage\messageReplaceComplete, "%N1", Str(*te\find\replaceCount)))
						EndIf
						Undo_Update(*te)
						
				EndSelect
				
		EndSelect
	EndProcedure
	
	
	Procedure Event_Resize(*te.TE_STRUCT, x, y, width, height)
		ProcedureReturnIf( (*te = #Null) Or (*te\view = #Null))
		
		If EventWindow() = *te\window
			Autocomplete_Hide(*te)
			
			View_Resize(*te, *te\view, x, y, width, height)
			Draw(*te, *te\view)
		EndIf
	EndProcedure
	
	Procedure Event_Window()
		Protected wNr = EventWindow()
		If IsWindow(wnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *te.TE_STRUCT = GetWindowData(wNr)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentView = #Null) Or (IsGadget(*te\currentView\canvas) = 0))
		
		If GetActiveWindow() <> *te\window
			Autocomplete_Hide(*te.TE_STRUCT)
		EndIf
	EndProcedure
	
	Procedure Event_Menu()
		Protected wNr = EventWindow()
		If IsWindow(wnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *te.TE_STRUCT = GetWindowData(wNr)
		ProcedureReturnIf( (*te = #Null) Or (*te\currentView = #Null) Or (IsGadget(*te\currentView\canvas) = 0))
		
		Protected menu = EventMenu()
		Protected undoIndex = Undo_Start(*te\undo)
		
		CopyStructure(*te\currentCursor\selection, *te\currentCursor\lastSelection, TE_POSITION)
		CopyStructure(*te\currentCursor\position, *te\currentCursor\lastPosition, TE_POSITION)
		
		Select menu
			Case #TE_Menu_Cut
				ClipBoard_Cut(*te)
			Case #TE_Menu_Copy
				ClipBoard_Copy(*te)
			Case #TE_Menu_Paste
				ClipBoard_Paste(*te)
			Case #TE_Menu_SelectAll
				Selection_SelectAll(*te)
			Case #TE_Menu_InsertComment
				ForEach *te\cursor()
					Selection_Comment(*te, *te\cursor())
				Next
			Case #TE_Menu_RemoveComment
				ForEach *te\cursor()
					Selection_Uncomment(*te, *te\cursor())
				Next
			Case #TE_Menu_FormatIndentation
				If Selection_IsAnythingSelected(*te)
					Indentation_Range(*te, *te\currentCursor\position\lineNr, *te\currentCursor\selection\lineNr, #Null, #TE_Indentation_Auto)
				Else
					Indentation_Range(*te, *te\currentCursor\position\lineNr, *te\currentCursor\position\lineNr, #Null, #TE_Indentation_Auto)
				EndIf
				Cursor_Position(*te, *te\currentCursor, *te\currentCursor\position\lineNr, 1)
			Case #TE_Menu_ToggleFold
				Folding_Toggle(*te, *te\currentCursor\position\lineNr)
			Case #TE_Menu_ToggleAllFolds
				ForEach *te\textBlock()
					Folding_Toggle(*te, *te\textBlock()\firstLineNr)
				Next
				Folding_Update(*te, -1, -1)
			Case #TE_Menu_SplitViewHorizontal
				If View_Split(*te, *te\cursorState\WindowMouseX, *te\cursorState\windowMouseY, #TE_View_SplitHorizontal)
					Draw_View(*te, *te\view)
				EndIf
			Case #TE_Menu_SplitViewVertical
				If View_Split(*te, *te\cursorState\windowMouseX, *te\cursorState\windowMouseY, #TE_View_SplitVertical)
					Draw_View(*te, *te\view)
				EndIf
			Case #TE_Menu_UnsplitView
				If View_Unsplit(*te, *te\cursorState\windowMouseX, *te\cursorState\windowMouseY)
					Draw_View(*te, *te\view)
				EndIf
		EndSelect
		
		Folding_Update(*te, -1, -1)
		Scroll_Update(*te, *te\currentView, *te\currentCursor, -1, -1)
		Draw(*te, *te\view, -1, #TE_Redraw_All)
		
		Undo_Update(*te)
		If ListSize(*te\undo\entry()) > undoIndex
			Undo_Clear(*te\redo)
		EndIf
		
		Cursor_SignalChanges(*te, *te\currentCursor)
	EndProcedure
	
	Procedure Event_Drop()
		Protected gNr = EventGadget()
		If IsGadget(gnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *view.TE_VIEW = GetGadgetData(gNr)
		ProcedureReturnIf( (*view = #Null) Or (*view\editor = #Null))
		
		Protected *te.TE_STRUCT = *view\editor
		
		
		CopyStructure(*te\currentCursor\position, *te\cursorState\dragPosition, TE_POSITION)
		*te\cursorState\dragText = EventDropText()
		*te\cursorState\state = #TE_CursorState_DragCopy
		
		DragDrop_Drop(*te)
	EndProcedure
	
	; 	Procedure Event_DropCallback(TargetHandle, State, Format, Action, x, y)
	; 		Protected gNr = GetActiveGadget();EventGadget()
	; 		If IsGadget(gnr) = 0 
	; 			ProcedureReturn #False
	; 		EndIf
	; 		
	; 		Protected *te.TE_STRUCT = GetGadgetData(gNr)
	; 		If (*te = #Null) Or GadgetType(*te\currentView\canvas) <> #PB_GadgetType_Canvas
	; 			ProcedureReturn #False
	; 		EndIf
	; 		
	; 		DragDrop_Start(*te)
	; 		
	;  		ProcedureReturn #False
	; 	EndProcedure
	
	Procedure Event_Gadget()
		Protected gNr = EventGadget()
		If IsGadget(gnr) = 0
			ProcedureReturn
		EndIf
		
		Protected *view.TE_VIEW = GetGadgetData(gNr)
		ProcedureReturnIf( (*view = #Null) Or (*view\editor = #Null))
		
		Protected *te.TE_STRUCT = *view\editor
		ProcedureReturnIf(*te = #Null)
		
		Select EventType()
			Case #PB_EventType_LeftButtonDown, #PB_EventType_KeyDown
				If *te\currentCursor And (*view <> *te\currentView)
					*te\currentView = *view
					Scroll_Update(*te, *te\currentView, *te\currentCursor, *te\currentCursor\position\lineNr, *te\currentCursor\position\charNr)
				EndIf
		EndSelect
		
		Select EventType()
				
			Case #PB_EventType_Resize
				
				; needed to avoid flickering of the screen when the gadget is resized
				Draw(*te, *view, -1, #TE_Redraw_All)
				*te\redrawMode | #TE_Redraw_All
				
			Case #PB_EventType_Input, #PB_EventType_KeyDown, #PB_EventType_KeyUp
				
				Event_Keyboard(*te, *view, EventType())
				
			Case #PB_EventType_LeftDoubleClick, #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_RightButtonDown, #PB_EventType_RightButtonUp, #PB_EventType_MiddleButtonDown, #PB_EventType_MouseMove
				
				Event_Mouse(*te, *view, EventType())
				
			Case #PB_EventType_MouseWheel
				
				Event_MouseWheel(*te, *view, EventType())
				
			Case #PB_EventType_MiddleButtonUp
				
			Case #PB_EventType_Focus
				
			Case #PB_EventType_LostFocus
				
			Case #PB_EventType_MouseEnter
				
			Case #PB_EventType_MouseLeave
				
		EndSelect
	EndProcedure
	
	DisableExplicit
EndModule

;-
;- ----------- FUNCTIONS -----------
;-

DeclareModule PBEdit
	Enumeration #PB_Event_FirstCustomValue
		#TE_Event_Cursor
		#TE_Event_Selection
		
		#TE_EventType_Add
		#TE_EventType_Change
		#TE_EventType_Remove
	EndEnumeration

	Declare PBEdit_Gadget(WindowID, X, Y, Width, Height, LanguageFile$ = "")
	Declare PBEdit_LoadSettings(ID, Path$)
	Declare PBEdit_LoadStyle(ID, Path$)
	Declare PBEdit_EnableAutoRedraw(ID, Enabled)
	
	Declare PBEdit_CountGadgetItems(ID)
	Declare PBEdit_AddGadgetItem(ID, Position, Text$)
	Declare.s PBEdit_GetGadgetText(ID)
	Declare.s PBEdit_GetGadgetItemText(ID, Position)
	Declare PBEdit_SetGadgetText(ID, Text$)
	Declare PBEdit_SetGadgetItemText(ID, Position, Text$)
	Declare PBEdit_RemoveGadgetItem(ID, Position)
	
	Declare PBEdit_GetCurrentLineNr(ID)
	Declare PBEdit_GetCurrentCharNr(ID)
	Declare PBEdit_GetCurrentColumnNr(ID)
	Declare PBEdit_SetCurrentPosition(ID, LineNr, charNr)
	Declare PBEdit_SetCurrentSelection(ID, LineNr, charNr)
	Declare.s PBEdit_GetSelectedText(ID)
	Declare PBEdit_SetText(ID, Text$)
	
	Declare PBEdit_GetFirstSelectedLineNr(ID)
	Declare PBEdit_GetFirstSelectedCharNr(ID)
	Declare PBEdit_GetLastSelectedLineNr(ID)
	Declare PBEdit_GetLastSelectedCharNr(ID)
	
	Declare PBEdit_GetCursorCount(ID)
	
	Declare PBEdit_Undo(ID)
	Declare PBEdit_Redo(ID)
EndDeclareModule

Module PBEdit
	
	UseModule _PBEdit_
	
	Global Redraw.i
	
	Procedure PBedit_Gadget(WindowID, X, Y, Width, Height, LanguageFile$ = "")
		Protected EditorID = Editor_New(WindowID, X, Y, Width, Height, LanguageFile$)
		
		Redraw = #True
		
		ProcedureReturn EditorID
	EndProcedure
	
	Procedure PBEdit_Redraw(*te.TE_STRUCT)
		If Redraw
			Draw(*te, *te\view)
		EndIf
	EndProcedure
	
	Procedure PBEdit_EnableAutoRedraw(ID, Enabled)
		Protected *te.TE_STRUCT = ID
		Redraw = Bool(Enabled > 0)
		If *te And Redraw
			Scroll_Update(*te, *te\currentView, *te\currentCursor, 0, 0)
			
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure PBEdit_LoadSettings(ID, Path$)
		Protected *te.TE_STRUCT = ID
		If *te
			Settings_OpenXml(*te, Path$)
		EndIf
	EndProcedure
	
	Procedure PBEdit_LoadStyle(ID, Path$)
		Protected *te.TE_STRUCT = ID
		If *te
			Styling_OpenXml(*te, Path$)
		EndIf
	EndProcedure
	
	Procedure PBEdit_CountGadgetItems(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			ProcedureReturn ListSize(*te\textLine())
		EndIf
	EndProcedure
	
	Procedure PBEdit_AddGadgetItem(ID, Position, Text$)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected lineNr
			
			Undo_Start(*te\undo)
			If Position < 0
				If Textline_FromLine(*te, ListSize(*te\textLine()))
					lineNr = ListIndex(*te\textLine())
					If (lineNr <= 0) And (*te\textLine()\text = "")
						lineNr = 1
					Else
						lineNr + 1
						Text$ = *te\newLineText + Text$
					EndIf
					
					Cursor_Position(*te, *te\currentCursor, lineNr, Textline_Length(*te\textLine()) + 1)
					Textline_AddText(*te, *te\currentCursor, @Text$, Len(Text$), #TE_Styling_All, *te\undo)
				EndIf
			ElseIf Textline_FromLine(*te, Position + 1)
				Text$ = Text$ + *te\newLineText
				Cursor_Position(*te, *te\currentCursor, Position + 1, 1)
				Textline_AddText(*te, *te\currentCursor, @Text$, Len(Text$), #TE_Styling_All, *te\undo)
			EndIf
			Undo_Update(*te)
			
			Folding_Update(*te, -1, -1)
			
			If Redraw
				Scroll_Update(*te, *te\currentView, *te\currentCursor, 0, 0)
			EndIf
			
			Selection_Clear(*te, *te\currentCursor)
			
			Undo_Update(*te)
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure.s PBEdit_GetGadgetText(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			ProcedureReturn Text_Get(*te, 1, 1, ListSize(*te\textLine()), Textline_Length(LastElement(*te\textLine())) + 1)
		EndIf
	EndProcedure
	
	Procedure.s PBEdit_GetGadgetItemText(ID, Position)
		Protected *te.TE_STRUCT = ID
		If *te
			If Textline_FromLine(*te, Position + 1)
				ProcedureReturn *te\textLine()\text
			EndIf
		EndIf
		ProcedureReturn ""
	EndProcedure
	
	Procedure PBEdit_SetGadgetText(ID, Text$)
		Protected *te.TE_STRUCT = ID
		If *te
			;Undo_Start(*te\undo)
			Selection_SelectAll(*te)
			Selection_Delete(*te, *te\currentCursor, *te\undo)
			If FirstElement(*te\textLine())
				Textline_AddText(*te, *te\currentCursor, @Text$, Len(Text$), #TE_Styling_UpdateFolding | #TE_Styling_UpdateIndentation);, *te\undo)
			EndIf
			;			Undo_Update(*te)
			Undo_Clear(*te\undo)
			Undo_Clear(*te\redo)
			
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure PBEdit_SetGadgetItemText(ID, Position, Text$)
		Protected *te.TE_STRUCT = ID
		If *te
			If Textline_FromLine(*te, Position + 1)
				Undo_Start(*te\undo)
				Textline_SetText(*te, *te\textLine(), Text$, #TE_Styling_All, *te\undo)
				Cursor_Position(*te, *te\currentCursor, ListIndex(*te\textLine()) + 1, Len(Text$) + 1)
				Selection_Clear(*te, *te\currentCursor)
				Undo_Update(*te)
				
				PBEdit_Redraw(*te)
			EndIf
		EndIf
	EndProcedure
	
	Procedure PBEdit_RemoveGadgetItem(ID, Position)
		Protected *te.TE_STRUCT = ID
		If *te
			If Textline_FromLine(*te, Position + 1)
				Undo_Start(*te\undo)
				Cursor_Position(*te, *te\currentCursor, ListIndex(*te\textLine()), 1)
				Selection_SetRange(*te, *te\currentCursor, *te\currentCursor\position\lineNr + 1, 1)
				Selection_Delete(*te, *te\currentCursor, *te\undo)
				Undo_Update(*te)
				
				Folding_Update(*te, -1, -1)
				
				If Redraw
					Scroll_Update(*te, *te\currentView, *te\currentCursor, 0, 0)
				EndIf
				
				Selection_Clear(*te, *te\currentCursor)
				
				PBEdit_Redraw(*te)
			EndIf
		EndIf
	EndProcedure
	
	Procedure PBEdit_GetCurrentLineNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te And *te\currentCursor
			ProcedureReturn *te\currentCursor\position\lineNr
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetCurrentCharNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te And *te\currentCursor
			ProcedureReturn *te\currentCursor\position\charNr
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetCurrentColumnNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te And *te\currentView And *te\currentCursor
			ProcedureReturn Textline_ColumnFromCharNr(*te, *te\currentView, *te\currentcursor\position\textline, *te\currentCursor\position\charNr)
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_SetCurrentPosition(ID, LineNr, charNr)
		Protected *te.TE_STRUCT = ID
		If *te
			Cursor_Position(*te, *te\currentCursor, LineNr, charNr)
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure PBEdit_SetCurrentSelection(ID, LineNr, charNr)
		Protected *te.TE_STRUCT = ID
		If *te
			Selection_SetRange(*te, *te\currentCursor, LineNr, charNr)
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure.s PBEdit_GetSelectedText(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected selection.TE_RANGE
			If Selection_Get(*te\currentCursor, selection)
				ProcedureReturn Text_Get(*te, selection\pos1\lineNr, selection\pos1\charNr, selection\pos2\lineNr, selection\pos2\charNr)
			EndIf
		EndIf
		ProcedureReturn ""
	EndProcedure
	
	Procedure PBEdit_SetText(ID, Text$)
		Protected *te.TE_STRUCT = ID
		If *te And *te\currentCursor
			Undo_Start(*te\undo)
			Selection_Delete(*te, *te\currentCursor, *te\undo)
			Textline_AddText(*te, *te\currentCursor, @Text$, Len(Text$), #TE_Styling_All, *te\undo)
			Selection_Clear(*te, *te\currentCursor)
			Undo_Update(*te)
			
			Folding_Update(*te, 0, 0)
			
			If Redraw
				Scroll_Update(*te, *te\currentView, *te\currentCursor, 0, 0)
			EndIf
			
			PBEdit_Redraw(*te)
		EndIf
	EndProcedure
	
	Procedure PBEdit_GetFirstSelectedLineNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected selection.TE_RANGE
			If Selection_Get(*te\currentCursor, selection)
				ProcedureReturn selection\pos1\lineNr
			EndIf
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetFirstSelectedCharNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected selection.TE_RANGE
			If Selection_Get(*te\currentCursor, selection)
				ProcedureReturn selection\pos1\charNr
			EndIf
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetLastSelectedLineNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected selection.TE_RANGE
			If Selection_Get(*te\currentCursor, selection)
				ProcedureReturn selection\pos2\lineNr
			EndIf
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetLastSelectedCharNr(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			Protected selection.TE_RANGE
			If Selection_Get(*te\currentCursor, selection)
				ProcedureReturn selection\pos2\charNr
			EndIf
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_GetCursorCount(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			ProcedureReturn ListSize(*te\cursor())
		EndIf
		ProcedureReturn 0
	EndProcedure
	
	Procedure PBEdit_Undo(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			If Undo_Do(*te, *te\undo, *te\redo)
				PBEdit_Redraw(*te)
			EndIf
		EndIf
	EndProcedure
	
	Procedure PBEdit_Redo(ID)
		Protected *te.TE_STRUCT = ID
		If *te
			If Undo_Do(*te, *te\redo, *te\undo)
				PBEdit_Redraw(*te)
			EndIf
		EndIf
	EndProcedure
	
	UnuseModule _PBEdit_
EndModule

; *** TEST *** TEST *** TEST *** TEST *** TEST *** TEST *** TEST *** TEST *** TEST 

UseModule PBEdit

Enumeration 1
	#tlb_undo
	#tlb_redo
EndEnumeration

OpenWindow(0, 0, 0, 800, 600, "TextEditor", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget );| #PB_Window_Maximize)

CreateToolBar(0, WindowID(0))
; ToolBarStandardButton(#tlb_undo, #PB_ToolBarIcon_Undo)
; ToolBarStandardButton(#tlb_redo, #PB_ToolBarIcon_Redo)
CreateStatusBar(0, WindowID(0))
AddStatusBarField(DesktopScaledX(200))
AddStatusBarField(DesktopScaledX(200))
AddStatusBarField(DesktopScaledX(500))
AddStatusBarField(DesktopScaledX(200))
WindowBounds(0, 100, 100, #PB_Ignore, #PB_Ignore)

editor = PBedit_Gadget(0, 5, ToolBarHeight(0), WindowWidth(0) - 10, WindowHeight(0) - (ToolBarHeight(0) + MenuHeight() + StatusBarHeight(0)))
If editor = 0
	MessageRequester("", "Error") : End
EndIf

PBEdit_LoadSettings(editor, "PBEdit_Color.xml")
PBEdit_LoadStyle(editor, "PBEdit_PureBasic.xml")

Repeat
	Select WaitWindowEvent()
		Case #PB_Event_CloseWindow
			If EventWindow() = 0
				End
			EndIf
		Case #PB_Event_SizeWindow
			If editor And (EventWindow() = 0)
				_PBEdit_::Event_Resize(editor, #PB_Ignore, #PB_Ignore, WindowWidth(0) - 10, WindowHeight(0) - (ToolBarHeight(0) + MenuHeight() + StatusBarHeight(0)))
			EndIf
		Case #PB_Event_Menu
			If EventMenu() = #tlb_undo
				PBEdit_Undo(editor)
			ElseIf EventMenu() = #tlb_redo
				PBEdit_Redo(editor)
			EndIf
			
		; --- custom events ---
		Case #TE_Event_Cursor
			If EventType() = #TE_EventType_Change
				StatusBarText(0, 0, "Line: " + Str(PBEdit_GetCurrentLineNr(editor)) + 
				                    "  Column: " + Str(PBEdit_GetCurrentColumnNr(editor)) + 
				                    "  (Char: " + Str(PBEdit_GetCurrentCharNr(editor)) + ")")
			ElseIf EventType() = #TE_EventType_Add Or EventType() = #TE_EventType_Remove
				StatusBarText(0, 2, "Cursors: " + Str(PBEdit_GetCursorCount(editor)))
			EndIf
		Case #TE_Event_Selection
			If EventType() = #TE_EventType_Remove
				StatusBarText(0, 1, "")
			ElseIf EventType() = #TE_EventType_Change
				StatusBarText(0, 1, "Selection [" + 
				                    Str(PBEdit_GetFirstSelectedLineNr(editor)) + ", " + 
				                    Str(PBEdit_GetFirstSelectedCharNr(editor)) + "] [" + 
				                    Str(PBEdit_GetLastSelectedLineNr(editor)) + ", " + 
				                    Str(PBEdit_GetLastSelectedCharNr(editor)) + "]")
			EndIf
	EndSelect
ForEver
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 9680
; FirstLine = 9675
; Folding = ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Optimizer
; EnableXP