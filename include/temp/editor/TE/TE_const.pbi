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
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; EnableXP