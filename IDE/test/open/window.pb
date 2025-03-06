OpenWindow(-1, 10, 10, 400, 210, "read id$(-1)", #PB_Window_ScreenCentered)
OpenWindow( - 1, 20, 50, 400, 210, "read id$( - 1)", #PB_Window_ScreenCentered)
OpenWindow(#PB_Any, 30, 90, 400, 210, "read id$(#PB_Any)", #PB_Window_ScreenCentered)
; For i=1 To 2
;   For j=1 To 7
;     TextGadget(#PB_Any, 200*(i-1), 30*(j-1), 200, 26,    "Столбик "+Str(i)+"; cтрока "+Str(j),  #PB_Text_Border|#PB_Text_Center)
;   Next
; Next
Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 2
; EnableXP
; DPIAware