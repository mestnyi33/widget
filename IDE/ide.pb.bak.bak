XIncludeFile "ide(form).pb"
XIncludeFile "ide(code).pb"

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile 
  
  ide_open()
  
  Define *window = widget_add(ide_design_MDI, "window", 30, 30, 400, 250)
   
  Define event
  Repeat 
    event = WaitWindowEvent() 
    
    Select EventWindow()
      Case ide_window 
        ide_events()
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS - C Backend (MacOS X - x64)
; CursorPosition = 8
; Folding = -
; EnableXP