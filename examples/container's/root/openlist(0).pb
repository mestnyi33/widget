﻿IncludePath "../../../"
XIncludeFile "widgets.pbi"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseWidgets( )
  EnableExplicit
  Global *w, *w1, *w2
  
  If Open(0, 100, 0, 800, 600, "openlist demo", #PB_Window_SystemMenu)
    
    *w = Window(100, 100, 180, 130, "openlist1", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button1")
    
    Window(300, 100, 180, 130, "openlist2", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button2")
    
    OpenList(*w)
    Button(30, 15, 120, 24,"openlist1")
    CloseList()
    
    Window(500, 100, 180, 130, "openlist3", #PB_Window_SystemMenu)
    Button( 50, 95, 80,20,"button3")
    CloseList()
    
    
    Button( 30, 55, 120,20,"openlist2")
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; CursorPosition = 9
; Folding = -
; EnableXP