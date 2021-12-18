IncludePath "../../" : XIncludeFile "widgets.pbi"
; XIncludeFile "../empty5.pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseLib(widget)
  EnableExplicit
  
Define text.s = "abc" + Chr( 10 ) + "def" + Chr( 10 ) + "ghi" + Chr( 10 ) + "jkl" + Chr( 10 ) + "mno" + Chr( 10 ) + "pqr" + Chr( 10 ) + "stu" + Chr( 10 ) + "vwxyz"

#WINDOW = 0
#TEXT_GADGET = 0

Define *w._S_widget, text_gadget_width = 500

If OpenWindow( #WINDOW, 0, 0, text_gadget_width + 20, 400, "TextGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  Open( #WINDOW )
  *w = Text( 10,  10, text_gadget_width, 200, text.s, #__Text_Border )
	;*w = Editor( 10,  10, text_gadget_width, 200, #__Text_Border ):   SetText(*w, text.s )
	Redraw( *w )
	
	Debug Height( *w, #__c_Required )
	Resize( *w, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height( *w, #__c_Required ) )
	
	Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
EndIf
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP