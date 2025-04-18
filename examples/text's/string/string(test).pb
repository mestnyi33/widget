﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
   
   EnableExplicit
   UseWidgets( )
   
   Enumeration
      #window
   EndEnumeration
   
   Global i = 5,*g._S_WIDGET
   
   OpenWindow(#window, 0, 0, 300, 300, "string", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
   
   ;\\ Open Root
   Define *root._S_WIDGET = Open(#window, 10, 10, 300 - 20, 300 - 20): *root\class = "root": SetText(*root, "root")
   
   *g = String(10, 220, 200, 50, "string gadget text text 1234567890 text text long long very long", #PB_String_Password | #__flag_text_Right)
   
   Procedure button_panel_events( )
      Select GetText( EventWidget( ) )
         Case "1"
            Resize(*g, #PB_Ignore, Y(*g)-i, #PB_Ignore, Height(*g)+i)
         Case "2"
            Resize(*g, #PB_Ignore, Y(*g)+i, #PB_Ignore, Height(*g)-i)
            
      EndSelect
   EndProcedure
   Bind(Button( 220, 220, 25, 50, "1"), @button_panel_events( ), #__event_LeftClick )
   Bind(Button( 220 + 25, 220, 25, 50, "2"), @button_panel_events( ), #__event_LeftClick )
   
   WaitClose( )
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 18
; FirstLine = 10
; Folding = -
; EnableXP