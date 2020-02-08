IncludePath "../"
XIncludeFile "widgets().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule widget
  Global *w, *w1, *w2
  
  If Open(#PB_Any, 100, 0, 180, 210, "openlist1", #PB_Window_SystemMenu)
    ;SetWindowTitle(GetWindow(root()), "openlist1")
    Button( 50, 95, 80,20,"button")
    *w = root()
  EndIf
  
  If Open(#PB_Any, 300, 0, 180, 210, "openlist2", #PB_Window_SystemMenu)
    ;SetWindowTitle(GetWindow(root()), "openlist2")
    Button( 50, 95, 80,20,"button")
    ;*w1 = root()
  EndIf
  
  OpenList(*w)
  Combobox(10, 15, 80, 24)
  AddItem(widget(), -1, "Combobox")
  SetState(widget(), 0)
  CloseList()
  
  If Open(#PB_Any, 500, 0, 180, 210, "openlist3", #PB_Window_SystemMenu)
    ;SetWindowTitle(GetWindow(root()), "openlist3")
    Button( 50, 95, 80,20,"button")
    ;*w2 = root()
    CloseList()
  EndIf
  
  
  Button( 50, 55, 80,20,"button (open)")
  
  ;ReDraw(*w)
  ;ReDraw(*w1)
  ;ReDraw(*w2)
  
  ReDraw(Root())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP