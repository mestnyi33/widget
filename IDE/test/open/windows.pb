If OpenWindow(0, 0, 0, 200, 200, "Главное окно", #PB_Window_ScreenCentered)
;    Window_1 = OpenWindow(#PB_Any, 0, 0, 200, 200, "Первое окно")
;    
;    Window_2 = OpenWindow(#PB_Any, 200, 0, 200, 200, "Второе окно")
   
   Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; DPIAware