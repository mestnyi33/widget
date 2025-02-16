OpenWindow(#PB_Any, 0, 0, 400, 210, "Окно", #PB_Window_ScreenCentered)
For i=1 To 2
  For j=1 To 7
    TextGadget(#PB_Any, 200*(i-1), 30*(j-1), 200, 26,    "Столбик "+Str(i)+"; cтрока "+Str(j),  #PB_Text_Border|#PB_Text_Center)
  Next
Next
Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic 5.60 (Windows - x86)
; EnableXP
; CompileSourceDirectory