XIncludeFile "ide(form).pb"
XIncludeFile "ide(code).pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  Define event
  ide_open()
  Define *window = widget_add(w_ide_design_MDI, "window", 30, 30, 400, 250)
   
  Repeat 
    event = WaitWindowEvent() 
    
    Select EventWindow()
      Case ide_window 
        ide_events()
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS - C Backend (MacOS X - x64)
; CursorPosition = 13
; Folding = -
; EnableXP