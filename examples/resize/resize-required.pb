IncludePath "../../" : XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   EnableExplicit
   
   ;Define Text.s = "abc" + Chr( 10 ) + "def" + Chr( 10 ) + "ghi" + Chr( 10 ) + "jkl" + Chr( 10 ) + "mno" + Chr( 10 ) + "pqr" + Chr( 10 ) + "stu" + Chr( 10 ) + "vwxyz"
   Define Text.s = "abc" + "def" + "ghi" + "jkl" + "mno" + "pqr" + "stu" + "vwxyz"
   
   #WINDOW = 0
   #TEXT_GADGET = 0
   
   Define *widget._S_widget, *gadget, text_gadget_width = 300
   
   If Open( #WINDOW, 0, 0, text_gadget_width*2 + 30, 100, "TextGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      ;*gadget = TextGadget(-1, 10,  10, text_gadget_width, 80, text.s, #PB_Text_Border )
      *gadget = StringGadget(-1, 10,  10, text_gadget_width, 80, Text.s )
      
      ;*widget = Text( text_gadget_width+20,  10, text_gadget_width, 80, text.s )
      *widget = String( text_gadget_width+20,  10, text_gadget_width, 80, Text.s )
      
      ReDraw(Root())
      
      Define widget_required_width = Width( *widget, #__c_Required )
      Define gadget_required_width = GadgetWidth( *gadget, #PB_Gadget_RequiredSize )
      Define widget_required_height = Height( *widget, #__c_Required )
      Define gadget_required_height = GadgetHeight( *gadget, #PB_Gadget_RequiredSize )
      
      Debug ""+ gadget_required_width +"x"+ gadget_required_height +" - gadget required size "+ #LF$+
            ""+ widget_required_width +"x"+ widget_required_height +" - widget required size "
      
      ResizeGadget( *gadget, #PB_Ignore, #PB_Ignore, gadget_required_width, gadget_required_height )
      Resize( *widget, #PB_Ignore, #PB_Ignore, widget_required_width, widget_required_height )
      
      Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow
   EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 32
; FirstLine = 13
; Folding = -
; EnableXP
; DPIAware