Enumeration FormWindow
  #Window_1
  #Window_2
EndEnumeration

OpenWindow(#Window_1, 0, 0, 200, 200, "Первое окно")

OpenWindow(#Window_2, 200, 0, 200, 200, "Второе окно")

Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 8
; EnableXP
; DPIAware