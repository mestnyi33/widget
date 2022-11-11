IncludePath "../../../"
;XIncludeFile "widgets.pbi"
XIncludeFile "widget-events.pbi"
UseLib(widget)
  

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Global *w, *w1, *w2
  
  If Open(OpenWindow(#PB_Any, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu));: bind(-1,-1)
    Button( 50, 95, 80,20,"button1")
    *w = Root()
  EndIf
  
  If Open(OpenWindow(#PB_Any, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu));: bind(-1,-1)
    Button( 50, 95, 80,20,"button2")
  EndIf
  
  OpenList(*w)
  Button(30, 15, 120, 24,"openlist1")
  CloseList()
  
  If Open(OpenWindow(#PB_Any, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu));: bind(-1,-1)
    Button( 50, 95, 80,20,"button3")
    CloseList()
  EndIf
  
  
  Button( 30, 55, 120,20,"openlist2")
  
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP