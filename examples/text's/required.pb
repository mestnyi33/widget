IncludePath "../../" : XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseLib(widget)
   EnableExplicit
   
   Define text.s = "abc" + Chr( 10 ) + "def" + Chr( 10 ) + "ghi" + Chr( 10 ) + "jkl" + Chr( 10 ) + "mno" + Chr( 10 ) + "pqr" + Chr( 10 ) + "stu" + Chr( 10 ) + "vwxyz"
   
   #WINDOW = 0
   #TEXT_GADGET = 0
   
   Define *widget._S_widget, *gadget, text_gadget_width = 300
   
   If Open( #WINDOW, 0, 0, text_gadget_width*2 + 30, 100, "TextGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;*gadget = TextGadget(-1, 10,  10, text_gadget_width, 80, text.s, #PB_Text_Border )
      *gadget = StringGadget(-1, 10,  10, text_gadget_width, 80, text.s, #PB_Text_Border )
      
      *widget = Text( text_gadget_width+20,  10, text_gadget_width, 80, text.s )
      
      ;Redraw( *widget )
      
      Define widget_required_size = Height( *widget, #__c_Required )
      Define gadget_required_size = GadgetHeight( *gadget, #PB_Gadget_RequiredSize )
      
      Debug ""+ gadget_required_size +" "+ widget_required_size
      ResizeGadget( *gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, gadget_required_size )
      Resize( *widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, widget_required_size )
      
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 18
; Folding = -
; EnableXP