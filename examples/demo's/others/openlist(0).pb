IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  Global *w, *w1, *w2
  
  If OpenRootWidget(0, 100, 0, 800, 600, "openlist demo", #PB_Window_SystemMenu)
    
    *w = WindowWidget(100, 100, 180, 130, "openlist1", #__Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button1")
    
    WindowWidget(300, 100, 180, 130, "openlist2", #__Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button2")
    
    OpenWidgetList(*w)
    ButtonWidget(30, 15, 120, 24,"openlist1")
    CloseWidgetList()
    
    WindowWidget(500, 100, 180, 130, "openlist3", #__Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button3")
    CloseWidgetList()
    
    
    ButtonWidget( 30, 55, 120,20,"openlist2")
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP