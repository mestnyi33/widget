CompilerIf #PB_Compiler_IsMainFile
  OpenWindow(#PB_Any, 550, 300, 328, 328, "window", #PB_Window_SystemMenu)
  
  
  Repeat 
    event = WaitWindowEvent()

    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableXP