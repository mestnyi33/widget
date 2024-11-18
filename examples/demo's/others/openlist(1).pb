IncludePath "../../../"
XIncludeFile "widgets.pbi"
UseWidgets( )
  

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global *w, *w1, *w2
  
  If OpenRoot(0, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button1")
    *w = Root()
  EndIf
  
  If OpenRoot(1, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button2")
  EndIf
  
  OpenWidgetList(*w)
  ButtonWidget(30, 15, 120, 24,"openlist1")
  CloseWidgetList()
  
  If OpenRoot(2, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu)
    ButtonWidget( 50, 95, 80,20,"button3")
    CloseWidgetList()
  EndIf
  
  
  ButtonWidget( 30, 55, 120,20,"openlist2")
  
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 23
; Folding = -
; EnableXP