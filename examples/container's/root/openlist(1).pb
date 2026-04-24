IncludePath "../../../"
XIncludeFile "widgets.pbi"
UseWidgets( )
  

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Define *r1 = Open(0, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu)
  
  Open(1, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu)
  If *r1
    ; Button( 30, 55, 120,20,"openlist2")
    ; CloseList()
  EndIf
  
  OpenList(*r1)
  Button(30, 15, 120, 24,"openlist1")
  CloseList()
  
  If Open(2, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu)
     CloseList()
  EndIf
  
  Button( 30, 55, 120,20,"openlist2")
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile = 99 
  EnableExplicit
  Global *w, *w1, *w2
  
  If Open(0, 100, 0, 180, 130, "openlist1", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button1")
    *w = Root()
  EndIf
  
  If Open(1, 300, 0, 180, 130, "openlist2", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button2")
  EndIf
  
  OpenList(*w)
  Button(30, 15, 120, 24,"openlist1")
  CloseList()
  
  If Open(2, 500, 0, 180, 130, "openlist3", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button3")
    CloseList()
  EndIf
  
  Button( 30, 55, 120,20,"openlist2")
  
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.30 - C Backend (MacOS X - x64)
; CursorPosition = 25
; FirstLine = 3
; Folding = --
; EnableXP