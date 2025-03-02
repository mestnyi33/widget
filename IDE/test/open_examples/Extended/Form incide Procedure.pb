Enumeration FormWindow
  #Window_Form1
  #Window_Form2
EndEnumeration

Procedure OpenWindow_Form1()
  If OpenWindow(#Window_Form1, 0, 0, 150, 150, "Окно 1")
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(#Window_Form1)
  EndIf
EndProcedure
Procedure OpenWindow_Form2()
  If OpenWindow(#Window_Form2, 150, 0, 150, 150, "Окно 2")
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(#Window_Form2)
  EndIf
EndProcedure

Enumeration FormWindow
  #Window_Form3
EndEnumeration

Procedure OpenWindow_Form3()
  If OpenWindow(#Window_Form3, 300, 0, 150, 150, "Окно 3")
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(#Window_Form3)
  EndIf
EndProcedure

Global Window_Form4, Window_Form5
Procedure OpenWindow_Form4()
  Window_Form4=OpenWindow(#PB_Any, 0, 150, 150, 150, "Окно 1")
  If Window_Form4
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(Window_Form4)
  EndIf
EndProcedure
Procedure OpenWindow_Form5()
  Window_Form5=OpenWindow(#PB_Any, 150, 150, 150, 150, "Окно 1")
  If Window_Form5
    
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(Window_Form5)
  EndIf
EndProcedure

Global Window_Form6
Procedure OpenWindow_Form6()
  Window_Form6=OpenWindow(#PB_Any, 300, 150, 150, 150, "Окно 1")
  If Window_Form6
    
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
    CloseWindow(Window_Form6)
  EndIf
EndProcedure

OpenWindow_Form1()
OpenWindow_Form2()
OpenWindow_Form3()
OpenWindow_Form4()
OpenWindow_Form5()
OpenWindow_Form6()
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 43
; FirstLine = 11
; Folding = --
; EnableXP
; CompileSourceDirectory