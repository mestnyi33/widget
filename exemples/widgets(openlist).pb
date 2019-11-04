IncludePath "../"
XIncludeFile "widgets().pbi"


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  Global *w, *w1, *w2
  
  If Open(#PB_Any, 100, 0, 180, 210, "", #PB_Flag_BorderLess | #PB_Window_SystemMenu)
    SetWindowTitle(GetWindow(Root()), "openlist1")
    Button( 50, 95, 80,20,"button")
    *w = Root()
  EndIf
  
  If Open(#PB_Any, 300, 0, 180, 210, "", #PB_Flag_BorderLess | #PB_Window_SystemMenu)
    SetWindowTitle(GetWindow(Root()), "openlist2")
    Button( 50, 95, 80,20,"button")
    *w1 = Root()
  EndIf
  
  
  OpenList(*w)
  Combobox(10, 15, 80, 24)
  AddItem(Widget(), -1, "Combobox")
  SetState(Widget(), 0)
  CloseList()
  
  If Open(#PB_Any, 500, 0, 180, 210, "", #PB_Flag_BorderLess | #PB_Window_SystemMenu)
    SetWindowTitle(GetWindow(Root()), "openlist3")
    Button( 50, 95, 80,20,"button")
    *w2 = Root()
    CloseList()
  EndIf
  
  
  Button( 50, 55, 80,20,"button (open)")
  
  ;ReDraw(*w)
  ;ReDraw(*w1)
  ;ReDraw(*w2)
  
  ReDraw(Root())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP